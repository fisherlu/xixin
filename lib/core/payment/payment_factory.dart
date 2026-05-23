import "dart:io" show Platform;
import "payment_service.dart";
import "payment_handler_apple.dart";
import "payment_handler_google.dart";
import "payment_handler_huawei.dart";

/// 支付服务工厂 —— 根据运行平台自动选择
class PaymentServiceFactory {
  PaymentServiceFactory._();

  static PaymentService create() {
    if (Platform.isIOS) {
      return ApplePaymentHandler();
    }
    if (Platform.isAndroid) {
      // HarmonyOS 检测: 华为设备上可以通过包名或属性判断
      // 实际项目中可通过 device_info_plus 或尝试初始化 HMS SDK 来判断
      if (_isHarmonyOS()) {
        return HuaweiPaymentHandler();
      }
      return GooglePaymentHandler();
    }
    // 桌面/Web 降级为 Google Handler
    return GooglePaymentHandler();
  }

  /// 检测是否为鸿蒙系统
  static bool _isHarmonyOS() {
    // 真实检测方式:
    // 1. 尝试 import 'package:huawei_iap/huawei_iap.dart' 并调用 HMS 方法
    // 2. 读取 build.prop 中的 ro.config.hw_osbase 属性
    // 3. 使用 device_info_plus 判断 manufacturer == 'Huawei' && osVersion 含 'HarmonyOS'
    // 此处简化:
    try {
      if (Platform.isAndroid) {
        // 简化: 检测华为设备标志
        final harmonyEnv = Platform.environment.containsKey('HARMONY_OS');
        return harmonyEnv;
      }
    } catch (_) {}
    return false;
  }
}