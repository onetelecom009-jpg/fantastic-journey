import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ড্যাশবোর্ড'),
      ),
      body: Center(
        child: Text('এখানে চার্ট ও সেলস সামারি থাকবে'),
      ),
    );
  }
}
