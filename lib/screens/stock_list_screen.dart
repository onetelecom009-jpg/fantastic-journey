import 'package:flutter/material.dart';

class StockListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('স্টক ম্যানেজমেন্ট'),
      ),
      body: Center(
        child: Text('পণ্যের তালিকা ও স্টক'),
      ),
    );
  }
}
