const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET || 'xixin_jwt_secret_dev';

function authMiddleware(req, res, next) {
  const header = req.headers.authorization;
  if (!header || !header.startsWith('Bearer ')) {
    return res.status(401).json({ error: '未登录' });
  }

  try {
    const token = header.split(' ')[1];
    const decoded = jwt.verify(token, JWT_SECRET);
    req.userId = decoded.userId;
    req.isAdmin = decoded.isAdmin || false;
    next();
  } catch (e) {
    return res.status(401).json({ error: '登录已过期' });
  }
}

function adminMiddleware(req, res, next) {
  if (!req.isAdmin) {
    return res.status(403).json({ error: '无权限' });
  }
  next();
}

function generateToken(userId, isAdmin = false) {
  return jwt.sign({ userId, isAdmin }, JWT_SECRET, { expiresIn: '30d' });
}

module.exports = { authMiddleware, adminMiddleware, generateToken };