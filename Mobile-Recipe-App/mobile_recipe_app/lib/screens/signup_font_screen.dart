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
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_handlePageChange);
  }

  @override
  void dispose() {
    _pageController.removeListener(_handlePageChange);
    _pageController.dispose();
    super.dispose();
  }

  void _handlePageChange() {
    if (_pageController.page != null && _pageController.page! >= 1.0) {
      // Automatically trigger saving and navigation when swiping to the next page
      _finishSetup();
    }
  }

  Color _getColorSafely(int index, List<Color> palette, Color fallback) {
    return index < palette.length ? palette[index] : fallback;
  }

  void _finishSetup() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainHomePage(
          primaryColor: _getColorSafely(0, widget.selectedPalette, Colors.blue),
          secondaryColor:
              _getColorSafely(1, widget.selectedPalette, Colors.red),
          accentColor: _getColorSafely(2, widget.selectedPalette, Colors.green),
          backgroundColor:
              _getColorSafely(3, widget.selectedPalette, Colors.white),
          textColor: _getColorSafely(4, widget.selectedPalette, Colors.black),
          selectedFontSize: _selectedFontSize,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Text Size'),
        backgroundColor:
            _getColorSafely(0, widget.selectedPalette, Colors.blue),
      ),
      body: PageView(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (int index) {
          // Trigger _finishSetup when swiping to the next page
          if (index == 1) {
            _finishSetup();
          }
        },
        children: [
          Container(
            color: _getColorSafely(3, widget.selectedPalette, Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Select Text Size',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _getColorSafely(
                          4, widget.selectedPalette, Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _finishSetup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getColorSafely(
                          0, widget.selectedPalette, Colors.blue),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 12),
                    ),
                    child: Text(
                      'Finish',
                      style: TextStyle(
                          fontSize: _selectedFontSize,
                          color: _getColorSafely(
                              4, widget.selectedPalette, Colors.black)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
