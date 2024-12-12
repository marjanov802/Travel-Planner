import 'package:flutter/material.dart';
import 'signup_color_screen.dart';
import 'signup_font_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isFormCompleted = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_isFormCompleted && _currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _setFormCompleted(bool value) {
    setState(() {
      _isFormCompleted = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Prevent keyboard pushing up non-input pages
      body: GestureDetector(
        onTap: () =>
            FocusScope.of(context).unfocus(), // Dismiss keyboard on tap
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                physics: _isFormCompleted
                    ? const BouncingScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                children: [
                  _SignUpFormPage(
                      onNext: _nextPage, onFormCompleted: _setFormCompleted),
                  const SignUpColorScreen(),
                  const SignUpFontScreen(selectedPalette: [
                    Colors.blue,
                    Colors.white
                  ]), // Default palette
                ],
              ),
            ),
            const SizedBox(
                height: 16), // Gap for dots indicator from the bottom
            _buildDotsIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildDotsIndicator() {
    return Padding(
      padding: const EdgeInsets.only(
          bottom: 16.0), // Move dots up slightly from the bottom
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 8,
            width: _currentPage == index ? 16 : 8,
            decoration: BoxDecoration(
              color: _currentPage == index ? Colors.blueAccent : Colors.grey,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }
}

class _SignUpFormPage extends StatefulWidget {
  final VoidCallback onNext;
  final ValueChanged<bool> onFormCompleted;

  const _SignUpFormPage({required this.onNext, required this.onFormCompleted});

  @override
  _SignUpFormPageState createState() => _SignUpFormPageState();
}

class _SignUpFormPageState extends State<_SignUpFormPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isEmailMatching = false;
  bool _isPasswordMatching = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _confirmEmailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isEmailMatching = _emailController.text.isNotEmpty &&
          _emailController.text == _confirmEmailController.text;
      _isPasswordMatching = _passwordController.text.isNotEmpty &&
          _passwordController.text == _confirmPasswordController.text;

      widget.onFormCompleted(
        _nameController.text.isNotEmpty &&
            _isEmailMatching &&
            _isPasswordMatching,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => _validateForm(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              border: const OutlineInputBorder(),
              suffixIcon: _isEmailMatching
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : null,
            ),
            onChanged: (_) => _validateForm(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _confirmEmailController,
            decoration: InputDecoration(
              labelText: 'Confirm Email',
              border: const OutlineInputBorder(),
              suffixIcon: _isEmailMatching
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : null,
            ),
            onChanged: (_) => _validateForm(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              border: const OutlineInputBorder(),
              suffixIcon: _isPasswordMatching
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : null,
            ),
            onChanged: (_) => _validateForm(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              border: const OutlineInputBorder(),
              suffixIcon: _isPasswordMatching
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : null,
            ),
            onChanged: (_) => _validateForm(),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isFormValid() ? widget.onNext : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
            ),
            child: const Text(
              'Next',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  bool _isFormValid() {
    return _nameController.text.isNotEmpty &&
        _isEmailMatching &&
        _isPasswordMatching;
  }
}
