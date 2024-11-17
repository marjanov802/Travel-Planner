import 'package:flutter/material.dart';

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
    final List<Map<String, String>> recipes = [
      {
        'title': 'Spaghetti Carbonara',
        'description':
            'Classic Italian pasta with eggs, cheese, pancetta, and pepper.'
      },
      {
        'title': 'Chicken Curry',
        'description': 'A flavorful and spicy curry with tender chicken pieces.'
      },
      {
        'title': 'Vegan Tacos',
        'description': 'Plant-based tacos filled with fresh veggies and beans.'
      },
      {
        'title': 'Beef Stew',
        'description':
            'A hearty stew made with tender beef chunks and vegetables.'
      },
      {
        'title': 'Pancakes',
        'description': 'Fluffy pancakes perfect for a sweet breakfast treat.'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Explore Recipes', style: TextStyle(color: textColor)),
        backgroundColor: primaryColor,
      ),
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.8,
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Clicked on ${recipes[index]['title']}'),
                      backgroundColor: accentColor,
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
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: accentColor.withOpacity(0.3),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.fastfood,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
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
                      const SizedBox(height: 4),
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
