import 'package:flutter/material.dart';
import 'recipe_detail_screen.dart';

class RecipesListScreen extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color backgroundColor;
  final Color textColor;
  final double selectedFontSize;

  const RecipesListScreen({
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
    final List<Map<String, dynamic>> recipes = [
      {
        'title': 'Spaghetti Carbonara',
        'description':
            'Classic Italian pasta with eggs, cheese, pancetta, and pepper.',
        'ingredients': [
          '200g Pancetta',
          '100g Parmesan Cheese',
          '3 Large Eggs',
          '400g Spaghetti',
          'Salt and Pepper',
        ],
        'steps': [
          'Bring a large pot of salted water to a boil.',
          'Cook the spaghetti according to the package instructions.',
          'While the spaghetti cooks, heat a pan over medium heat and cook the pancetta.',
          'In a bowl, whisk the eggs and Parmesan cheese together.',
          'Drain the spaghetti and add it to the pan with pancetta. Remove from heat.',
          'Quickly mix the egg and cheese mixture into the pasta.',
          'Season with salt and pepper, then serve immediately.',
        ],
      },
      {
        'title': 'Chicken Curry',
        'description':
            'A flavorful and spicy curry with tender chicken pieces.',
        'ingredients': [
          '500g Chicken',
          '2 Onions',
          '3 Tomatoes',
          '4 Cloves of Garlic',
          'Spices (Curry Powder, Turmeric, Cumin)',
          'Salt and Pepper',
        ],
        'steps': [
          'Chop the onions, tomatoes, and garlic.',
          'Heat oil in a pan and sauté the onions and garlic.',
          'Add the chicken and cook until browned.',
          'Add the tomatoes and spices, then simmer for 20 minutes.',
          'Season with salt and pepper. Serve hot.',
        ],
      },
    ];

    final int crossAxisCount = selectedFontSize > 30 ? 1 : 2;

    return Scaffold(
      appBar: AppBar(
        title: Text('Explore Recipes', style: TextStyle(color: textColor)),
        backgroundColor: primaryColor,
      ),
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.7,
          ),
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              color: secondaryColor,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeDetailScreen(
                        recipeTitle: recipes[index]['title'],
                        ingredients: recipes[index]['ingredients'],
                        steps: recipes[index]['steps'],
                        primaryColor: primaryColor,
                        backgroundColor: backgroundColor,
                        textColor: textColor,
                        accentColor: accentColor,
                        selectedFontSize: selectedFontSize,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 120,
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
                      Flexible(
                        child: Text(
                          recipes[index]['title']!,
                          style: TextStyle(
                            fontSize:
                                selectedFontSize > 24 ? 24 : selectedFontSize,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Expanded(
                        child: Text(
                          recipes[index]['description']!,
                          style: TextStyle(
                            fontSize: selectedFontSize * 0.8,
                            color: textColor.withOpacity(0.7),
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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
