import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'main_home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  String? _emailError;
  String? _passwordError;
  bool _rememberMe = false;

  // Hardcoded credentials for demo purposes
  final String _hardcodedEmail = 'user@example.com';
  final String _hardcodedPassword = 'password123';

  // Accessibility-focused color palette with WCAG AAA compliance
  final Map<String, Color> _accessibilityPalette = {
    'primary': const Color(0xFF1A3E82),
    'secondary': const Color(0xFF3262B5),
    'background': const Color(0xFFF8F9FA),
    'fieldBackground': Colors.white,
    'text': const Color(0xFF212529),
    'errorText': const Color(0xFFB71C1C),
    'accent': const Color(0xFFFFD700),
  };

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _validateForm() {
    bool hasErrors = false;

    // Validate email field
    if (_emailController.text.isEmpty) {
      setState(() {
        _emailError = 'Please enter your email';
      });
      hasErrors = true;
    } else {
      setState(() {
        _emailError = null;
      });
    }

    // Validate password field
    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = 'Please enter your password';
      });
      hasErrors = true;
    } else {
      setState(() {
        _passwordError = null;
      });
    }

    if (!hasErrors) {
      _handleLogin();
    }
  }

  void _handleLogin() {
    if (_emailController.text == _hardcodedEmail &&
        _passwordController.text == _hardcodedPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainHomePage(
            primaryColor: _accessibilityPalette['primary']!,
            accentColor: _accessibilityPalette['accent']!,
            backgroundColor: _accessibilityPalette['background']!,
            textColor: _accessibilityPalette['text']!,
            selectedFontSize: 20.0,
          ),
        ),
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Invalid email or password. Please use the demo credentials shown below.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          backgroundColor: _accessibilityPalette['errorText'],
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _accessibilityPalette['background'],
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: _accessibilityPalette['primary'],
        elevation: 0,
        iconTheme: const IconThemeData(size: 28),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top decorative bar
            Container(
              width: double.infinity,
              height: 4,
              color: _accessibilityPalette['accent'],
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header section
                    Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: _accessibilityPalette['primary'],
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Please sign in with your account',
                      style: TextStyle(
                        fontSize: 20,
                        color: _accessibilityPalette['text'],
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Email field with enhanced accessibility
                    Semantics(
                      label: 'Email input field',
                      hint: 'Enter your email address',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.email,
                                color: _accessibilityPalette['primary'],
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Email Address',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: _accessibilityPalette['text'],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                              fontSize: 20,
                              color: _accessibilityPalette['text'],
                            ),
                            decoration: InputDecoration(
                              hintText: 'example@email.com',
                              hintStyle: TextStyle(
                                fontSize: 18,
                                color: _accessibilityPalette['text']!
                                    .withOpacity(0.5),
                              ),
                              errorText: _emailError,
                              errorStyle: TextStyle(
                                fontSize: 16,
                                color: _accessibilityPalette['errorText'],
                              ),
                              filled: true,
                              fillColor:
                                  _accessibilityPalette['fieldBackground'],
                              contentPadding: const EdgeInsets.all(16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: _accessibilityPalette['primary']!,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: _accessibilityPalette['text']!
                                      .withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: _accessibilityPalette['primary']!,
                                  width: 2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: _accessibilityPalette['errorText']!,
                                  width: 2,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: _accessibilityPalette['errorText']!,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Password field with enhanced accessibility
                    Semantics(
                      label: 'Password input field',
                      hint: 'Enter your password',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.lock,
                                color: _accessibilityPalette['primary'],
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Password',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: _accessibilityPalette['text'],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            obscureText: !_isPasswordVisible,
                            style: TextStyle(
                              fontSize: 20,
                              color: _accessibilityPalette['text'],
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter your password',
                              hintStyle: TextStyle(
                                fontSize: 18,
                                color: _accessibilityPalette['text']!
                                    .withOpacity(0.5),
                              ),
                              errorText: _passwordError,
                              errorStyle: TextStyle(
                                fontSize: 16,
                                color: _accessibilityPalette['errorText'],
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: _accessibilityPalette['primary'],
                                  size: 24,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                tooltip: _isPasswordVisible
                                    ? 'Hide password'
                                    : 'Show password',
                              ),
                              filled: true,
                              fillColor:
                                  _accessibilityPalette['fieldBackground'],
                              contentPadding: const EdgeInsets.all(16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: _accessibilityPalette['primary']!,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: _accessibilityPalette['text']!
                                      .withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: _accessibilityPalette['primary']!,
                                  width: 2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: _accessibilityPalette['errorText']!,
                                  width: 2,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: _accessibilityPalette['errorText']!,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Remember me checkbox with larger touch target
                    InkWell(
                      onTap: () {
                        setState(() {
                          _rememberMe = !_rememberMe;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                                activeColor: _accessibilityPalette['primary'],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Remember me',
                              style: TextStyle(
                                fontSize: 18,
                                color: _accessibilityPalette['text'],
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Password reset feature coming soon'),
                                  ),
                                );
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: _accessibilityPalette['primary'],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Login button - large and accessible
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _validateForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _accessibilityPalette['accent'],
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Demo credentials box
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _accessibilityPalette['secondary']!
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _accessibilityPalette['secondary']!,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: _accessibilityPalette['primary'],
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Demo Credentials',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _accessibilityPalette['primary'],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Email: user@example.com',
                            style: TextStyle(
                              fontSize: 18,
                              color: _accessibilityPalette['text'],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Password: password123',
                            style: TextStyle(
                              fontSize: 18,
                              color: _accessibilityPalette['text'],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Help link
                    Center(
                      child: TextButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Help center coming soon'),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.help_outline,
                          color: _accessibilityPalette['primary'],
                          size: 24,
                        ),
                        label: Text(
                          'Need help signing in?',
                          style: TextStyle(
                            fontSize: 18,
                            color: _accessibilityPalette['primary'],
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
