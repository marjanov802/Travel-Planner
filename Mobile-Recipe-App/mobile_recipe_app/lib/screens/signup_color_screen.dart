import 'package:flutter/material.dart';
import 'signup_font_screen.dart';

class SignUpColorScreen extends StatefulWidget {
  final bool isGuest;

  const SignUpColorScreen({
    super.key,
    this.isGuest = false,
  });

  @override
  _SignUpColorScreenState createState() => _SignUpColorScreenState();
}

class _SignUpColorScreenState extends State<SignUpColorScreen> {
  final List<Map<String, dynamic>> colorPalettes = [
    {
      'name': 'High Contrast',
      'forUsers': 'Low vision & elderly',
      'colors': {
        'primary': const Color(0xFF0D47A1),
        'background': const Color(0xFFFFFFFF),
        'text': const Color(0xFF000000),
        'accent': const Color(0xFFFFD600),
      },
    },
    {
      'name': 'Colorblind Safe',
      'forUsers': 'Color vision deficiency',
      'colors': {
        'primary': const Color(0xFF0072B2),
        'background': const Color(0xFFFFFFFF),
        'text': const Color(0xFF000000),
        'accent': const Color(0xFFE69F00),
      },
    },
    {
      'name': 'Dark Mode',
      'forUsers': 'Photosensitivity',
      'colors': {
        'primary': const Color(0xFF56CCF2),
        'background': const Color(0xFF121212),
        'text': const Color(0xFFE0E0E0),
        'accent': const Color(0xFFBB86FC),
      },
    },
    {
      'name': 'Low Visual Strain',
      'forUsers': 'Migraine & visual stress',
      'colors': {
        'primary': const Color(0xFF1E88E5),
        'background': const Color(0xFFF8F9FA),
        'text': const Color(0xFF3C4043),
        'accent': const Color(0xFFFF9800),
      },
    },
  ];

  late Map<String, dynamic> _selectedPalette = colorPalettes[0];

  void _selectPalette(Map<String, dynamic> palette) {
    setState(() {
      _selectedPalette = palette;
    });
  }

  void _navigateToFontScreen() {
    final colors = _selectedPalette['colors'] as Map<String, Color>;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignUpFontScreen(
          selectedPalette: [
            colors['primary']!,
            colors['background']!,
            colors['text']!,
            colors['accent']!,
          ],
          isGuest: widget.isGuest,
        ),
      ),
    );
  }

  Widget _buildPaletteCard(Map<String, dynamic> palette) {
    final colors = palette['colors'] as Map<String, Color>;
    bool isSelected = _selectedPalette == palette;

    return GestureDetector(
      onTap: () => _selectPalette(palette),
      child: Container(
        height: 120,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? colors['accent']! : Colors.grey.shade300,
            width: isSelected ? 4 : 2,
          ),
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Row(
          children: [
            // Large color swatches
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: double.infinity,
                      color: colors['primary'],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: double.infinity,
                      color: colors['background'],
                      child: Center(
                        child: Text(
                          'Aa',
                          style: TextStyle(
                            color: colors['text'],
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: double.infinity,
                      color: colors['accent'],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      palette['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'For ${palette['forUsers']}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (isSelected)
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: colors['primary']),
                          const SizedBox(width: 4),
                          const Text('Selected',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSamplePreview() {
    final colors = _selectedPalette['colors'] as Map<String, Color>;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors['background'],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors['primary']!, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors['primary'],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Preview',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Sample text with selected theme',
            style: TextStyle(
              color: colors['text'],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colors['accent'],
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {},
            child: Text(
              'Button Example',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = _selectedPalette['colors'] as Map<String, Color>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Theme Colors',
            style: TextStyle(color: Colors.white)),
        backgroundColor: colors['primary'],
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Choose Your Accessibility Theme',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: colors['primary'],
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Select the option that best suits your visual preferences',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),

              // Palette list
              Expanded(
                child: ListView.builder(
                  itemCount: colorPalettes.length,
                  itemBuilder: (context, index) {
                    return _buildPaletteCard(colorPalettes[index]);
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Preview
              _buildSamplePreview(),

              const SizedBox(height: 24),

              // Next button
              ElevatedButton(
                onPressed: _navigateToFontScreen,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors['primary'],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
