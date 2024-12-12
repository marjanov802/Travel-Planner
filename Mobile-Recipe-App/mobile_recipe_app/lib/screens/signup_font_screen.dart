import 'package:flutter/material.dart';
import 'main_home_page.dart';

class SignUpFontScreen extends StatefulWidget {
  final List<Color> selectedPalette;

  const SignUpFontScreen({super.key, required this.selectedPalette});

  @override
  _SignUpFontScreenState createState() => _SignUpFontScreenState();
}

class _SignUpFontScreenState extends State<SignUpFontScreen> {
  double _selectedFontSize = 16.0;
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
          backgroundColor: widget.selectedPalette[1],
          textColor: widget.selectedPalette[2],
          accentColor: widget.selectedPalette[3],
          selectedFontSize: _selectedFontSize,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = widget.selectedPalette[0];
    final Color backgroundColor = widget.selectedPalette[1];
    final Color textColor = widget.selectedPalette[2];
    final Color accentColor = widget.selectedPalette[3];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Font Size'),
        backgroundColor: primaryColor,
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
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
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
                        color: size == _selectedFontSize
                            ? textColor
                            : textColor.withOpacity(0.7),
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
                    selectedColor: accentColor,
                    backgroundColor: accentColor.withOpacity(0.3),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
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
                activeColor: accentColor,
                inactiveColor: accentColor.withOpacity(0.4),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _finishSetup,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                  backgroundColor: accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Finish',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
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
