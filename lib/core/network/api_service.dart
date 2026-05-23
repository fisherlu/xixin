import "dart:convert";
import "package:http/http.dart" as http;

class ApiService {
  static const String baseUrl = "http://localhost:3001/api";
  static String? _token;

  static Map<String, String> get _headers => {
    "Content-Type": "application/json",
    if (_token != null) "Authorization": "Bearer $_token",
  };

  // ── Auth ──
  static Future<Map<String, dynamic>> register(String email, String password, String name) async {
    final res = await http.post(
      Uri.parse("$baseUrl/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password, "name": name}),
    );
    final data = jsonDecode(res.body);
    if (res.statusCode == 201 && data["token"] != null) _token = data["token"];
    return data;
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    final data = jsonDecode(res.body);
    if (res.statusCode == 200 && data["token"] != null) _token = data["token"];
    return data;
  }

  static Future<Map<String, dynamic>> phoneLogin(String phone, String code) async {
    final res = await http.post(
      Uri.parse("$baseUrl/auth/phone-login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"phone": phone, "code": code}),
    );
    final data = jsonDecode(res.body);
    if (res.statusCode == 200 && data["token"] != null) _token = data["token"];
    return data;
  }

  // ── User ──
  static Future<Map<String, dynamic>> getProfile() async {
    final res = await http.get(Uri.parse("$baseUrl/user/profile"), headers: _headers);
    return jsonDecode(res.body);
  }

  // ── Subscription ──
  static Future<Map<String, dynamic>> getSubscriptionStatus() async {
    final res = await http.get(Uri.parse("$baseUrl/subscription/status"), headers: _headers);
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> activateSubscription({
    required String planId, required String planName,
    required String platform, required String transactionId,
    String? receiptData, String? expiresAt,
  }) async {
    final res = await http.post(
      Uri.parse("$baseUrl/subscription/activate"),
      headers: _headers,
      body: jsonEncode({
        "plan_id": planId, "plan_name": planName,
        "platform": platform, "transaction_id": transactionId,
        "receipt_data": receiptData, "expires_at": expiresAt,
      }),
    );
    return jsonDecode(res.body);
  }

  static Future<void> logout() {
    _token = null;
    return Future.value();
  }

  static bool get isLoggedIn => _token != null;
}