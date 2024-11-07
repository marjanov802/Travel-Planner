import 'package:flutter/material.dart';
import 'main_home_page.dart'; // Import for MainHomePage

class SignUpFontScreen extends StatefulWidget {
  final List<Color> selectedPalette; // Required parameter for color scheme

  const SignUpFontScreen({super.key, required this.selectedPalette});

  @override
  _SignUpFontScreenState createState() => _SignUpFontScreenState();
}

class _SignUpFontScreenState extends State<SignUpFontScreen> {
  double _selectedFontSize = 16.0; // Default font size
  final List<double> predefinedFontSizes = [
    14.0,
    18.0,
    24.0
  ]; // Predefined options

  void _finishSetup() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainHomePage(
          primaryColor: widget.selectedPalette[0],
          secondaryColor: widget.selectedPalette[1],
          accentColor: widget.selectedPalette[2],
          backgroundColor: widget.selectedPalette[0],
          textColor: widget.selectedPalette[2],
          selectedFontSize: _selectedFontSize,
        ),
      ),
    );
  }

  Color _getContrastColor(Color color) {
    // Simple contrast check for text visibility
    final double luminance =
        (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = widget.selectedPalette[0];
    final Color secondaryColor = widget.selectedPalette[1];
    final Color textColor = widget.selectedPalette[2];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Text Size'),
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: textColor),
        titleTextStyle:
            TextStyle(color: textColor, fontSize: _selectedFontSize),
      ),
      body: Container(
        color: backgroundColor, // Set the background color
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Select your preferred text size',
              style: TextStyle(
                fontSize: _selectedFontSize,
                fontWeight: FontWeight.bold,
                color: textColor, // Apply text color from palette
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Predefined options for quick selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: predefinedFontSizes.map((size) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedFontSize = size;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    backgroundColor: secondaryColor,
                  ),
                  child: Text(
                    size == _selectedFontSize
                        ? 'Selected'
                        : '${size.toInt()} pt',
                    style: TextStyle(
                      fontSize: size,
                      color: _getContrastColor(secondaryColor),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            // Slider for custom font size selection
            Text(
              'Custom Size',
              style: TextStyle(
                fontSize: _selectedFontSize,
                fontWeight: FontWeight.bold,
                color: textColor, // Apply text color from palette
              ),
              textAlign: TextAlign.center,
            ),
            Slider(
              value: _selectedFontSize,
              min: 12.0,
              max: 30.0,
              divisions: 18,
              label: _selectedFontSize.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _selectedFontSize = value;
                });
              },
              activeColor: secondaryColor, // Apply secondary color for slider
              inactiveColor:
                  secondaryColor.withOpacity(0.5), // Lighter for inactive part
            ),
            // Live preview of selected font size
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(8),
              color: secondaryColor,
              child: Text(
                'This is how your text will look',
                style: TextStyle(
                  fontSize: _selectedFontSize,
                  color: _getContrastColor(secondaryColor),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _finishSetup,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                backgroundColor: secondaryColor,
              ),
              child: Text(
                'Finish',
                style: TextStyle(
                  fontSize: _selectedFontSize,
                  color: _getContrastColor(secondaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
