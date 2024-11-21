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
    10.0,
    14.0,
    18.0,
    24.0,
    30.0,
    36.0,
    42.0,
    48.0
  ];

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
        title: const Text('Select Font Size'),
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: textColor),
        titleTextStyle:
            TextStyle(color: textColor, fontSize: _selectedFontSize),
      ),
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Enhanced Preview Area
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: secondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Sample Text Preview',
                    style: TextStyle(
                      fontSize: _selectedFontSize,
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // Predefined Font Size Chips
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8.0,
                runSpacing: 8.0,
                children: predefinedFontSizes.map((size) {
                  return ChoiceChip(
                    label: Text(
                      '${size.toInt()} pt',
                      style: TextStyle(
                        fontSize: 14,
                        color: _getContrastColor(size == _selectedFontSize
                            ? secondaryColor
                            : secondaryColor.withOpacity(0.5)),
                        fontWeight: size == _selectedFontSize
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    selected: _selectedFontSize == size,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedFontSize = size;
                      });
                    },
                    selectedColor: secondaryColor,
                    backgroundColor: secondaryColor.withOpacity(0.3),
                    labelPadding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              // Slider with Larger Range
              Slider(
                value: _selectedFontSize,
                min: 10.0,
                max: 48.0,
                divisions: 38,
                label: _selectedFontSize.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _selectedFontSize = value;
                  });
                },
                activeColor: secondaryColor,
                inactiveColor: secondaryColor.withOpacity(0.4),
              ),
              const SizedBox(height: 24),
              // Finish Button
              ElevatedButton(
                onPressed: _finishSetup,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                  backgroundColor: secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Finish',
                  style: TextStyle(
                    fontSize: 16,
                    color: _getContrastColor(secondaryColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
