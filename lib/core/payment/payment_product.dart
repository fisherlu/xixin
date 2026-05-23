/// 商品类型
enum ProductType { subscription, oneTime }

/// 订阅周期
enum SubscriptionPeriod { monthly, yearly, lifetime }

/// 支付商品
class PaymentProduct {
  final String id;
  final String title;
  final String description;
  final String price;
  final String currencySymbol;
  final ProductType type;
  final SubscriptionPeriod? period;
  final Map<PlatformStore, String> storeSkus; // 各平台 SKU

  const PaymentProduct({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.currencySymbol = '\u00a5',
    required this.type,
    this.period,
    required this.storeSkus,
  });

  bool get isSubscription => type == ProductType.subscription;

  static const monthly = PaymentProduct(
    id: 'xixin_monthly',
    title: '月度会员',
    description: '每月自动续费，随时取消',
    price: '19.9',
    type: ProductType.subscription,
    period: SubscriptionPeriod.monthly,
    storeSkus: {
      PlatformStore.apple: 'com.xixin.premium.monthly',
      PlatformStore.google: 'xixin_premium_monthly',
      PlatformStore.huawei: 'xixin_premium_monthly',
    },
  );

  static const yearly = PaymentProduct(
    id: 'xixin_yearly',
    title: '年度会员',
    description: '\u00a512.4/月 \u00b7 省 \u00a590',
    price: '149',
    type: ProductType.subscription,
    period: SubscriptionPeriod.yearly,
    storeSkus: {
      PlatformStore.apple: 'com.xixin.premium.yearly',
      PlatformStore.google: 'xixin_premium_yearly',
      PlatformStore.huawei: 'xixin_premium_yearly',
    },
  );

  static const lifetime = PaymentProduct(
    id: 'xixin_lifetime',
    title: '终身会员',
    description: '一次购买，永久畅享',
    price: '298',
    type: ProductType.oneTime,
    period: SubscriptionPeriod.lifetime,
    storeSkus: {
      PlatformStore.apple: 'com.xixin.premium.lifetime',
      PlatformStore.google: 'xixin_premium_lifetime',
      PlatformStore.huawei: 'xixin_premium_lifetime',
    },
  );

  static const all = [monthly, yearly, lifetime];
}

/// 平台商店
enum PlatformStore { apple, google, huawei }