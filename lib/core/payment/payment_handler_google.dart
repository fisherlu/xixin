import "package:flutter/foundation.dart";
import "payment_service.dart";
import "payment_product.dart";
import "payment_result.dart";

/// Android - Google Play Billing
/// 真实接入: 替换为 in_app_purchase 插件的 GooglePlay 实现
class GooglePaymentHandler extends PaymentService {
  bool _initialized = false;

  @override
  Future<void> initialize() async {
    // TODO: 真实接入代码
    // await InAppPurchase.instance.restorePurchases();
    debugPrint('[Google Play] Initialized');
    _initialized = true;
  }

  @override
  Future<List<PaymentProduct>> fetchProducts() async {
    if (!_initialized) await initialize();
    await Future.delayed(const Duration(milliseconds: 800));
    return PaymentProduct.all;
  }

  @override
  Future<PurchaseResult> purchase(PaymentProduct product) async {
    if (!_initialized) await initialize();
    // TODO: 真实接入代码
    // final param = GooglePlayPurchaseParam(productDetails: details);
    // await InAppPurchase.instance.buyNonConsumable(purchaseParam: param);
    debugPrint('[Google Play] Purchase: ${product.id}');
    await Future.delayed(const Duration(milliseconds: 1500));
    return PurchaseResult.success(
      transactionId: 'gplay_${DateTime.now().millisecondsSinceEpoch}',
      receiptData: 'mock_google_receipt_${product.id}',
      product: product,
    );
  }

  @override
  Future<RestoreResult> restorePurchases() async {
    if (!_initialized) await initialize();
    debugPrint('[Google Play] Restoring purchases...');
    await Future.delayed(const Duration(seconds: 1));
    return const RestoreResult(success: true);
  }

  @override
  Future<DateTime?> getExpiryDate() async {
    return DateTime.now().add(const Duration(days: 365));
  }

  @override
  Future<bool> hasActiveSubscription() async {
    final expiry = await getExpiryDate();
    return expiry != null && expiry.isAfter(DateTime.now());
  }

  @override
  void dispose() {}
}