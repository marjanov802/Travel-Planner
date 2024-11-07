import 'package:flutter/material.dart';
import 'signup_font_screen.dart'; // Import for SignUpFontScreen

class SignUpColorScreen extends StatefulWidget {
  const SignUpColorScreen({super.key});

  @override
  _SignUpColorScreenState createState() => _SignUpColorScreenState();
}

class _SignUpColorScreenState extends State<SignUpColorScreen> {
  final List<Map<String, Color>> colorPalettes = [
    {
      'background': Colors.teal.shade400,
      'secondary': Colors.cyan.shade400,
      'text': Colors.white,
    },
    {
      'background': Colors.deepOrange.shade400,
      'secondary': Colors.orangeAccent,
      'text': Colors.black,
    },
    {
      'background': Colors.green.shade600,
      'secondary': Colors.lime.shade600,
      'text': Colors.white,
    },
    {
      'background': Colors.blueGrey.shade900,
      'secondary': Colors.blue.shade800,
      'text': Colors.white,
    },
    {
      'background': Colors.pink.shade300,
      'secondary': Colors.purple.shade200,
      'text': Colors.black,
    },
  ];

  Map<String, Color> _selectedPalette = {
    'background': Colors.teal.shade400,
    'secondary': Colors.cyan.shade400,
    'text': Colors.white,
  }; // Default palette

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
            _selectedPalette['background'] ?? Colors.white,
            _selectedPalette['secondary'] ?? Colors.grey,
            _selectedPalette['text'] ?? Colors.black,
          ],
        ),
      ),
    );
  }

  Color _getContrastColor(Color color) {
    // Calculate luminance to determine contrast (simple approximation)
    final double luminance =
        (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor =
        _getContrastColor(_selectedPalette['background'] ?? Colors.white);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Choose a Color Scheme',
          style: TextStyle(
              color: _selectedPalette['text'] ??
                  Colors.white), // Handling nullable text color
        ),
        backgroundColor: _selectedPalette['background'] ?? Colors.blue,
        iconTheme:
            IconThemeData(color: _selectedPalette['text'] ?? Colors.white),
      ),
      body: Container(
        color: _selectedPalette['background'] ?? Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Choose a Color Scheme',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor, // Ensuring visible text
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
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _selectedPalette == palette
                                ? Colors.black
                                : Colors.grey,
                            width: _selectedPalette == palette ? 3 : 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              width: double.infinity,
                              color: palette['background'] ?? Colors.white,
                              child: Center(
                                child: Text(
                                  'Background',
                                  style: TextStyle(
                                    color: _getContrastColor(
                                        palette['background'] ?? Colors.white),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: double.infinity,
                              color: palette['secondary'] ?? Colors.grey,
                              child: Center(
                                child: Text(
                                  'Secondary',
                                  style: TextStyle(
                                    color: _getContrastColor(
                                        palette['secondary'] ?? Colors.grey),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: double.infinity,
                              color: palette['text'] ?? Colors.black,
                              child: Center(
                                child: Text(
                                  'Text Color',
                                  style: TextStyle(
                                    color: _getContrastColor(
                                        palette['text'] ?? Colors.black),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                  textStyle: TextStyle(
                    fontSize: 18,
                    color: _selectedPalette['text'] ?? Colors.white,
                  ),
                  backgroundColor: _selectedPalette['secondary'] ?? Colors.blue,
                ),
                child: Text(
                  'Next',
                  style: TextStyle(
                      color: _selectedPalette['text'] ?? Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
