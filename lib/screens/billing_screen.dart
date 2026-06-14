import 'package:flutter/material.dart';

class BillingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('বিলিং'),
      ),
      body: Center(
        child: Text('নতুন বিল তৈরি করুন'),
      ),
    );
  }
}
