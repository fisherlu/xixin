const express = require('express');
const { users, subscriptions, sessions } = require('../db/database');
const { authMiddleware, adminMiddleware } = require('../middleware/auth');

const router = express.Router();
router.use(authMiddleware, adminMiddleware);

// GET /api/admin/stats
router.get('/stats', (req, res) => {
  const totalUsers = users.count();
  const now = new Date().toISOString();
  const activeSubs = subscriptions.count(s => s.status === 'active' && s.expires_at > now);
  const totalSessions = sessions.count();
  const allSessions = sessions.getAll();
  const totalSeconds = allSessions.reduce((sum, s) => sum + (s.duration_seconds || 0), 0);

  const monthlyUsers = subscriptions.count(s => s.plan_id === 'xixin_monthly' && s.status === 'active');
  const yearlyUsers = subscriptions.count(s => s.plan_id === 'xixin_yearly' && s.status === 'active');
  const lifetimeUsers = subscriptions.count(s => s.plan_id === 'xixin_lifetime' && s.status === 'active');

  const estimatedRevenue = Math.round(monthlyUsers * 19.9 + yearlyUsers * 149 + lifetimeUsers * 298);

  res.json({
    total_users: totalUsers,
    active_subscriptions: activeSubs,
    total_sessions: totalSessions,
    total_minutes: Math.ceil(totalSeconds / 60),
    estimated_revenue: estimatedRevenue,
    plan_breakdown: { monthly: monthlyUsers, yearly: yearlyUsers, lifetime: lifetimeUsers },
    conversion_rate: totalUsers > 0 ? (activeSubs / totalUsers * 100).toFixed(1) + '%' : '0%',
  });
});

// GET /api/admin/users
router.get('/users', (req, res) => {
  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || 20;

  const allUsers = users.getAll().sort((a, b) => b.created_at.localeCompare(a.created_at));
  const total = allUsers.length;
  const start = (page - 1) * limit;

  const result = allUsers.slice(start, start + limit).map(u => {
    const now = new Date().toISOString();
    const sub = subscriptions.findAll(s => s.user_id === u.id && s.status === 'active' && s.expires_at > now)
      .sort((a, b) => b.expires_at.localeCompare(a.expires_at))[0] || null;
    return {
      id: u.id, email: u.email, name: u.name, created_at: u.created_at,
      plan_name: sub?.plan_name || null,
      expires_at: sub?.expires_at || null,
      sub_status: sub?.status || null,
    };
  });

  res.json({
    users: result,
    pagination: { page, limit, total, total_pages: Math.ceil(total / limit) },
  });
});

module.exports = router;