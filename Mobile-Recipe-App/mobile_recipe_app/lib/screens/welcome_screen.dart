import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'signup_color_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _navigateToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _navigateToSignUp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  void _continueAsGuest(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpColorScreen(
          isGuest: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Accessibility-focused color scheme
    const Color backgroundColor = Color(0xFF1A3E82);
    const Color buttonTextColor = Color(0xFF1A3E82);
    const Color lightTextColor = Colors.white;
    const Color primaryButtonColor = Colors.white;
    const Color secondaryButtonColor =
        Color(0xFF3262B5); // Darkened for WCAG AAA compliance
    const Color accentButtonColor = Color(0xFFFFD700);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo and title in a row to save vertical space
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: lightTextColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: lightTextColor, width: 2),
                    ),
                    child: const Icon(
                      Icons.food_bank,
                      size: 45,
                      color: backgroundColor,
                      semanticLabel: 'Recipe app icon',
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: lightTextColor,
                          ),
                        ),
                        Text(
                          'Cooking Recipes',
                          style: TextStyle(
                            fontSize: 22,
                            color: lightTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Description text
              const Text(
                'Find delicious recipes with easy-to-follow instructions',
                style: TextStyle(
                  fontSize: 22,
                  color: lightTextColor,
                ),
              ),

              // Buttons
              ElevatedButton.icon(
                onPressed: () => _navigateToLogin(context),
                icon: const Icon(
                  Icons.login,
                  size: 28,
                  color: buttonTextColor,
                ),
                label: const Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: buttonTextColor,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryButtonColor,
                  foregroundColor: buttonTextColor,
                  minimumSize: const Size(double.infinity, 60),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              ElevatedButton.icon(
                onPressed: () => _navigateToSignUp(context),
                icon: const Icon(
                  Icons.person_add,
                  size: 28,
                  color: lightTextColor,
                ),
                label: const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: lightTextColor,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryButtonColor,
                  foregroundColor: lightTextColor,
                  minimumSize: const Size(double.infinity, 60),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              ElevatedButton.icon(
                onPressed: () => _continueAsGuest(context),
                icon: const Icon(
                  Icons.visibility,
                  size: 28,
                  color: Colors.black87,
                ),
                label: const Text(
                  'Continue as Guest',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentButtonColor,
                  foregroundColor: Colors.black87,
                  minimumSize: const Size(double.infinity, 60),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              // Accessibility hint - compact version
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: secondaryButtonColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: lightTextColor, width: 1),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.accessibility_new,
                      color: lightTextColor,
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Accessibility features included',
                        style: TextStyle(
                          color: lightTextColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
