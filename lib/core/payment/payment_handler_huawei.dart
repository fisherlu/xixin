import "package:flutter/foundation.dart";
import "payment_service.dart";
import "payment_product.dart";
import "payment_result.dart";

/// HarmonyOS - 华为 HMS IAP Kit
/// 真实接入: 替换为 huawei_iap 插件
class HuaweiPaymentHandler extends PaymentService {
  bool _initialized = false;

  @override
  Future<void> initialize() async {
    // TODO: 真实接入代码
    // await IapClient.initialize();
    // 在 AppGallery Connect 后台配置商品后，填入对应 productId
    debugPrint('[Huawei IAP] Initialized');
    _initialized = true;
  }

  @override
  Future<List<PaymentProduct>> fetchProducts() async {
    if (!_initialized) await initialize();
    // TODO: 真实接入代码
    // final req = ProductInfoReq(productIds);
    // final res = await IapClient.obtainProductInfo(req);
    await Future.delayed(const Duration(milliseconds: 800));
    return PaymentProduct.all;
  }

  @override
  Future<PurchaseResult> purchase(PaymentProduct product) async {
    if (!_initialized) await initialize();
    // TODO: 真实接入代码
    // final sku = product.storeSkus[PlatformStore.huawei]!;
    // final req = PurchaseIntentReq(productId: sku, type: ...);
    // final res = await IapClient.createPurchaseIntent(req);
    // 处理 PurchaseResultInfo 状态
    debugPrint('[Huawei IAP] Purchase: ${product.id}');
    await Future.delayed(const Duration(milliseconds: 1500));
    return PurchaseResult.success(
      transactionId: 'huawei_${DateTime.now().millisecondsSinceEpoch}',
      receiptData: 'mock_huawei_receipt_${product.id}',
      product: product,
    );
  }

  @override
  Future<RestoreResult> restorePurchases() async {
    if (!_initialized) await initialize();
    // TODO: 真实接入代码
    // final req = OwnedPurchasesReq(...);
    // final res = await IapClient.obtainOwnedPurchases(req);
    debugPrint('[Huawei IAP] Restoring purchases...');
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