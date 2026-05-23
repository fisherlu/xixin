import "package:flutter/foundation.dart";
import "../../../core/storage/hive_service.dart";

class AuthProvider extends ChangeNotifier {
  bool get isLoggedIn => HiveService.isLoggedIn;
  String get userName => HiveService.userName;
  String get userEmail => HiveService.userEmail;
  String get userPhone => HiveService.userPhone;

  Future<bool> loginWithEmail(String email, String password) async {
    // Simulated auth — replace with Firebase Auth
    await Future.delayed(const Duration(seconds: 1));
    if (email.isNotEmpty && password.length >= 6) {
      HiveService.isLoggedIn = true;
      HiveService.userEmail = email;
      HiveService.userName = email.split('@').first;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> loginWithPhone(String phone, String code) async {
    await Future.delayed(const Duration(seconds: 1));
    if (phone.length >= 11 && code == '123456') {
      HiveService.isLoggedIn = true;
      HiveService.userPhone = phone;
      HiveService.userName = '用户${phone.substring(phone.length - 4)}';
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String email, String password, String name) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email.isNotEmpty && password.length >= 6 && name.isNotEmpty) {
      HiveService.isLoggedIn = true;
      HiveService.userEmail = email;
      HiveService.userName = name;
      HiveService.startTrial(); // 新用户获7天免费试用
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    HiveService.isLoggedIn = false;
    HiveService.isPremium = false;
    notifyListeners();
  }

  void skipLogin() {
    HiveService.isLoggedIn = true;
    HiveService.userName = '访客';
    notifyListeners();
  }
}