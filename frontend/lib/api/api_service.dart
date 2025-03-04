import 'dart:convert';
// Detects the platform
// Detects Web
import 'package:http/http.dart' as http;

class ApiService {
  static String baseUrl = "http://127.0.0.1:5000";

  // 🟢 **Login Function**
  static Future<Map<String, dynamic>?> login(
    String email,
    String password,
  ) async {
    final url = Uri.parse("$baseUrl/api/auth/login");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Contains token and user data
      } else {
        print("Login failed: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Login error: $e");
      return null;
    }
  }
}
