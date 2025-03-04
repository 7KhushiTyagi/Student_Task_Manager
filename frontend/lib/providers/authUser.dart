import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthUser with ChangeNotifier {
  String? _userId;
  String? _token;
  String? _userName;
  String? _email;
  String? _profilePicture;
  bool _isAuthenticated = false;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String? get userId => _userId;
  String? get token => _token;
  String get userName => _userName ?? "Guest";
  String get email => _email ?? "guest@example.com";
  String? get profilePicture => _profilePicture;
  bool get isAuthenticated => _isAuthenticated;

  static const String _baseUrl = "http://127.0.0.1:5000/api/auth";

  // ✅ **Login Function**
  Future<Map<String, dynamic>> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse("$_baseUrl/login");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"email": email, "password": password}),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 && responseBody['token'] != null) {
        _userId = responseBody['_id'];
        _token = responseBody['token'];
        _userName = responseBody['name'] ?? "Guest";
        _email = responseBody['email'] ?? "guest@example.com";
        _profilePicture = responseBody['profilePicture'] ?? "default_profile.png";
        _isAuthenticated = true;

        await _saveUserData();
        notifyListeners();
        return {"success": true, "message": "Login successful"};
      } else {
        return {
          "success": false,
          "message": responseBody["message"] ?? "Invalid credentials"
        };
      }
    } catch (error) {
      return {"success": false, "message": "Login error: ${error.toString()}"};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ **Logout Function**
  Future<void> logout() async {
    _userId = null;
    _token = null;
    _userName = null;
    _email = null;
    _profilePicture = null;
    _isAuthenticated = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }

  // ✅ **Auto-login when the app starts**
  Future<void> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("token");

    if (_token != null) {
      _userId = prefs.getString("userId");
      _userName = prefs.getString("userName");
      _email = prefs.getString("email");
      _profilePicture = prefs.getString("profilePicture");
      _isAuthenticated = prefs.getBool("isAuthenticated") ?? false;
      notifyListeners();
    }
  }

  // ✅ **Helper function to store user data**
  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", _token ?? "");
    await prefs.setString("userId", _userId ?? "");
    await prefs.setString("userName", _userName ?? "");
    await prefs.setString("email", _email ?? "");
    await prefs.setString("profilePicture", _profilePicture ?? "");
    await prefs.setBool("isAuthenticated", _isAuthenticated);
  }

  // ✅ **Authenticated Request with Token Handling**
  Future<Map<String, dynamic>> authenticatedRequest(
    String endpoint, {
    String method = "GET",
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse("$_baseUrl/$endpoint");

    if (_token == null) {
      return {"success": false, "message": "Unauthorized. Please log in again."};
    }

    try {
      final response = await (method == "POST"
          ? http.post(
              url,
              headers: {
                "Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": "Bearer $_token",
              },
              body: body != null ? jsonEncode(body) : null,
            )
          : http.get(
              url,
              headers: {
                "Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": "Bearer $_token",
              },
            ));

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 401) {
        return {"success": false, "message": "Session expired. Please log in again."};
      }

      return {"success": true, "data": responseBody};
    } catch (error) {
      return {"success": false, "message": "Request error: ${error.toString()}"};
    }
  }
}
