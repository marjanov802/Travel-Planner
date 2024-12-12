import 'package:flutter/material.dart';
import 'signup_font_screen.dart';

class SignUpColorScreen extends StatefulWidget {
  const SignUpColorScreen({super.key});

  @override
  _SignUpColorScreenState createState() => _SignUpColorScreenState();
}

class _SignUpColorScreenState extends State<SignUpColorScreen> {
  final List<Map<String, Color>> colorPalettes = [
    // Palette 1: Calm Blue (For Visually Impaired - High Contrast)
    {
      'primary': const Color(0xFF004A99), // Dark blue
      'background': const Color(0xFFEFF6FF), // Very light blue/white
      'text': const Color(0xFF000000), // Black
      'accent': const Color(0xFFFFC107), // Bright yellow
    },
    // Palette 2: Soft Warm (For Older Adults - Warm Tones)
    {
      'primary': const Color(0xFF6D4C41), // Dark brown
      'background': const Color(0xFFF9F4EF), // Cream
      'text': const Color(0xFF2C2C2C), // Dark gray
      'accent': const Color(0xFFFF7043), // Warm orange
    },
    // Palette 3: High Contrast (For Color Blindness)
    {
      'primary': const Color(0xFF000000), // Black
      'background': const Color(0xFFFFFFFF), // White
      'text': const Color(0xFF000000), // Black
      'accent': const Color(0xFF00897B), // Teal
    },
    // Palette 4: Cool Neutral (For General Use - Low Eye Strain)
    {
      'primary': const Color(0xFF37474F), // Dark grayish blue
      'background': const Color(0xFFECEFF1), // Light gray
      'text': const Color(0xFF102027), // Very dark gray/blue
      'accent': const Color(0xFF29B6F6), // Bright blue
    },
    // Palette 5: Soft Green (For Color Blind Friendly and Calmness)
    {
      'primary': const Color(0xFF2E7D32), // Dark green
      'background': const Color(0xFFE8F5E9), // Pale green
      'text': const Color(0xFF1B5E20), // Deep green
      'accent': const Color(0xFF81C784), // Soft green
    },
  ];

  Map<String, Color> _selectedPalette = {
    'primary': const Color(0xFF005EB8),
    'background': const Color(0xFFFFFFFF),
    'text': const Color(0xFF000000),
    'accent': const Color(0xFFFF5722),
  };

  void _selectPalette(Map<String, Color> palette) {
    setState(() {
      _selectedPalette = palette;
    });
  }

  void _navigateToFontScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignUpFontScreen(
          selectedPalette: [
            _selectedPalette['primary']!,
            _selectedPalette['background']!,
            _selectedPalette['text']!,
            _selectedPalette['accent']!,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Choose a Theme',
          style: TextStyle(color: _selectedPalette['text']),
        ),
        backgroundColor: _selectedPalette['primary'],
      ),
      body: Container(
        color: _selectedPalette['background'],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Choose a Theme',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _selectedPalette['text'],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: colorPalettes.length,
                itemBuilder: (context, index) {
                  final palette = colorPalettes[index];
                  return GestureDetector(
                    onTap: () => _selectPalette(palette),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedPalette == palette
                              ? palette['accent']!
                              : Colors.grey,
                          width: _selectedPalette == palette ? 3 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildColorPreview('Primary', palette['primary']!),
                          _buildColorPreview(
                              'Background', palette['background']!),
                          _buildColorPreview('Text', palette['text']!),
                          _buildColorPreview('Accent', palette['accent']!),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _navigateToFontScreen,
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedPalette['primary'],
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Next',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _selectedPalette['text'],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPreview(String label, Color color) {
    return Container(
      height: 50,
      width: double.infinity,
      color: color,
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
