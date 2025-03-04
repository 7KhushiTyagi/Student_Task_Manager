import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _token;

  bool get isLoading => _isLoading;
  String? get token => _token;

  Future<Map<String, dynamic>> register(
      String name, String email, String password,
      {String profilePicture = ""}) async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse("http://127.0.0.1:5000/api/auth/register");

    final Map<String, dynamic> requestBody = {
      "name": name,
      "email": email,
      "password": password,
      "tasks": [],
      "progress": 0.0,
    };

    if (profilePicture.isNotEmpty) {
      requestBody["profilePicture"] = profilePicture;
    }

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
        return {"success": false, "message": "Empty response from server."};
      }

      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      if (response.statusCode == 201) {
        final String? receivedToken = responseBody["token"];
        
        if (receivedToken != null) { 
          _token = receivedToken;
          await _saveToken(_token!);
          notifyListeners();
        }

        return {
          "success": true,
          "message": "Registration successful",
          "data": responseBody,
        };
      } else {
        return {
          "success": false,
          "message": responseBody["message"] ?? "Registration failed",
        };
      }
    } on SocketException {
      return {"success": false, "message": "No internet connection."};
    } catch (e) {
      return {"success": false, "message": "Something went wrong: $e"};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ Save token locally
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // ✅ Load token when app starts
  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    notifyListeners();
  }

  // ✅ Logout (clear token)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clears all saved user data
    _token = null;
    notifyListeners();
  }
}
