import 'package:flutter/material.dart';
import 'recipes_list_screen.dart';
import 'settings_screen.dart';

class MainHomePage extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color backgroundColor;
  final Color textColor;
  final double selectedFontSize;

  const MainHomePage({
    super.key,
    required this.primaryColor,
    required this.secondaryColor,
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
              color: primaryColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipesListScreen(
                      primaryColor: primaryColor,
                      secondaryColor: secondaryColor,
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
              color: primaryColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()),
                );
              },
            ),
            const SizedBox(height: 24),
            _buildFullWidthCard(
              context,
              title: 'Favorites',
              description: 'View and manage your favorite recipes.',
              icon: Icons.favorite,
              color: primaryColor,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Favorites feature coming soon!')),
                );
              },
            ),
            const SizedBox(height: 24),
            _buildFullWidthCard(
              context,
              title: 'Help & Support',
              description: 'Get assistance and contact support.',
              icon: Icons.help_outline,
              color: primaryColor,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Help & Support feature coming soon!')),
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
    required Color color,
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
            color: color,
          ),
          child: Row(
            children: [
              Icon(icon, size: 48, color: Colors.white),
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
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: selectedFontSize,
                        color: Colors.white.withOpacity(0.9),
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
