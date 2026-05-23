import "package:flutter/foundation.dart";
import "dart:io" show Platform;
import "payment_service.dart";
import "payment_product.dart";
import "payment_result.dart";
import "payment_factory.dart";
import "receipt_validator.dart";
import "../../storage/hive_service.dart";
import "../../network/api_service.dart";

enum PaymentState { idle, loading, purchasing, success, error, restoring }

class PaymentProvider extends ChangeNotifier {
  late final PaymentService _service;
  PaymentState _state = PaymentState.idle;
  String? _errorMessage;
  List<PaymentProduct> _products = [];

  PaymentState get state => _state;
  String? get errorMessage => _errorMessage;
  List<PaymentProduct> get products => _products;

  PaymentProvider() {
    _service = PaymentServiceFactory.create();
    _init();
  }

  Future<void> _init() async {
    _setState(PaymentState.loading);
    try {
      await _service.initialize();
      _products = await _service.fetchProducts();
      _setState(PaymentState.idle);
    } catch (e) {
      _errorMessage = '初始化支付失败: $e';
      _setState(PaymentState.error);
    }
  }

  String get _platformLabel {
    if (Platform.isIOS) return 'apple';
    if (Platform.isAndroid) return 'google';
    return 'google';
  }

  Future<bool> purchase(PaymentProduct product) async {
    _setState(PaymentState.purchasing);
    _errorMessage = null;

    try {
      final result = await _service.purchase(product);

      if (result.success) {
        final valid = await ReceiptValidator.validate(result);
        if (valid) {
          _activatePremium(product, result);
          // Sync to backend server
          await _syncToServer(product, result);
          _setState(PaymentState.success);
          return true;
        } else {
          _errorMessage = '收据验证失败';
          _setState(PaymentState.error);
          return false;
        }
      } else {
        _errorMessage = result.errorMessage ?? '购买失败';
        _setState(PaymentState.error);
        return false;
      }
    } catch (e) {
      _errorMessage = '支付异常: $e';
      _setState(PaymentState.error);
      return false;
    }
  }

  Future<void> _syncToServer(PaymentProduct product, PurchaseResult result) async {
    try {
      await ApiService.activateSubscription(
        planId: product.id,
        planName: product.title,
        platform: _platformLabel,
        transactionId: result.transactionId ?? '',
        receiptData: result.receiptData,
        expiresAt: HiveService.premiumExpiry,
      );
      debugPrint('[Payment] Server sync success: ${product.id}');
    } catch (e) {
      debugPrint('[Payment] Server sync failed (offline?): $e');
      // Server sync is best-effort; local activation already done
    }
  }

  Future<bool> restore() async {
    _setState(PaymentState.restoring);
    _errorMessage = null;

    try {
      // First try server-side restore
      try {
        final serverStatus = await ApiService.getSubscriptionStatus();
        if (serverStatus["is_premium"] == true) {
          HiveService.isPremium = true;
          if (serverStatus["subscription"]?["expires_at"] != null) {
            HiveService.premiumExpiry = serverStatus["subscription"]["expires_at"];
          }
          _setState(PaymentState.success);
          return true;
        }
      } catch (_) {}

      // Fallback to platform restore
      final result = await _service.restorePurchases();
      if (result.success) {
        final active = await _service.hasActiveSubscription();
        if (active) {
          HiveService.isPremium = true;
          _setState(PaymentState.success);
          return true;
        }
        _errorMessage = '未找到有效订阅';
        _setState(PaymentState.idle);
        return false;
      }
      _errorMessage = result.errorMessage ?? '恢复失败';
      _setState(PaymentState.idle);
      return false;
    } catch (e) {
      _errorMessage = '恢复异常: $e';
      _setState(PaymentState.idle);
      return false;
    }
  }

  void _activatePremium(PaymentProduct product, PurchaseResult result) {
    HiveService.isPremium = true;
    final duration = product.period == SubscriptionPeriod.monthly
        ? const Duration(days: 30)
        : product.period == SubscriptionPeriod.yearly
            ? const Duration(days: 365)
            : const Duration(days: 36500);

    HiveService.premiumExpiry = DateTime.now().add(duration).toIso8601String();
    HiveService.lastTransactionId = result.transactionId ?? '';
    debugPrint('[Premium] Activated: ${product.title}');
  }

  void reset() { _state = PaymentState.idle; _errorMessage = null; notifyListeners(); }
  void _setState(PaymentState s) { _state = s; notifyListeners(); }

  @override void dispose() { _service.dispose(); super.dispose(); }
}