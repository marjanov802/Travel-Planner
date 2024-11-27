import 'package:flutter/material.dart';
import 'step_screen.dart';

class RecipeDetailScreen extends StatelessWidget {
  final String recipeTitle;
  final List<String> ingredients;
  final List<String> steps;
  final Color primaryColor;
  final Color accentColor;
  final Color backgroundColor;
  final Color textColor;
  final double selectedFontSize;

  const RecipeDetailScreen({
    super.key,
    required this.recipeTitle,
    required this.ingredients,
    required this.steps,
    required this.primaryColor,
    required this.accentColor,
    required this.backgroundColor,
    required this.textColor,
    required this.selectedFontSize,
  });

  void _navigateToSteps(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StepScreen(
          recipeTitle: recipeTitle,
          steps: steps,
          primaryColor: primaryColor,
          accentColor: accentColor,
          backgroundColor: backgroundColor,
          textColor: textColor,
          selectedFontSize: selectedFontSize,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          recipeTitle,
          style: TextStyle(color: textColor),
        ),
        backgroundColor: primaryColor,
      ),
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Ingredients',
              style: TextStyle(
                fontSize: selectedFontSize + 4,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: ingredients.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    color: primaryColor.withOpacity(0.1),
                    child: ListTile(
                      leading: Icon(Icons.check_box_outline_blank,
                          color: accentColor),
                      title: Text(
                        ingredients[index],
                        style: TextStyle(
                          fontSize: selectedFontSize,
                          color: textColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (selectedFontSize <= 24)
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 24.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Select All',
                      style: TextStyle(
                        fontSize: selectedFontSize * 0.9,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ElevatedButton(
                  onPressed: () => _navigateToSteps(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 24.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Start Cooking',
                    style: TextStyle(
                      fontSize: selectedFontSize * 0.9,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
