import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../../core/theme/app_colors.dart";
import "../../core/storage/hive_service.dart";
import "../../core/payment/payment_provider.dart";
import "../../core/payment/payment_product.dart";

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPremium = HiveService.isPremium;
    final trialLeft = HiveService.trialDaysLeft;

    return Scaffold(
      appBar: AppBar(title: const Text('会员中心')),
      body: Consumer<PaymentProvider>(
        builder: (ctx, payment, _) {
          final loading = payment.state == PaymentState.purchasing || payment.state == PaymentState.restoring;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(children: [
              _header(context, theme, isPremium, trialLeft),
              const SizedBox(height: 32),
              if (!isPremium) ...[
                _priceCard(context, theme, PaymentProduct.monthly, 0, false, payment, loading),
                const SizedBox(height: 16),
                _priceCard(context, theme, PaymentProduct.yearly, 1, true, payment, loading),
                const SizedBox(height: 16),
                _priceCard(context, theme, PaymentProduct.lifetime, 2, false, payment, loading),
                const SizedBox(height: 12),
                _restoreButton(context, payment, loading),
                const SizedBox(height: 20),
              ],
              if (isPremium) _expiryCard(theme),
              const SizedBox(height: 16),
              _featuresTable(theme),
              const SizedBox(height: 32),
            ]),
          );
        },
      ),
    );
  }

  Widget _header(BuildContext ctx, ThemeData t, bool premium, int trial) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: premium ? [const Color(0xFFF4A261), const Color(0xFFE76F51)] : [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: Column(children: [
        Icon(premium ? Icons.workspace_premium : Icons.star, color: Colors.white, size: 40),
        const SizedBox(height: 12),
        Text(
          premium ? '您是会员' : (trial > 0 ? '试用中 \u00b7 剩余 $trial 天' : '升级会员'),
          style: t.textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          premium ? HiveService.premiumExpiry.isNotEmpty ? '到期: ${HiveService.premiumExpiry.substring(0, 10)}' : '畅享全部内容' : '解锁全部高级冥想与睡眠故事',
          style: t.textTheme.bodyMedium?.copyWith(color: Colors.white70),
        ),
      ]),
    );
  }

  Widget _expiryCard(ThemeData t) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.success.withValues(alpha: 0.1),
      ),
      child: Row(children: [
        const Icon(Icons.check_circle, color: AppColors.success),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('会员已激活', style: t.textTheme.titleSmall?.copyWith(color: AppColors.success, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text('到期时间: ${HiveService.premiumExpiry.isNotEmpty ? HiveService.premiumExpiry.substring(0, 10) : '永久'}', style: t.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
          ]),
        ),
      ]),
    );
  }

  Widget _priceCard(BuildContext ctx, ThemeData t, PaymentProduct p, int i, bool popular, PaymentProvider payment, bool loading) {
    return GestureDetector(
      onTap: loading ? null : () => _handlePurchase(ctx, payment, p),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: popular ? AppColors.accent : t.dividerColor, width: popular ? 2 : 1),
          color: t.cardColor,
        ),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(p.title, style: t.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
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
              Text('\u00a5${p.price}${p.period == SubscriptionPeriod.monthly ? '/月' : (p.period == SubscriptionPeriod.yearly ? '/年' : '')}',
                style: t.textTheme.titleLarge?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(p.description, style: t.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
            ]),
          ),
          if (loading && payment.state == PaymentState.purchasing)
            const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
          else
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ]),
      ),
    );
  }

  Widget _restoreButton(BuildContext ctx, PaymentProvider payment, bool loading) {
    return TextButton.icon(
      onPressed: loading ? null : () => _handleRestore(ctx, payment),
      icon: const Icon(Icons.restore, size: 16),
      label: Text(payment.state == PaymentState.restoring ? '恢复中...' : '恢复购买', style: const TextStyle(fontSize: 13)),
      style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
    );
  }

  Widget _featuresTable(ThemeData t) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('会员权益对比', style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: t.cardColor),
        child: Column(children: [
          _featureRow('全部冥想课程', true, true),
          _featureRow('全部睡眠故事', true, true),
          _featureRow('呼吸训练模式', true, true),
          _featureRow('环境白噪音', true, true),
          _featureRow('高级冥想(身体扫描/慈悲/感恩/深度放松)', false, true),
          _featureRow('高级睡眠故事(海边/星空/雪山)', false, true),
          _featureRow('成就勋章', true, true),
          _featureRow('冥想提醒', true, true),
          _featureRow('离线下载', false, true),
          _featureRow('多设备同步', false, true),
        ]),
      ),
    ]);
  }

  Widget _featureRow(String f, bool free, bool prem) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(children: [
        Expanded(child: Text(f, style: const TextStyle(fontSize: 13))),
        SizedBox(width: 40, child: Center(child: Icon(free ? Icons.check : Icons.close, color: free ? Colors.green : Colors.red.shade300, size: 16))),
        SizedBox(width: 40, child: Center(child: Icon(prem ? Icons.check : Icons.close, color: prem ? Colors.green : Colors.red.shade300, size: 16))),
      ]),
    );
  }

  Future<void> _handlePurchase(BuildContext ctx, PaymentProvider payment, PaymentProduct product) async {
    final success = await payment.purchase(product);
    if (!ctx.mounted) return;

    if (success) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text('${product.title} 激活成功！'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      payment.reset();
    } else if (payment.errorMessage != null && payment.errorMessage != '用户取消') {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(content: Text(payment.errorMessage!), backgroundColor: AppColors.error),
      );
      payment.reset();
    } else {
      payment.reset();
    }
  }

  Future<void> _handleRestore(BuildContext ctx, PaymentProvider payment) async {
    final success = await payment.restore();
    if (!ctx.mounted) return;

    if (success) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('购买已恢复'), backgroundColor: AppColors.success),
      );
    } else if (payment.errorMessage != null) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(content: Text(payment.errorMessage!), backgroundColor: AppColors.error),
      );
    }
    payment.reset();
  }
}