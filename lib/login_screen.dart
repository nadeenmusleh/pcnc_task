import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'signup_screen.dart';
import 'services/api_service.dart';
import 'dashboard_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  final ApiService _apiService = ApiService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GetStorage storage =
      GetStorage(); // Initialize GetStorage for local storage

  @override
  void initState() {
    super.initState();
    _autoLogin(); // Check if the user is already logged in
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Auto-login if credentials are saved
  void _autoLogin() {
    // Check if the user is logged out
    if (!storage.hasData('email') || !storage.hasData('password')) {
      return; // Don't auto-login if no credentials are saved
    }

    if (storage.hasData('email') && storage.hasData('password')) {
      _login(storage.read('email'), storage.read('password'),
          isAutoLogin: true);
    }
  }

  // Login method
  void _login(String? email, String? password,
      {bool isAutoLogin = false}) async {
    try {
      email ??= _usernameController.text;
      password ??= _passwordController.text;

      if (!isAutoLogin && (email.isEmpty || password.isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in both email and password')),
        );
        return;
      }

      final response = await _apiService.login(email, password);

      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == 'success') {
        if (!isAutoLogin) {
          storage.write('email', email);
          storage.write('password', password);
        }

        Get.offAll(() => DashboardScreen());
      } else if (jsonResponse['status'] == 'user_not_found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not found. Please sign up first.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${jsonResponse['message']}')),
        );
      }
    } catch (e) {
      print('Login failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Stack(
          children: [
            Positioned(
              top: screenHeight * 0.1,
              left: 0,
              child: Text(
                'Welcome back!',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: screenWidth * 0.08,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Positioned(
              top: screenHeight * 0.2,
              left: 0,
              right: 0,
              child: Container(
                height: 55,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFA8A8A9), width: 1.0),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.grey),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: 'Username or Email',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.3,
              left: 0,
              right: 0,
              child: Container(
                height: 55,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFA8A8A9), width: 1.0),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lock, color: Colors.grey),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.37,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  print("Forgot Password tapped");
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFCD3534),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.45,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => _login(null, null),
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    color: Color(0xFFF89939),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 450,
              left: 70,
              child: GestureDetector(
                onTap: () {
                  Get.to(() => SignUpPage());
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Create An Account ',
                    style: TextStyle(
                      color: Color(0xFF676767),
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      height: 14.63 / 12,
                    ),
                    children: [
                      TextSpan(
                        text: 'sign up',
                        style: TextStyle(
                          color: Color(0xFFCD3534),
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 14.63 / 12,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
