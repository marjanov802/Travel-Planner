import 'package:flutter/material.dart';
import 'signup_font_screen.dart'; // Import for SignUpFontScreen

class SignUpColorScreen extends StatefulWidget {
  const SignUpColorScreen({super.key});

  @override
  _SignUpColorScreenState createState() => _SignUpColorScreenState();
}

class _SignUpColorScreenState extends State<SignUpColorScreen> {
  final List<List<Color>> colorPalettes = [
    [
      Colors.teal.shade400,
      Colors.teal.shade600,
      Colors.cyan.shade400,
      Colors.white,
      Colors.grey.shade800
    ],
    [
      Colors.deepOrange.shade400,
      Colors.orangeAccent,
      Colors.amber.shade600,
      Colors.white,
      Colors.black
    ],
    [
      Colors.green.shade600,
      Colors.lime.shade600,
      Colors.teal.shade800,
      Colors.white,
      Colors.grey.shade700
    ],
    [
      Colors.blueGrey.shade900,
      Colors.blue.shade800,
      Colors.indigo.shade600,
      Colors.black,
      Colors.white
    ],
    [
      Colors.pink.shade300,
      Colors.purple.shade200,
      Colors.cyan.shade200,
      Colors.white,
      Colors.grey.shade900
    ],
    [
      Colors.black,
      Colors.yellow.shade600,
      Colors.redAccent,
      Colors.white,
      Colors.grey.shade800
    ],
    [
      Colors.blue.shade400,
      Colors.indigo.shade300,
      Colors.lightBlue.shade200,
      Colors.white,
      Colors.grey.shade600
    ],
    [
      Colors.brown.shade400,
      Colors.orange.shade600,
      Colors.deepOrangeAccent,
      Colors.white,
      Colors.black
    ],
  ];

  List<Color> _selectedPalette = [
    Colors.teal.shade400,
    Colors.white
  ]; // Default palette
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_handlePageSwipe);
  }

  @override
  void dispose() {
    _pageController.removeListener(_handlePageSwipe);
    _pageController.dispose();
    super.dispose();
  }

  void _selectPalette(List<Color> palette) {
    setState(() {
      _selectedPalette = palette;
    });
  }

  void _nextPage() {
    _navigateToFontScreen();
  }

  void _handlePageSwipe() {
    if (_pageController.page != null && _pageController.page! >= 1.0) {
      // Trigger navigation when swiping past the first page
      _navigateToFontScreen();
    }
  }

  void _navigateToFontScreen() {
    // Ensure that the selected palette has at least 5 colors
    List<Color> fallbackPalette = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.white,
      Colors.black
    ];
    List<Color> paletteToPass =
        _selectedPalette.length >= 5 ? _selectedPalette : fallbackPalette;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignUpFontScreen(
          selectedPalette: paletteToPass, // Pass the selected palette
        ),
      ),
    );
  }

  Color _getColorFromPalette(List<Color> palette, int index, Color fallback) {
    return index < palette.length ? palette[index] : fallback;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Colour Scheme'),
        backgroundColor: _getColorFromPalette(_selectedPalette, 0, Colors.blue),
      ),
      body: PageView(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            color: _getColorFromPalette(_selectedPalette, 3, Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Choose a Colour Scheme',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _getColorFromPalette(
                          _selectedPalette, 4, Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: colorPalettes.length,
                      itemBuilder: (context, index) {
                        final palette = colorPalettes[index];
                        return GestureDetector(
                          onTap: () => _selectPalette(palette),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _selectedPalette == palette
                                    ? Colors.black
                                    : Colors.transparent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: palette.map((color) {
                                return Expanded(
                                  child: Container(
                                    height: double.infinity,
                                    color: color,
                                    margin: const EdgeInsets.all(1),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getColorFromPalette(
                          _selectedPalette, 0, Colors.blue),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 12),
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(
                          fontSize: 18,
                          color: _getColorFromPalette(
                              _selectedPalette, 4, Colors.white)),
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
