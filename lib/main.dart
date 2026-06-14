import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const BusinessManagementApp());
}

class BusinessManagementApp extends StatelessWidget {
  const BusinessManagementApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ব্যবসা ম্যানেজমেন্ট',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
