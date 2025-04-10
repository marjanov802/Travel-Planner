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

  // Accessibility-focused color palette matching our welcome screen
  final Map<String, Color> _accessibilityPalette = {
    'primary': const Color(0xFF1A3E82),
    'secondary': const Color(0xFF3262B5),
    'background': const Color(0xFFF8F9FA),
    'fieldBackground': Colors.white,
    'text': const Color(0xFF212529),
    'errorText': const Color(0xFFB71C1C),
    'accent': const Color(0xFFFFD700),
    'success': const Color(0xFF2E7D32),
  };

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
      backgroundColor: _accessibilityPalette['background'],
      appBar: AppBar(
        title: const Text(
          'Create Account',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: _accessibilityPalette['primary'],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 28),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Back to Welcome Screen',
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            // Top decorative bar
            Container(
              width: double.infinity,
              height: 4,
              color: _accessibilityPalette['accent'],
            ),

            // Step indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStepIndicator(0, 'Account'),
                  _buildStepConnector(0),
                  _buildStepIndicator(1, 'Colors'),
                  _buildStepConnector(1),
                  _buildStepIndicator(2, 'Text Size'),
                ],
              ),
            ),

            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                physics: _isFormCompleted
                    ? const BouncingScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                children: [
                  _SignUpFormPage(
                    onNext: _nextPage,
                    onFormCompleted: _setFormCompleted,
                    colorPalette: _accessibilityPalette,
                  ),
                  const SignUpColorScreen(),
                  const SignUpFontScreen(selectedPalette: [
                    Colors.blue,
                    Colors.white,
                    Colors.black,
                    Colors.amber,
                  ]),
                ],
              ),
            ),

            // Dots indicator at bottom
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    height: 12,
                    width: _currentPage == index ? 32 : 12,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? _accessibilityPalette['primary']
                          : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: _currentPage == index
                            ? _accessibilityPalette['primary']!
                            : Colors.grey.shade400,
                        width: 2,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    final bool isActive = _currentPage >= step;
    final bool isCurrent = _currentPage == step;

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive
                ? _accessibilityPalette['primary']
                : Colors.grey.shade300,
            shape: BoxShape.circle,
            border: Border.all(
              color: isCurrent
                  ? _accessibilityPalette['accent']!
                  : (isActive
                      ? _accessibilityPalette['primary']!
                      : Colors.grey.shade300),
              width: isCurrent ? 3 : 1,
            ),
          ),
          child: Center(
            child: Text(
              '${step + 1}',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey.shade600,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive
                ? _accessibilityPalette['primary']
                : Colors.grey.shade600,
            fontSize: 16,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector(int beforeStep) {
    final bool isActive = _currentPage > beforeStep;

    return Container(
      width: 60,
      height: 4,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: isActive ? _accessibilityPalette['primary'] : Colors.grey.shade300,
    );
  }
}

class _SignUpFormPage extends StatefulWidget {
  final VoidCallback onNext;
  final ValueChanged<bool> onFormCompleted;
  final Map<String, Color> colorPalette;

  const _SignUpFormPage({
    required this.onNext,
    required this.onFormCompleted,
    required this.colorPalette,
  });

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

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _confirmEmailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  bool _isEmailMatching = false;
  bool _isPasswordMatching = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  String? _nameError;
  String? _emailError;
  String? _confirmEmailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _confirmEmailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _confirmEmailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      // Validate name
      if (_nameController.text.isEmpty) {
        _nameError = 'Please enter your name';
      } else {
        _nameError = null;
      }

      // Validate email
      if (_emailController.text.isEmpty) {
        _emailError = 'Please enter your email';
        _isEmailMatching = false;
      } else if (!_isValidEmail(_emailController.text)) {
        _emailError = 'Please enter a valid email address';
        _isEmailMatching = false;
      } else {
        _emailError = null;
      }

      // Validate confirm email
      if (_confirmEmailController.text.isEmpty) {
        _confirmEmailError = 'Please confirm your email';
        _isEmailMatching = false;
      } else if (_emailController.text != _confirmEmailController.text) {
        _confirmEmailError = 'Emails do not match';
        _isEmailMatching = false;
      } else {
        _confirmEmailError = null;
        _isEmailMatching = _emailController.text.isNotEmpty &&
            _emailController.text == _confirmEmailController.text;
      }

      // Validate password
      if (_passwordController.text.isEmpty) {
        _passwordError = 'Please enter a password';
        _isPasswordMatching = false;
      } else if (_passwordController.text.length < 6) {
        _passwordError = 'Password must be at least 6 characters';
        _isPasswordMatching = false;
      } else {
        _passwordError = null;
      }

      // Validate confirm password
      if (_confirmPasswordController.text.isEmpty) {
        _confirmPasswordError = 'Please confirm your password';
        _isPasswordMatching = false;
      } else if (_passwordController.text != _confirmPasswordController.text) {
        _confirmPasswordError = 'Passwords do not match';
        _isPasswordMatching = false;
      } else {
        _confirmPasswordError = null;
        _isPasswordMatching = _passwordController.text.isNotEmpty &&
            _passwordController.text == _confirmPasswordController.text;
      }

      widget.onFormCompleted(
        _nameError == null &&
            _emailError == null &&
            _confirmEmailError == null &&
            _passwordError == null &&
            _confirmPasswordError == null &&
            _isEmailMatching &&
            _isPasswordMatching,
      );
    });
  }

  bool _isValidEmail(String email) {
    // Simple email validation
    return RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create Your Account',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: widget.colorPalette['primary'],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please fill in all the fields below',
              style: TextStyle(
                fontSize: 18,
                color: widget.colorPalette['text'],
              ),
            ),
            const SizedBox(height: 24),

            // Name field
            _buildFormField(
              controller: _nameController,
              focusNode: _nameFocusNode,
              label: 'Full Name',
              hint: 'Enter your full name',
              icon: Icons.person,
              error: _nameError,
              onChanged: (_) => _validateForm(),
            ),
            const SizedBox(height: 20),

            // Email field
            _buildFormField(
              controller: _emailController,
              focusNode: _emailFocusNode,
              label: 'Email Address',
              hint: 'Enter your email address',
              icon: Icons.email,
              error: _emailError,
              keyboardType: TextInputType.emailAddress,
              onChanged: (_) => _validateForm(),
            ),
            const SizedBox(height: 20),

            // Confirm Email field
            _buildFormField(
              controller: _confirmEmailController,
              focusNode: _confirmEmailFocusNode,
              label: 'Confirm Email',
              hint: 'Confirm your email address',
              icon: Icons.email,
              error: _confirmEmailError,
              keyboardType: TextInputType.emailAddress,
              onChanged: (_) => _validateForm(),
              suffixIcon:
                  _isEmailMatching && _confirmEmailController.text.isNotEmpty
                      ? Icon(
                          Icons.check_circle,
                          color: widget.colorPalette['success'],
                          size: 24,
                        )
                      : null,
            ),
            const SizedBox(height: 20),

            // Password field
            _buildFormField(
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              label: 'Password',
              hint: 'Create a password',
              icon: Icons.lock,
              error: _passwordError,
              obscureText: !_isPasswordVisible,
              onChanged: (_) => _validateForm(),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: widget.colorPalette['secondary'],
                  size: 24,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                tooltip: _isPasswordVisible ? 'Hide password' : 'Show password',
              ),
            ),
            const SizedBox(height: 20),

            // Confirm Password field
            _buildFormField(
              controller: _confirmPasswordController,
              focusNode: _confirmPasswordFocusNode,
              label: 'Confirm Password',
              hint: 'Confirm your password',
              icon: Icons.lock,
              error: _confirmPasswordError,
              obscureText: !_isConfirmPasswordVisible,
              onChanged: (_) => _validateForm(),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isPasswordMatching &&
                      _confirmPasswordController.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.check_circle,
                        color: widget.colorPalette['success'],
                        size: 24,
                      ),
                    ),
                  IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: widget.colorPalette['secondary'],
                      size: 24,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                    tooltip: _isConfirmPasswordVisible
                        ? 'Hide password'
                        : 'Show password',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Next button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isFormValid() ? widget.onNext : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.colorPalette['accent'],
                  foregroundColor: Colors.black,
                  disabledBackgroundColor: Colors.grey.shade300,
                  disabledForegroundColor: Colors.grey.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Next Step',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 24),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Privacy info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.colorPalette['secondary']!.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.colorPalette['secondary']!,
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.privacy_tip,
                    color: widget.colorPalette['primary'],
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your information is securely stored. We will never share your details without your permission.',
                      style: TextStyle(
                        fontSize: 16,
                        color: widget.colorPalette['text'],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required IconData icon,
    String? error,
    bool obscureText = false,
    TextInputType? keyboardType,
    void Function(String)? onChanged,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with icon
        Row(
          children: [
            Icon(
              icon,
              color: widget.colorPalette['primary'],
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: widget.colorPalette['text'],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Text field
        TextField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: TextStyle(
            fontSize: 18,
            color: widget.colorPalette['text'],
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: widget.colorPalette['text']!.withOpacity(0.5),
              fontSize: 16,
            ),
            errorText: error,
            errorStyle: TextStyle(
              fontSize: 14,
              color: widget.colorPalette['errorText'],
            ),
            filled: true,
            fillColor: widget.colorPalette['fieldBackground'],
            contentPadding: const EdgeInsets.all(16),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: widget.colorPalette['text']!.withOpacity(0.3),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: widget.colorPalette['text']!.withOpacity(0.3),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: widget.colorPalette['primary']!,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: widget.colorPalette['errorText']!,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: widget.colorPalette['errorText']!,
                width: 2,
              ),
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  bool _isFormValid() {
    return _nameController.text.isNotEmpty &&
        _isEmailMatching &&
        _isPasswordMatching;
  }
}
