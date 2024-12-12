import 'package:flutter/material.dart';
import 'recipes_list_screen.dart';
import 'settings_screen.dart';

class MainHomePage extends StatelessWidget {
  final Color primaryColor;
  final Color accentColor;
  final Color backgroundColor;
  final Color textColor;
  final double selectedFontSize;

  const MainHomePage({
    super.key,
    required this.primaryColor,
    required this.accentColor,
    required this.backgroundColor,
    required this.textColor,
    required this.selectedFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Main Menu',
          style: TextStyle(fontSize: selectedFontSize, color: textColor),
        ),
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildFullWidthCard(
              context,
              title: 'Explore Recipes',
              description: 'Find and create delicious recipes.',
              icon: Icons.kitchen,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipesListScreen(
                      primaryColor: primaryColor,
                      accentColor: accentColor,
                      backgroundColor: backgroundColor,
                      textColor: textColor,
                      selectedFontSize: selectedFontSize,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            _buildFullWidthCard(
              context,
              title: 'Settings',
              description: 'Adjust preferences and personalize your app.',
              icon: Icons.settings,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(
                      primaryColor: primaryColor,
                      accentColor: accentColor,
                      backgroundColor: backgroundColor,
                      textColor: textColor,
                      selectedFontSize: selectedFontSize,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            _buildFullWidthCard(
              context,
              title: 'Favorites',
              description: 'View and manage your favorite recipes.',
              icon: Icons.favorite,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Favorites feature coming soon!',
                      style: TextStyle(color: textColor),
                    ),
                    backgroundColor: primaryColor,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            _buildFullWidthCard(
              context,
              title: 'Help & Support',
              description: 'Get assistance and contact support.',
              icon: Icons.help_outline,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Help & Support feature coming soon!',
                      style: TextStyle(color: textColor),
                    ),
                    backgroundColor: primaryColor,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullWidthCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: backgroundColor,
          ),
          child: Row(
            children: [
              Icon(icon, size: 48, color: accentColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: selectedFontSize * 0.9,
                        color: textColor.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
