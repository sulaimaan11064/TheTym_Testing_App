import 'package:firstapp/pages/dashboard_page.dart';
import 'package:flutter/material.dart';

import 'pages/calender_page.dart';
import 'pages/chat/chat_list_page.dart';
import 'pages/chat/chat_page.dart';
import 'pages/login_page.dart';
import 'pages/splash_screen_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      //home:  const ChatListPage(),
       home:  const SplashScreenPage(),
    );
  }
}


