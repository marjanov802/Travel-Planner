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
  final Color _defaultPrimaryColor =
      Colors.blue; // Matches Sign-Up's primary color
  final Color _defaultSecondaryColor =
      Colors.white; // Matches Sign-Up's secondary color
  final Color _defaultAccentColor =
      Colors.grey; // Matches Sign-Up's accent color
  final Color _defaultBackgroundColor =
      Colors.blueAccent; // Matches Sign-Up's background color
  final Color _defaultTextColor = Colors.white; // Matches Sign-Up's text color
  final double _defaultFontSize =
      18.0; // Default font size, matches Sign-Up preferences

  void _handleLogin() {
    if (_emailController.text == _hardcodedEmail &&
        _passwordController.text == _hardcodedPassword) {
      // Navigate to MainHomePage with default colors matching Sign-Up screen's palette
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainHomePage(
            primaryColor: _defaultPrimaryColor,
            secondaryColor: _defaultSecondaryColor,
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true, // Hide password input
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _handleLogin,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
