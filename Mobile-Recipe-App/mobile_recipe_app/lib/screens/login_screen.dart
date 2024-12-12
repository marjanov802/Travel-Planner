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

  // Default color palette
  final Map<String, Color> _defaultPalette = {
    'primary': const Color(0xFF004A99),
    'background': const Color(0xFFEFF6FF),
    'text': const Color(0xFF000000),
    'accent': const Color(0xFFFFC107),
  };

  void _handleLogin() {
    if (_emailController.text == _hardcodedEmail &&
        _passwordController.text == _hardcodedPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainHomePage(
            primaryColor: _defaultPalette['primary']!,
            accentColor: _defaultPalette['accent']!,
            backgroundColor: _defaultPalette['background']!,
            textColor: _defaultPalette['text']!,
            selectedFontSize: 18.0, // Default font size
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
        backgroundColor: _defaultPalette['primary'],
      ),
      body: Container(
        color: _defaultPalette['background'],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: _defaultPalette['text']),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: _defaultPalette['text']),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: _defaultPalette['accent'],
              ),
              child: Text(
                'Login',
                style: TextStyle(color: _defaultPalette['text']),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
