import "payment_product.dart";
import "payment_result.dart";

/// 统一支付抽象接口 —— 三端各自实现
abstract class PaymentService {
  /// 初始化支付 SDK
  Future<void> initialize();

  /// 获取可购买商品列表
  Future<List<PaymentProduct>> fetchProducts();

  /// 发起购买
  Future<PurchaseResult> purchase(PaymentProduct product);

  /// 恢复已购项目（换设备/重装后）
  Future<RestoreResult> restorePurchases();

  /// 获取当前订阅到期时间
  Future<DateTime?> getExpiryDate();

  /// 检查是否有有效订阅
  Future<bool> hasActiveSubscription();

  /// 释放资源
  void dispose();
}