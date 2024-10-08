import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Check the login status and navigate accordingly
    _checkLoginStatus();
  }

  //req: Function to check if user credentials are saved in SharedPreferences
  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');

    // If credentials exist, navigate to the dashboard
    if (email != null && password != null) {
      // Navigate to the dashboard
      Future.delayed(Duration(seconds: 3), () {
        Get.offNamed('/dashboard');
      });
    } else {
      // Otherwise, navigate to the login screen after 3 seconds
      Future.delayed(Duration(seconds: 3), () {
        Get.offNamed('/login');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: screenSize.height * 0.4,
            left: screenSize.width * 0.15,
            child: Opacity(
              opacity: 1.0,
              child: Image.asset(
                'images/pcnc.png',
                width: screenSize.width * 0.6,
                height: screenSize.height * 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
