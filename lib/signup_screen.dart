import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pcnc_task/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/api_service.dart';
import 'dashboard_screen.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final ApiService apiService = ApiService();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String _password = '';
  String _usernameError = '';
  String _emailError = '';
  String _passwordMatchError = '';

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _validateUsername(String value) {
    if (value.length < 3 || value.length > 16) {
      setState(() {
        _usernameError = 'Username must be between 3 and 16 characters';
      });
    } else {
      setState(() {
        _usernameError = '';
      });
    }
  }

  void _validateEmail(String value) {
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      setState(() {
        _emailError = 'Enter a valid email address';
      });
    } else {
      setState(() {
        _emailError = '';
      });
    }
  }

  void _validateConfirmPassword(String value) {
    if (value != _password) {
      setState(() {
        _passwordMatchError = 'Passwords do not match';
      });
    } else {
      setState(() {
        _passwordMatchError = '';
      });
    }
  }

  void _signup() async {
    _validateUsername(_usernameController.text);
    _validateEmail(_emailController.text);
    _validateConfirmPassword(_confirmPasswordController.text);

    if (_usernameError.isEmpty &&
        _emailError.isEmpty &&
        _passwordMatchError.isEmpty) {
      final response = await apiService.signup(
        _usernameController.text,
        _emailController.text,
        _passwordController.text,
      );

      if (response.statusCode == 201) {
        // Save user credentials
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('email', _emailController.text);
        prefs.setString('password', _passwordController.text);
        //go to dashboard directly with no need to log in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Signup failed: ${response.body}")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fix the validation errors")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 63,
            left: 29,
            child: Opacity(
              opacity: 1.0,
              child: Container(
                width: 192,
                height: 86,
                child: Text(
                  'Create an Account',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    height: 43 / 36,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
          Positioned(
            top: 188,
            left: 27,
            child: Container(
              width: 317,
              height: 55,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFA8A8A9), width: 1.0),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Icon(Icons.person, color: Colors.black),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _usernameController,
                      onChanged: _validateUsername,
                      decoration: InputDecoration(
                        hintText: 'Username',
                        border: InputBorder.none,
                        counterText: '',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_usernameError.isNotEmpty)
            Positioned(
              top: 250,
              left: 27,
              child: Text(
                _usernameError,
                style: TextStyle(color: Color(0xFFCD3534), fontSize: 12),
              ),
            ),
          Positioned(
            top: 273,
            left: 27,
            child: Container(
              width: 317,
              height: 55,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFA8A8A9), width: 1.0),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Icon(Icons.email, color: Colors.black),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _emailController,
                      onChanged: _validateEmail,
                      decoration: InputDecoration(
                        hintText: 'Email',
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
          if (_emailError.isNotEmpty)
            Positioned(
              top: 336,
              left: 27,
              child: Text(
                _emailError,
                style: TextStyle(color: Color(0xFFCD3534), fontSize: 12),
              ),
            ),
          Positioned(
            top: 358,
            left: 27,
            child: Container(
              width: 317,
              height: 55,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFA8A8A9), width: 1.0),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Icon(Icons.lock, color: Colors.black),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      onChanged: (value) {
                        setState(() {
                          _password = value;
                          _passwordMatchError = '';
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: InputBorder.none,
                        counterText: '',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    child: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 443,
            left: 27,
            child: Container(
              width: 317,
              height: 55,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFA8A8A9), width: 1.0),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Icon(Icons.lock, color: Colors.black),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: !_isConfirmPasswordVisible,
                      onChanged: _validateConfirmPassword,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                    child: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_passwordMatchError.isNotEmpty)
            Positioned(
              top: 500,
              left: 27,
              child: Text(
                _passwordMatchError,
                style: TextStyle(color: Color(0xFFCD3534), fontSize: 12),
              ),
            ),
          Positioned(
            top: 532,
            left: 27,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'By clicking the ',
                    style: TextStyle(
                      color: Color(0xFF676767),
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 14.63 / 12,
                    ),
                  ),
                  TextSpan(
                    text: 'Register ',
                    style: TextStyle(
                      color: Color(0xFFCD3534),
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 14.63 / 12,
                    ),
                  ),
                  TextSpan(
                    text: 'button, you agree to the public offer.',
                    style: TextStyle(
                      color: Color(0xFF676767),
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 14.63 / 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 690,
            left: 70,
            child: GestureDetector(
              onTap: () {
                Get.to(() => LoginPage());
              },
              child: RichText(
                text: TextSpan(
                    text: 'I Already Have an Account ',
                    style: TextStyle(
                      color: Color(0xFF676767),
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 14.63 / 12,
                    ),
                    children: [
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          color: Color(0xFFCD3534),
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 14.63 / 12,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ]),
              ),
            ),
          ),
          Positioned(
            top: 623,
            left: 27,
            child: GestureDetector(
              onTap: _signup,
              child: Container(
                width: 317,
                height: 55,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xFFF89939),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'Create Account',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
