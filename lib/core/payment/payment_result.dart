import "payment_product.dart";

/// 购买结果
class PurchaseResult {
  final bool success;
  final String? transactionId;
  final String? receiptData;
  final String? errorMessage;
  final PaymentProduct? product;

  const PurchaseResult({
    required this.success,
    this.transactionId,
    this.receiptData,
    this.errorMessage,
    this.product,
  });

  factory PurchaseResult.success({
    required String transactionId,
    required String receiptData,
    required PaymentProduct product,
  }) => PurchaseResult(
    success: true,
    transactionId: transactionId,
    receiptData: receiptData,
    product: product,
  );

  factory PurchaseResult.failure(String error) => PurchaseResult(success: false, errorMessage: error);
  factory PurchaseResult.cancelled() => PurchaseResult(success: false, errorMessage: '用户取消');
}

/// 恢复购买结果
class RestoreResult {
  final bool success;
  final List<PurchaseResult> restored;
  final String? errorMessage;

  const RestoreResult({required this.success, this.restored = const [], this.errorMessage});
}