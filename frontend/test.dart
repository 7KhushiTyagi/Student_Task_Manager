import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider {
  String? _token;

  Future<void> testRegister() async {
    final url = Uri.parse("http://127.0.0.1:5000/api/auth/register");

    final Map<String, dynamic> requestBody = {
      "name": "Test User",
      "email": "test@example.com",
      "password": "password123",
      "tasks": [],
      "progress": 0.0,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      if (response.body.isEmpty) {
        print("❌ Empty response from server.");
        return;
      }

      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      if (response.statusCode == 201) {
        _token = responseBody["token"];
        print("✅ Registration successful! Token: $_token");

        await _saveToken(_token!);
        await _loadToken();
      } else {
        print("❌ Registration failed: ${responseBody["message"]}");
      }
    } catch (e) {
      print("❌ Error: $e");
    }
  }

  // Save token locally
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    print("🔹 Token saved locally!");
  }

  // Load token for verification
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('auth_token');
    print("🔹 Loaded Token: $savedToken");
  }
}

void main() async {
  final auth = AuthProvider();
  await auth.testRegister();
}
