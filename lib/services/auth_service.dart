import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('https://api.escuelajs.co/api/v1/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> userData = json.decode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userData', jsonEncode(userData));
      return true;
    } else {
      return false;
    }
  }

  // logout method
  Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // This will remove all stored data.
      return true; // Indicate that logout was successful
    } catch (e) {
      print('Logout error: $e');
      return false; // Indicate that logout failed
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('userData');
    if (userData != null) {
      return jsonDecode(userData);
    }
    return null;
  }

  //method to check if the user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    String? userData =
        prefs.getString('userData'); // Check for stored user data
    return userData !=
        null; // Return true if user data exists, indicating the user is logged in
  }
}
