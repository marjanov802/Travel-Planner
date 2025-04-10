import 'package:flutter/material.dart';
import 'main_home_page.dart';

class SignUpFontScreen extends StatefulWidget {
  final List<Color> selectedPalette;
  final bool isGuest;

  const SignUpFontScreen({
    super.key,
    required this.selectedPalette,
    this.isGuest = false,
  });

  @override
  _SignUpFontScreenState createState() => _SignUpFontScreenState();
}

class _SignUpFontScreenState extends State<SignUpFontScreen> {
  double _selectedFontSize = 24.0;
  final List<double> predefinedFontSizes = [
    14.0,
    18.0,
    24.0,
    30.0,
    36.0,
    42.0,
    48.0
  ];

  // Map font sizes to accessibility standards
  final Map<double, String> fontSizeDescription = {
    14.0: 'Small - Compact UI',
    18.0: 'Medium - Standard size',
    24.0: 'Large - Enhanced readability',
    30.0: 'XL - Low vision friendly',
    36.0: 'XXL - Significant visual impairment',
    42.0: 'XXXL - Very low vision',
    48.0: 'Maximum - Highest accessibility',
  };

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
        title: Text(
          'Text Size Preferences',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: backgroundColor,
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Optimize Text Size for Readability',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Choose a comfortable text size based on your visual preferences',
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor.withOpacity(0.8),
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Simple preview card
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: backgroundColor == Colors.white
                          ? accentColor.withOpacity(0.05)
                          : primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: primaryColor, width: 2),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Text Preview',
                          style: TextStyle(
                            fontSize: _selectedFontSize > 30.0 ? 16 : 18,
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Sample text',
                          style: TextStyle(
                            fontSize: _selectedFontSize,
                            color: textColor,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: accentColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Button',
                            style: TextStyle(
                              fontSize: _selectedFontSize > 30.0 ? 14 : 16,
                              color: backgroundColor == Colors.black
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Font size selection
                  Text(
                    'Font size: ${_selectedFontSize.round()} pt',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  // Font size description
                  Text(
                    fontSizeDescription[_selectedFontSize] ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor.withOpacity(0.8),
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  // Font size preset buttons
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: predefinedFontSizes.length,
                      itemBuilder: (context, index) {
                        final size = predefinedFontSizes[index];
                        final isSelected = size == _selectedFontSize;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedFontSize = size;
                            });
                          },
                          child: Container(
                            width: 60,
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                              color:
                                  isSelected ? accentColor : Colors.transparent,
                              border: Border.all(
                                color: isSelected ? accentColor : primaryColor,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${size.round()}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? (backgroundColor == Colors.black
                                            ? Colors.white
                                            : Colors.black)
                                        : textColor,
                                  ),
                                ),
                                Text(
                                  'pt',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isSelected
                                        ? (backgroundColor == Colors.black
                                            ? Colors.white
                                            : Colors.black)
                                        : textColor.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Slider for fine-tuning
                  Slider(
                    value: _selectedFontSize,
                    min: 14.0,
                    max: 48.0,
                    divisions: 34,
                    label: '${_selectedFontSize.round()} pt',
                    onChanged: (double value) {
                      setState(() {
                        _selectedFontSize = value;
                      });
                    },
                    activeColor: accentColor,
                    inactiveColor: primaryColor.withOpacity(0.2),
                  ),

                  const SizedBox(height: 24),

                  // Finish button
                  ElevatedButton(
                    onPressed: _finishSetup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      minimumSize: const Size(double.infinity, 60),
                    ),
                    child: const Text(
                      'Complete Setup',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
