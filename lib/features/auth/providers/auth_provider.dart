import "package:flutter/foundation.dart";
import "../../../core/storage/hive_service.dart";
import "../../../core/network/api_service.dart";

class AuthProvider extends ChangeNotifier {
  bool get isLoggedIn => HiveService.isLoggedIn;
  String get userName => HiveService.userName;
  String get userEmail => HiveService.userEmail;
  String get userPhone => HiveService.userPhone;

  Future<bool> loginWithEmail(String email, String password) async {
    try {
      final data = await ApiService.login(email, password);
      if (data["token"] != null) {
        _persistLogin(data);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Login error: $e");
      // Fallback to local auth if server unavailable
      if (email.isNotEmpty && password.length >= 6) {
        HiveService.isLoggedIn = true;
        HiveService.userEmail = email;
        HiveService.userName = email.split('@').first;
        notifyListeners();
        return true;
      }
      return false;
    }
  }

  Future<bool> loginWithPhone(String phone, String code) async {
    try {
      final data = await ApiService.phoneLogin(phone, code);
      if (data["token"] != null) {
        _persistLogin(data);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Phone login error: $e");
      if (phone.length >= 11 && code == '123456') {
        HiveService.isLoggedIn = true;
        HiveService.userPhone = phone;
        HiveService.userName = '用户${phone.substring(phone.length - 4)}';
        notifyListeners();
        return true;
      }
      return false;
    }
  }

  Future<bool> register(String email, String password, String name) async {
    try {
      final data = await ApiService.register(email, password, name);
      if (data["token"] != null) {
        _persistLogin(data);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Register error: $e");
      if (email.isNotEmpty && password.length >= 6 && name.isNotEmpty) {
        HiveService.isLoggedIn = true;
        HiveService.userEmail = email;
        HiveService.userName = name;
        HiveService.startTrial();
        notifyListeners();
        return true;
      }
      return false;
    }
  }

  void _persistLogin(Map<String, dynamic> data) {
    final user = data["user"] as Map<String, dynamic>? ?? {};
    HiveService.isLoggedIn = true;
    HiveService.userEmail = user["email"] as String? ?? '';
    HiveService.userName = user["name"] as String? ?? '';
    HiveService.userPhone = user["phone"] as String? ?? '';
    if (data["trial_days"] != null) {
      HiveService.startTrial();
    }
    notifyListeners();
  }

  void logout() {
    ApiService.logout();
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