import "package:flutter/material.dart";
import "../../core/theme/app_colors.dart";
import "../../core/storage/hive_service.dart";

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPremium = HiveService.isPremium;
    final trialLeft = HiveService.trialDaysLeft;

    return Scaffold(
      appBar: AppBar(title: const Text('会员中心')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: isPremium
                    ? [const Color(0xFFF4A261), const Color(0xFFE76F51)]
                    : [AppColors.primary, AppColors.primaryDark],
              ),
            ),
            child: Column(children: [
              Icon(isPremium ? Icons.workspace_premium : Icons.star, color: Colors.white, size: 40),
              const SizedBox(height: 12),
              Text(
                isPremium ? '您是会员' : (trialLeft > 0 ? '试用中 · 剩余 $trialLeft 天' : '升级会员'),
                style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                isPremium ? '畅享全部冥想内容' : '解锁全部高级冥想与睡眠故事',
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
              ),
            ]),
          ),
          const SizedBox(height: 32),

          if (!isPremium) ...[
            // Pricing
            _priceCard(context, theme, '月度会员', '¥19.9/月', '适合想先体验的用户', 0, false),
            const SizedBox(height: 16),
            _priceCard(context, theme, '年度会员', '¥149/年', '¥12.4/月 · 省 ¥90', 1, true),
            const SizedBox(height: 16),
            _priceCard(context, theme, '终身会员', '¥298', '一次购买，永久畅享', 2, false),
            const SizedBox(height: 32),
          ],

          // Features comparison
          Text('会员权益', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          _featureRow('全部冥想课程', true, true),
          _featureRow('全部睡眠故事', true, true),
          _featureRow('呼吸训练模式', true, true),
          _featureRow('环境白噪音', true, true),
          _featureRow('高级冥想(身体扫描/慈悲等)', false, true),
          _featureRow('高级睡眠故事(海边/星空等)', false, true),
          _featureRow('成就勋章', true, true),
          _featureRow('冥想提醒', true, true),
          const SizedBox(height: 32),
        ]),
      ),
    );
  }

  Widget _priceCard(BuildContext context, ThemeData theme, String title, String price, String desc, int index, bool popular) {
    return GestureDetector(
      onTap: () => _handlePurchase(context, title),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: popular ? AppColors.accent : theme.dividerColor, width: popular ? 2 : 1),
          color: theme.cardColor,
        ),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                if (popular) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: AppColors.accent),
                    child: const Text('推荐', style: TextStyle(color: Colors.white, fontSize: 11)),
                  ),
                ],
              ]),
              const SizedBox(height: 4),
              Text(price, style: theme.textTheme.titleLarge?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(desc, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
            ]),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ]),
      ),
    );
  }

  Widget _featureRow(String feature, bool free, bool premium) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Expanded(child: Text(feature, style: const TextStyle(fontSize: 14))),
        Icon(free ? Icons.check : Icons.close, color: free ? Colors.green : Colors.red.shade300, size: 18),
        const SizedBox(width: 24),
        Icon(premium ? Icons.check : Icons.close, color: premium ? Colors.green : Colors.red.shade300, size: 18),
      ]),
    );
  }

  void _handlePurchase(BuildContext context, String plan) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('确认订阅'),
        content: Text('订阅 $plan\n\n正式上线后将通过 App Store / Google Play 完成支付。\n\n现在可免费激活会员体验全部功能。'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          ElevatedButton(
            onPressed: () {
              HiveService.isPremium = true;
              HiveService.premiumExpiry = DateTime.now().add(const Duration(days: 365)).toIso8601String();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('会员已激活！现在可以畅享全部内容'), backgroundColor: AppColors.success),
              );
            },
            child: const Text('免费激活'),
          ),
        ],
      ),
    );
  }
}