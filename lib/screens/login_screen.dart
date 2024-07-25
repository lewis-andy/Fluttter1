import 'package:flutter/material.dart';
import '../database/database_helper.dart'; // Import your DatabaseHelper class
import 'dashboard_screen.dart'; // Import the DashboardScreen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final DatabaseHelper _dbHelper = DatabaseHelper();

  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final user = await _dbHelper.loginUser(username, password);

    if (user != null) {
      // Login successful
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login successful!')));
      // Navigate to DashboardScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(username: username, userId: user['id']),
        ),
      );
    } else {
      // Login failed
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid username or password.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
