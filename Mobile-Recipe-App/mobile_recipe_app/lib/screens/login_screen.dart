import 'package:flutter/material.dart';
import 'main_home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Hardcoded credentials for demo purposes
  final String _hardcodedEmail = 'user@example.com';
  final String _hardcodedPassword = 'password123';

  // Default colors to match the Sign-Up screen's initial palette
  //updated so no secondary coulours as its too complicated
  final Color _defaultPrimaryColor = Colors.blue; // Primary color
  final Color _defaultAccentColor = Colors.amber; // Accent color
  final Color _defaultBackgroundColor = Colors.blueAccent; // Background color
  final Color _defaultTextColor = Colors.white; // Text color
  final double _defaultFontSize = 18.0; // Default font size

  void _handleLogin() {
    if (_emailController.text == _hardcodedEmail &&
        _passwordController.text == _hardcodedPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainHomePage(
            primaryColor: _defaultPrimaryColor,
            accentColor: _defaultAccentColor,
            backgroundColor: _defaultBackgroundColor,
            textColor: _defaultTextColor,
            selectedFontSize: _defaultFontSize,
          ),
        ),
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: _defaultPrimaryColor,
      ),
      body: Container(
        color: _defaultBackgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: _defaultTextColor),
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: _defaultAccentColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: _defaultAccentColor, width: 2),
                ),
              ),
              style: TextStyle(color: _defaultTextColor),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: _defaultTextColor),
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: _defaultAccentColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: _defaultAccentColor, width: 2),
                ),
              ),
              style: TextStyle(color: _defaultTextColor),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: _defaultAccentColor,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: _defaultFontSize,
                  color: _defaultTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
