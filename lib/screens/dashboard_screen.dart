import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final String username;

  DashboardScreen({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Center(
        child: Text('Welcome, $username!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
