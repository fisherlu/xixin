const express = require('express');
const { v4: uuid } = require('uuid');
const { users, subscriptions, sessions, stats: statsDb } = require('../db/database');
const { authMiddleware } = require('../middleware/auth');

const router = express.Router();
router.use(authMiddleware);

// GET /api/user/profile
router.get('/profile', (req, res) => {
  const user = users.find(u => u.id === req.userId);
  if (!user) return res.status(404).json({ error: '用户不存在' });

  const userStats = statsDb.find(s => s.user_id === req.userId) || {};
  const now = new Date().toISOString();
  const sub = subscriptions.findAll(s =>
    s.user_id === req.userId && s.status === 'active' && s.expires_at > now
  ).sort((a, b) => b.expires_at.localeCompare(a.expires_at))[0] || null;

  res.json({
    user: {
      id: user.id, email: user.email, phone: user.phone,
      name: user.name, avatar: user.avatar, created_at: user.created_at,
      is_admin: user.is_admin === 1,
    },
    stats: {
      total_minutes: userStats.total_minutes || 0,
      total_sessions: userStats.total_sessions || 0,
      streak_days: userStats.streak_days || 0,
    },
    subscription: sub ? {
      plan_name: sub.plan_name, platform: sub.platform,
      expires_at: sub.expires_at, auto_renew: sub.auto_renew === 1,
      status: sub.status,
    } : null,
    is_premium: sub ? sub.expires_at > now : false,
  });
});

// PUT /api/user/profile
router.put('/profile', (req, res) => {
  const { name, avatar } = req.body;
  users.update(u => u.id === req.userId, {
    name, avatar: avatar || null,
    updated_at: new Date().toISOString(),
  });
  res.json({ success: true });
});

// POST /api/user/sessions
router.post('/sessions', (req, res) => {
  const { meditation_id, title, duration_seconds } = req.body;
  const id = uuid();

  sessions.insert({
    id, user_id: req.userId, meditation_id, title,
    duration_seconds, completed: 1,
    created_at: new Date().toISOString(),
  });

  // Update stats
  const existing = statsDb.find(s => s.user_id === req.userId);
  const addedMinutes = Math.ceil(duration_seconds / 60);
  statsDb.upsert(
    s => s.user_id === req.userId,
    {
      user_id: req.userId,
      total_minutes: (existing?.total_minutes || 0) + addedMinutes,
      total_sessions: (existing?.total_sessions || 0) + 1,
      last_session_date: new Date().toISOString().slice(0, 10),
      streak_days: existing?.streak_days || 1,
    }
  );

  res.json({ success: true, id });
});

// GET /api/user/sessions
router.get('/sessions', (req, res) => {
  const limit = parseInt(req.query.limit) || 20;
  const result = sessions.findAll(s => s.user_id === req.userId)
    .sort((a, b) => b.created_at.localeCompare(a.created_at))
    .slice(0, limit);
  res.json(result);
});

module.exports = router;