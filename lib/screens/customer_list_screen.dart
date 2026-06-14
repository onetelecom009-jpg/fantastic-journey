import 'package:flutter/material.dart';

class CustomerListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('কাস্টমার লিস্ট'),
      ),
      body: Center(
        child: Text('কাস্টমারদের তালিকা'),
      ),
    );
  }
}
