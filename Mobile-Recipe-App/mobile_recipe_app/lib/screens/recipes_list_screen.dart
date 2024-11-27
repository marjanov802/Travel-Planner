import 'package:flutter/material.dart';
import 'recipe_detail_screen.dart';

class RecipesListScreen extends StatelessWidget {
  final Color primaryColor;
  final Color accentColor;
  final Color backgroundColor;
  final Color textColor;
  final double selectedFontSize;

  const RecipesListScreen({
    super.key,
    required this.primaryColor,
    required this.accentColor,
    required this.backgroundColor,
    required this.textColor,
    required this.selectedFontSize,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> recipes = [
      {
        'title': 'Spaghetti Carbonara',
        'description':
            'Classic Italian pasta with eggs, cheese, pancetta, and pepper.',
        'ingredients': [
          '200g spaghetti',
          '100g pancetta',
          '2 large eggs',
          '50g pecorino cheese',
          'Salt and black pepper'
        ],
        'steps': [
          'Cook spaghetti in salted boiling water until al dente.',
          'Fry pancetta until crispy.',
          'Whisk eggs and cheese together in a bowl.',
          'Drain spaghetti and mix with pancetta and egg mixture.',
          'Serve with a sprinkle of pepper and cheese.'
        ],
      },
      {
        'title': 'Chicken Curry',
        'description':
            'A flavorful and spicy curry with tender chicken pieces.',
        'ingredients': [
          '500g chicken thighs',
          '2 onions, chopped',
          '3 garlic cloves, minced',
          '200ml coconut milk',
          '2 tbsp curry powder'
        ],
        'steps': [
          'Sauté onions and garlic until soft.',
          'Add chicken and cook until browned.',
          'Stir in curry powder and cook for 1 minute.',
          'Pour in coconut milk and simmer for 20 minutes.',
          'Serve with rice.'
        ],
      },
      // Add more recipes as needed
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Explore Recipes', style: TextStyle(color: textColor)),
        backgroundColor: primaryColor,
      ),
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                color: primaryColor.withOpacity(0.1),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailScreen(
                          recipeTitle: recipes[index]['title']!,
                          ingredients: recipes[index]['ingredients'],
                          steps: recipes[index]['steps'],
                          primaryColor: primaryColor,
                          accentColor: accentColor,
                          backgroundColor: backgroundColor,
                          textColor: textColor,
                          selectedFontSize: selectedFontSize,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Placeholder
                        Container(
                          width: double.infinity,
                          height: selectedFontSize > 30 ? 160 : 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: accentColor.withOpacity(0.4),
                            border: Border.all(color: accentColor, width: 2),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.fastfood,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Recipe Title
                        Text(
                          recipes[index]['title']!,
                          style: TextStyle(
                            fontSize:
                                selectedFontSize > 24 ? 24 : selectedFontSize,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        // Recipe Description
                        Text(
                          recipes[index]['description']!,
                          style: TextStyle(
                            fontSize: selectedFontSize * 0.8,
                            color: textColor.withOpacity(0.7),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
