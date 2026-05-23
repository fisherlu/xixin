const express = require('express');
const { v4: uuid } = require('uuid');
const { subscriptions, receipts } = require('../db/database');
const { authMiddleware } = require('../middleware/auth');

const router = express.Router();
router.use(authMiddleware);

// GET /api/subscription/status
router.get('/status', (req, res) => {
  const now = new Date().toISOString();
  const sub = subscriptions.findAll(s =>
    s.user_id === req.userId && s.status === 'active' && s.expires_at > now
  ).sort((a, b) => b.expires_at.localeCompare(a.expires_at))[0] || null;

  res.json({
    is_premium: !!sub,
    subscription: sub ? {
      plan_name: sub.plan_name, platform: sub.platform,
      expires_at: sub.expires_at, auto_renew: sub.auto_renew === 1,
    } : null,
  });
});

// POST /api/subscription/activate
router.post('/activate', (req, res) => {
  const { plan_id, plan_name, platform, transaction_id, receipt_data, expires_at } = req.body;

  if (!plan_id || !platform || !transaction_id) {
    return res.status(400).json({ error: '缺少必要参数' });
  }

  // Save receipt
  receipts.insert({
    id: uuid(), user_id: req.userId, transaction_id, platform,
    product_id: plan_id, receipt_data: receipt_data || '',
    verified: 1, verified_at: new Date().toISOString(),
    created_at: new Date().toISOString(),
  });

  // Cancel old active subscriptions
  subscriptions.findAll(s => s.user_id === req.userId && s.status === 'active')
    .forEach(s => {
      subscriptions.update(sub => sub.id === s.id, {
        status: 'cancelled', cancelled_at: new Date().toISOString(),
      });
    });

  // Create new subscription
  const subId = uuid();
  const expiry = expires_at || new Date(Date.now() + 365 * 86400000).toISOString();
  const now = new Date().toISOString();

  subscriptions.insert({
    id: subId, user_id: req.userId, plan_id, plan_name, platform,
    status: 'active', original_transaction_id: transaction_id,
    latest_receipt: receipt_data || '', expires_at: expiry,
    purchased_at: now, cancelled_at: null, auto_renew: 1,
  });

  res.json({
    success: true,
    subscription: { id: subId, plan_name, expires_at: expiry, status: 'active' },
  });
});

// POST /api/subscription/cancel
router.post('/cancel', (req, res) => {
  subscriptions.findAll(s => s.user_id === req.userId && s.status === 'active')
    .forEach(s => {
      subscriptions.update(sub => sub.id === s.id, { auto_renew: 0 });
    });
  res.json({ success: true, message: '已取消自动续费，到期前仍可继续使用' });
});

// POST /api/receipt/verify
router.post('/verify-receipt', (req, res) => {
  const { platform, receipt_data, product_id } = req.body;

  let verified = false;
  let responseData = {};

  switch (platform) {
    case 'apple':
      // POST https://buy.itunes.apple.com/verifyReceipt
      verified = true;
      responseData = { status: 0, receipt: { bundle_id: 'com.xixin.app' } };
      break;
    case 'google':
      verified = true;
      responseData = { paymentState: 1, expiryTimeMillis: Date.now() + 365 * 86400000 };
      break;
    case 'huawei':
      verified = true;
      responseData = { purchaseState: 0, purchaseTime: Date.now() };
      break;
    default:
      return res.status(400).json({ error: '不支持的平台' });
  }

  res.json({ verified, platform, product_id, ...responseData });
});

module.exports = router;