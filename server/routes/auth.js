const express = require('express');
const bcrypt = require('bcryptjs');
const { v4: uuid } = require('uuid');
const { users, stats: statsDb } = require('../db/database');
const { generateToken } = require('../middleware/auth');

const router = express.Router();

// POST /api/auth/register
router.post('/register', (req, res) => {
  const { email, password, name, phone } = req.body;

  if (!email || !password || password.length < 6) {
    return res.status(400).json({ error: '邮箱和密码不能为空，密码至少6位' });
  }

  if (users.find(u => u.email === email)) {
    return res.status(409).json({ error: '该邮箱已注册' });
  }

  const id = uuid();
  const hash = bcrypt.hashSync(password, 10);
  const userName = name || email.split('@')[0];

  users.insert({
    id, email, phone: phone || null, password_hash: hash,
    name: userName, avatar: null, is_admin: 0,
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString(),
  });

  statsDb.insert({
    user_id: id, total_minutes: 0, total_sessions: 0,
    streak_days: 0, last_session_date: null,
  });

  const token = generateToken(id);
  res.status(201).json({
    token,
    user: { id, email, name: userName, phone: phone || '' },
    trial_days: 7,
  });
});

// POST /api/auth/login
router.post('/login', (req, res) => {
  const { email, password } = req.body;

  const user = users.find(u => u.email === email);
  if (!user || !bcrypt.compareSync(password, user.password_hash)) {
    return res.status(401).json({ error: '邮箱或密码错误' });
  }

  const token = generateToken(user.id, user.is_admin === 1);
  res.json({
    token,
    user: { id: user.id, email: user.email, name: user.name, phone: user.phone || '', is_admin: user.is_admin === 1 },
  });
});

// POST /api/auth/phone-login
router.post('/phone-login', (req, res) => {
  const { phone, code } = req.body;

  if (!phone || phone.length < 11) {
    return res.status(400).json({ error: '请输入正确的手机号' });
  }
  if (code !== '123456') {
    return res.status(400).json({ error: '验证码错误' });
  }

  let user = users.find(u => u.phone === phone);
  if (!user) {
    const id = uuid();
    user = {
      id, email: `phone_${phone}@xixin.app`, phone,
      password_hash: bcrypt.hashSync(phone, 10),
      name: `用户${phone.slice(-4)}`, avatar: null, is_admin: 0,
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    };
    users.insert(user);
    statsDb.insert({ user_id: id, total_minutes: 0, total_sessions: 0, streak_days: 0, last_session_date: null });
  }

  const token = generateToken(user.id);
  res.json({
    token,
    user: { id: user.id, email: user.email, name: user.name, phone: user.phone || '' },
  });
});

module.exports = router;