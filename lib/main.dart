import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcnc_task/dashboard_screen.dart';
import 'package:pcnc_task/signup_screen.dart';
import 'splash_screen.dart';
import 'login_screen.dart';
import 'search_sceen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PCNC E-commerce',
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/signup', page: () => SignUpPage()),
        GetPage(name: '/dashboard', page: () => DashboardScreen()),
        GetPage(name: '/search', page: () => SearchScreen()),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
