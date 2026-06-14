// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'customer_list_screen.dart';
import 'stock_list_screen.dart';
import 'billing_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // স্ক্রিনগুলোর লিস্ট
  final List<Widget> _screens = [
    DashboardScreen(),
    CustomerListScreen(),
    StockListScreen(),
    BillingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed, // ৪টি আইটেমের জন্য ফিক্সড টাইপ ভালো
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'ড্যাশবোর্ড',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'কাস্টমার',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'স্টক',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'বিলিং',
          ),
        ],
      ),
    );
  }
}
