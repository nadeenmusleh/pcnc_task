import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<http.Response> signup(
      String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('https://api.escuelajs.co/api/v1/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': username,
        'email': email,
        'password': password,
        'avatar': 'https://example.com/dummy-avatar.png',
      }),
    );
    return response;
  }

  Future<http.Response> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('https://api.escuelajs.co/api/v1/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    return response;
  }
}
