// Routes
import 'package:flutter/material.dart';

import '../features/auth/pages/auth_page.dart';
import '../features/home/pages/home_page.dart';


class AppRoutes {
  static const String auth = '/'; // authorization page
  static const String home = '/home'; // home page

  static Map<String, WidgetBuilder> getRoutes() {
    return { 
        auth: (context) => const AuthPage(),
        home: (context) => const HomePage(),
    };
  }
}