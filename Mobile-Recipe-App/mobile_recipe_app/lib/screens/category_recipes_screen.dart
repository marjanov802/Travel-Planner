import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'recipe_detail_screen.dart';

class CategoryRecipesScreen extends StatefulWidget {
  final String categoryName;
  final IconData categoryIcon;
  final Color primaryColor;
  final Color accentColor;
  final Color backgroundColor;
  final Color textColor;
  final double selectedFontSize;

  const CategoryRecipesScreen({
    super.key,
    required this.categoryName,
    required this.categoryIcon,
    required this.primaryColor,
    required this.accentColor,
    required this.backgroundColor,
    required this.textColor,
    required this.selectedFontSize,
  });

  @override
  _CategoryRecipesScreenState createState() => _CategoryRecipesScreenState();
}

class _CategoryRecipesScreenState extends State<CategoryRecipesScreen> {
  late List<Map<String, dynamic>> _recipes;
  bool _accessibilityMode = false;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  void _loadRecipes() {
    setState(() {
      _recipes = _getMockRecipes();
    });
  }

  List<Map<String, dynamic>> _getMockRecipes() {
    switch (widget.categoryName) {
      case 'Breakfast':
        return [
          {
            'title': 'Easy Pancakes',
            'image': 'assets/pancakes.jpg',
            'chef': 'Chef Maria',
            'time': '15 min',
            'rating': 4.8,
            'difficulty': 'Easy',
            'ingredients': [
              '1 cup flour',
              '2 eggs',
              '1 cup milk',
              '2 tbsp sugar',
            ],
            'steps': [
              'Mix all ingredients in a bowl',
              'Heat pan with butter',
              'Pour batter and cook until bubbles form',
              'Flip and cook other side',
              'Serve with maple syrup'
            ],
          },
          {
            'title': 'Avocado Toast',
            'image': 'assets/pancakes.jpg',
            'chef': 'Healthy Cook',
            'time': '10 min',
            'rating': 4.5,
            'difficulty': 'Easy',
            'ingredients': [
              '2 slices bread',
              '1 ripe avocado',
              'Salt and pepper',
              'Red pepper flakes',
              'Olive oil'
            ],
            'steps': [
              'Toast bread until golden',
              'Mash avocado in a bowl',
              'Spread avocado on toast',
              'Season with salt, pepper, and red pepper flakes',
              'Drizzle with olive oil'
            ],
          },
          {
            'title': 'Veggie Omelette',
            'image': 'assets/pancakes.jpg',
            'chef': 'Chef John',
            'time': '12 min',
            'rating': 4.7,
            'difficulty': 'Medium',
            'ingredients': [
              '3 eggs',
              'Bell peppers, diced',
              'Onions, diced',
              'Spinach',
              'Salt and pepper',
              'Cheese (optional)',
            ],
            'steps': [
              'Whisk eggs in a bowl',
              'Sauté vegetables until soft',
              'Pour eggs over vegetables',
              'Cook until set on bottom',
              'Fold omelette in half',
              'Serve hot with toast',
            ],
          },
          {
            'title': 'Overnight Oats',
            'image': 'assets/pancakes.jpg',
            'chef': 'Healthy Cook',
            'time': '5 min + overnight',
            'rating': 4.6,
            'difficulty': 'Easy',
            'ingredients': [
              '1/2 cup rolled oats',
              '1/2 cup milk or yogurt',
              '1 tbsp chia seeds',
              'Honey or maple syrup',
              'Fruits for topping',
            ],
            'steps': [
              'Mix oats, milk, and chia seeds',
              'Add sweetener to taste',
              'Refrigerate overnight',
              'Top with fresh fruits before serving',
              'Enjoy cold or warm',
            ],
          },
        ];
      case 'Lunch':
        return [
          {
            'title': 'Quick Pasta',
            'image': 'assets/pancakes.jpg',
            'chef': 'Chef John',
            'time': '20 min',
            'rating': 4.6,
            'difficulty': 'Medium',
            'ingredients': [
              '200g pasta',
              '1 can tomato sauce',
              '1 garlic clove',
              'Basil leaves',
            ],
            'steps': [
              'Boil pasta in salted water',
              'Sauté minced garlic in olive oil',
              'Add tomato sauce and simmer',
              'Drain pasta and mix with sauce',
              'Garnish with fresh basil'
            ],
          },
          {
            'title': 'Chicken Sandwich',
            'image': 'assets/pancakes.jpg',
            'chef': 'Chef Maria',
            'time': '15 min',
            'rating': 4.5,
            'difficulty': 'Easy',
            'ingredients': [
              '2 slices bread',
              '1 chicken breast, cooked',
              'Lettuce',
              'Tomato',
              'Mayonnaise',
            ],
            'steps': [
              'Slice chicken breast',
              'Toast bread lightly',
              'Spread mayonnaise on bread',
              'Layer chicken, lettuce, and tomato',
              'Cut sandwich and serve'
            ],
          },
          {
            'title': 'Greek Salad',
            'image': 'assets/pancakes.jpg',
            'chef': 'Healthy Cook',
            'time': '15 min',
            'rating': 4.7,
            'difficulty': 'Easy',
            'ingredients': [
              'Cucumber',
              'Tomatoes',
              'Red onion',
              'Feta cheese',
              'Olives',
              'Olive oil and lemon dressing',
            ],
            'steps': [
              'Chop vegetables into bite-sized pieces',
              'Add crumbled feta and olives',
              'Mix olive oil, lemon juice, and herbs for dressing',
              'Drizzle dressing over salad',
              'Toss gently and serve',
            ],
          },
          {
            'title': 'Vegetable Wrap',
            'image': 'assets/pancakes.jpg',
            'chef': 'Chef Maria',
            'time': '10 min',
            'rating': 4.5,
            'difficulty': 'Easy',
            'ingredients': [
              'Tortilla wraps',
              'Hummus',
              'Mixed vegetables',
              'Avocado',
              'Sprouts',
            ],
            'steps': [
              'Spread hummus on tortilla',
              'Layer vegetables and avocado',
              'Add sprouts on top',
              'Roll tightly',
              'Cut in half and serve',
            ],
          },
        ];
      case 'Dinner':
        return [
          {
            'title': 'Vegetable Curry',
            'image': 'assets/pancakes.jpg',
            'chef': 'Chef John',
            'time': '30 min',
            'rating': 4.9,
            'difficulty': 'Medium',
            'ingredients': [
              'Mixed vegetables',
              'Curry paste',
              'Coconut milk',
              'Rice',
            ],
            'steps': [
              'Sauté vegetables until tender',
              'Add curry paste and stir',
              'Pour in coconut milk',
              'Simmer until thickened',
              'Serve with rice'
            ],
          },
          {
            'title': 'Mushroom Risotto',
            'image': 'assets/pancakes.jpg',
            'chef': 'Chef Maria',
            'time': '35 min',
            'rating': 4.8,
            'difficulty': 'Medium',
            'ingredients': [
              'Arborio rice',
              'Mushrooms',
              'Onion',
              'Vegetable broth',
              'White wine',
              'Parmesan cheese',
            ],
            'steps': [
              'Sauté onions until translucent',
              'Add mushrooms and cook until soft',
              'Add rice and toast for 2 minutes',
              'Pour in wine and stir until absorbed',
              'Add broth gradually, stirring often',
              'Finish with parmesan cheese',
            ],
          },
          {
            'title': 'Baked Salmon',
            'image': 'assets/pancakes.jpg',
            'chef': 'Chef John',
            'time': '25 min',
            'rating': 4.9,
            'difficulty': 'Medium',
            'ingredients': [
              'Salmon fillets',
              'Lemon',
              'Olive oil',
              'Garlic',
              'Dill',
              'Salt and pepper',
            ],
            'steps': [
              'Preheat oven to 375°F',
              'Place salmon on baking sheet',
              'Drizzle with olive oil',
              'Season with garlic, dill, salt, and pepper',
              'Add lemon slices on top',
              'Bake for 15-20 minutes',
            ],
          },
        ];
      case 'Snacks':
        return [
          {
            'title': 'Fruit Parfait',
            'image': 'assets/pancakes.jpg',
            'chef': 'Healthy Cook',
            'time': '10 min',
            'rating': 4.6,
            'difficulty': 'Easy',
            'ingredients': [
              'Greek yogurt',
              'Mixed berries',
              'Granola',
              'Honey',
            ],
            'steps': [
              'Layer yogurt in a glass',
              'Add berries',
              'Sprinkle granola',
              'Drizzle with honey',
              'Repeat layers'
            ],
          },
          {
            'title': 'Hummus & Veggies',
            'image': 'assets/pancakes.jpg',
            'chef': 'Healthy Cook',
            'time': '10 min',
            'rating': 4.5,
            'difficulty': 'Easy',
            'ingredients': [
              'Hummus',
              'Carrot sticks',
              'Cucumber slices',
              'Bell pepper strips',
              'Cherry tomatoes',
            ],
            'steps': [
              'Arrange vegetables on a plate',
              'Serve with hummus in the center',
              'Enjoy as a healthy snack',
            ],
          },
          {
            'title': 'Apple & Peanut Butter',
            'image': 'assets/pancakes.jpg',
            'chef': 'Chef Maria',
            'time': '5 min',
            'rating': 4.7,
            'difficulty': 'Easy',
            'ingredients': [
              'Apple',
              'Peanut butter',
              'Cinnamon (optional)',
            ],
            'steps': [
              'Slice apple into wedges',
              'Spread peanut butter on each slice',
              'Sprinkle with cinnamon if desired',
              'Arrange on plate and serve',
            ],
          },
        ];
      case 'Desserts':
        return [
          {
            'title': 'Chocolate Cookies',
            'image': 'assets/pancakes.jpg',
            'chef': 'Chef Maria',
            'time': '30 min',
            'rating': 4.9,
            'difficulty': 'Medium',
            'ingredients': [
              'Flour',
              'Sugar',
              'Butter',
              'Chocolate chips',
              'Eggs',
            ],
            'steps': [
              'Cream butter and sugar',
              'Add eggs and vanilla',
              'Mix in dry ingredients',
              'Fold in chocolate chips',
              'Bake at 350°F for 10-12 minutes'
            ],
          },
          {
            'title': 'Berry Parfait',
            'image': 'assets/pancakes.jpg',
            'chef': 'Chef John',
            'time': '15 min',
            'rating': 4.8,
            'difficulty': 'Easy',
            'ingredients': [
              'Mixed berries',
              'Greek yogurt',
              'Honey',
              'Granola',
              'Mint leaves for garnish',
            ],
            'steps': [
              'Layer yogurt in a glass',
              'Add berries on top',
              'Drizzle with honey',
              'Sprinkle with granola',
              'Garnish with mint leaves',
            ],
          },
          {
            'title': 'Easy Brownies',
            'image': 'assets/pancakes.jpg',
            'chef': 'Chef Maria',
            'time': '40 min',
            'rating': 4.9,
            'difficulty': 'Medium',
            'ingredients': [
              'Butter',
              'Sugar',
              'Eggs',
              'Vanilla extract',
              'Flour',
              'Cocoa powder',
              'Chocolate chips',
            ],
            'steps': [
              'Preheat oven to 350°F',
              'Mix butter and sugar',
              'Add eggs and vanilla',
              'Stir in dry ingredients',
              'Fold in chocolate chips',
              'Bake for 25-30 minutes',
            ],
          },
        ];
      default:
        return [
          {
            'title': 'Easy Recipe',
            'image': 'assets/pancakes.jpg',
            'chef': 'Chef Cook',
            'time': '20 min',
            'rating': 4.5,
            'difficulty': 'Easy',
            'ingredients': [
              'Ingredient 1',
              'Ingredient 2',
              'Ingredient 3',
              'Ingredient 4',
            ],
            'steps': ['Step 1', 'Step 2', 'Step 3', 'Step 4', 'Step 5'],
          },
        ];
    }
  }

  bool get isExtremelyLargeFont =>
      widget.selectedFontSize >= 42.0 || _accessibilityMode;
  bool get isLargeFont => widget.selectedFontSize >= 36.0 || _accessibilityMode;
  bool get isSmallFont =>
      widget.selectedFontSize <= 18.0 && !_accessibilityMode;

  double _getScaledSize(double factor) {
    return _accessibilityMode
        ? widget.selectedFontSize * factor * 1.5
        : widget.selectedFontSize * factor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(widget.categoryIcon,
                color: Colors.white, size: _accessibilityMode ? 32 : 24),
            SizedBox(width: 12),
            Text(
              widget.categoryName,
              style: TextStyle(
                fontSize: _accessibilityMode ? 28 : (isLargeFont ? 24 : 20),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: widget.primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.white, size: _accessibilityMode ? 32 : 24),
          onPressed: () {
            HapticFeedback.mediumImpact();
            Navigator.pop(context);
          },
          tooltip: 'Back to Discover',
          padding: EdgeInsets.all(12),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.accessibility_new,
              color: Colors.white,
              size: _accessibilityMode ? 32 : 24,
            ),
            onPressed: () {
              HapticFeedback.mediumImpact();
              setState(() {
                _accessibilityMode = !_accessibilityMode;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _accessibilityMode
                        ? 'Accessibility mode enabled: Larger text and buttons'
                        : 'Standard viewing mode enabled',
                    style: TextStyle(fontSize: _accessibilityMode ? 18 : 16),
                  ),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Toggle Accessibility Mode',
            padding: EdgeInsets.all(12),
          ),
        ],
        elevation: 8,
      ),
      body: Container(
        color: widget.backgroundColor,
        child: Column(
          children: [
            // Category header
            Container(
              padding: EdgeInsets.all(_accessibilityMode ? 24 : 16),
              color: widget.primaryColor.withOpacity(0.2),
              child: Column(
                children: [
                  Text(
                    'Discover ${widget.categoryName} Recipes',
                    style: TextStyle(
                      fontSize: _accessibilityMode
                          ? 32
                          : (isLargeFont ? 28 : _getScaledSize(1.2)),
                      fontWeight: FontWeight.bold,
                      color: widget.textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: _accessibilityMode ? 16 : 8),
                  Text(
                    _getCategoryDescription(widget.categoryName),
                    style: TextStyle(
                      fontSize: _accessibilityMode
                          ? 24
                          : (isLargeFont ? 20 : _getScaledSize(0.9)),
                      color: widget.textColor,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Recipe count indicator
            Container(
              padding: EdgeInsets.all(_accessibilityMode ? 20 : 16),
              color: widget.accentColor.withOpacity(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restaurant,
                    color: widget.accentColor,
                    size: _accessibilityMode ? 32 : (isLargeFont ? 28 : 24),
                  ),
                  SizedBox(width: _accessibilityMode ? 12 : 8),
                  Text(
                    '${_recipes.length} Recipes Found',
                    style: TextStyle(
                      fontSize: _accessibilityMode
                          ? 26
                          : (isLargeFont ? 22 : _getScaledSize(0.9)),
                      fontWeight: FontWeight.bold,
                      color: widget.textColor,
                    ),
                  ),
                ],
              ),
            ),

            // Recipe list
            Expanded(
              child: _recipes.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.all(_accessibilityMode ? 20 : 16),
                      itemCount: _recipes.length,
                      itemBuilder: (context, index) {
                        return Semantics(
                          label: 'Recipe for ${_recipes[index]['title']}',
                          hint: 'Tap to view recipe details',
                          child: _buildAccessibleRecipeCard(_recipes[index]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      // Floating back button
      floatingActionButton: _accessibilityMode
          ? FloatingActionButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                Navigator.pop(context);
              },
              backgroundColor: widget.primaryColor,
              foregroundColor: Colors.white,
              tooltip: 'Return to Categories',
              child: Icon(Icons.arrow_back, size: 32),
            )
          : null,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: _accessibilityMode ? 100 : (isLargeFont ? 80 : 60),
            color: widget.primaryColor.withOpacity(0.5),
          ),
          SizedBox(height: _accessibilityMode ? 24 : 16),
          Text(
            'No recipes found',
            style: TextStyle(
              fontSize: _accessibilityMode
                  ? 36
                  : (isLargeFont ? 28 : _getScaledSize(1.1)),
              fontWeight: FontWeight.bold,
              color: widget.textColor,
            ),
          ),
          SizedBox(height: _accessibilityMode ? 16 : 8),
          Text(
            'Try a different category',
            style: TextStyle(
              fontSize: _accessibilityMode
                  ? 28
                  : (isLargeFont ? 20 : _getScaledSize(0.9)),
              color: widget.textColor.withOpacity(0.7),
            ),
          ),
          SizedBox(height: _accessibilityMode ? 32 : 24),
          ElevatedButton.icon(
            onPressed: () {
              HapticFeedback.mediumImpact();
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, size: _accessibilityMode ? 28 : 24),
            label: Text(
              'Return to Categories',
              style: TextStyle(
                fontSize: _accessibilityMode ? 24 : _getScaledSize(1.0),
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.primaryColor,
              padding: EdgeInsets.symmetric(
                vertical: _accessibilityMode ? 16 : 12,
                horizontal: _accessibilityMode ? 24 : 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(_accessibilityMode ? 20 : 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryDescription(String category) {
    switch (category) {
      case 'Breakfast':
        return 'Start your day with these delicious breakfast recipes';
      case 'Lunch':
        return 'Quick and satisfying midday meal ideas';
      case 'Dinner':
        return 'Hearty and delicious evening meal recipes';
      case 'Snacks':
        return 'Tasty bites for anytime hunger';
      case 'Desserts':
        return 'Sweet treats to end your meal perfectly';
      default:
        return 'Explore our collection of delicious recipes';
    }
  }

  Widget _buildAccessibleRecipeCard(Map<String, dynamic> recipe) {
    final double borderWidth = _accessibilityMode ? 4 : (isLargeFont ? 3 : 2);

    return Card(
      margin: EdgeInsets.only(
          bottom: _accessibilityMode ? 32 : (isLargeFont ? 20 : 12)),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_accessibilityMode ? 20 : 16),
        side: BorderSide(
          color: widget.primaryColor,
          width: borderWidth,
        ),
      ),
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailScreen(
                recipeTitle: recipe['title'],
                ingredients: recipe['ingredients'],
                steps: recipe['steps'],
                primaryColor: widget.primaryColor,
                accentColor: widget.accentColor,
                backgroundColor: widget.backgroundColor,
                textColor: widget.textColor,
                selectedFontSize: _accessibilityMode
                    ? widget.selectedFontSize * 1.5
                    : widget.selectedFontSize,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(_accessibilityMode ? 20 : 16),
        splashColor: widget.accentColor.withOpacity(0.3),
        highlightColor: widget.accentColor.withOpacity(0.2),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_accessibilityMode ? 20 : 16),
            color: widget.backgroundColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Recipe title banner
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: _accessibilityMode ? 24 : (isLargeFont ? 16 : 12),
                  horizontal: _accessibilityMode ? 24 : 16,
                ),
                decoration: BoxDecoration(
                  color: widget.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(_accessibilityMode ? 20 : 16),
                    topRight: Radius.circular(_accessibilityMode ? 20 : 16),
                  ),
                ),
                child: Text(
                  recipe['title'],
                  style: TextStyle(
                    fontSize: _accessibilityMode
                        ? 36
                        : (isExtremelyLargeFont
                            ? 32
                            : (isLargeFont ? 28 : _getScaledSize(1.1))),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Recipe image
              if (!isExtremelyLargeFont && !_accessibilityMode)
                Container(
                  margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  height: isLargeFont ? 180 : 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: widget.primaryColor,
                      width: borderWidth,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      recipe['image'],
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              Padding(
                padding: EdgeInsets.all(_accessibilityMode ? 24 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Chef and tim e information
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(_accessibilityMode
                                ? 20
                                : (isLargeFont ? 12 : 8)),
                            decoration: BoxDecoration(
                              color: widget.primaryColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(
                                  _accessibilityMode ? 16 : 12),
                              border: Border.all(
                                color: widget.primaryColor.withOpacity(0.5),
                                width: borderWidth,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: widget.primaryColor,
                                  size: _accessibilityMode
                                      ? 36
                                      : (isLargeFont ? 28 : 24),
                                ),
                                SizedBox(height: _accessibilityMode ? 8 : 4),
                                Text(
                                  recipe['chef'],
                                  style: TextStyle(
                                    fontSize: _accessibilityMode
                                        ? 26
                                        : (isLargeFont
                                            ? 20
                                            : _getScaledSize(0.9)),
                                    fontWeight: FontWeight.bold,
                                    color: widget.textColor,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: _accessibilityMode ? 20 : 12),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(_accessibilityMode
                                ? 20
                                : (isLargeFont ? 12 : 8)),
                            decoration: BoxDecoration(
                              color: widget.primaryColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(
                                  _accessibilityMode ? 16 : 12),
                              border: Border.all(
                                color: widget.primaryColor.withOpacity(0.5),
                                width: borderWidth,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.timer,
                                  color: widget.primaryColor,
                                  size: _accessibilityMode
                                      ? 36
                                      : (isLargeFont ? 28 : 24),
                                ),
                                SizedBox(height: _accessibilityMode ? 8 : 4),
                                Text(
                                  recipe['time'],
                                  style: TextStyle(
                                    fontSize: _accessibilityMode
                                        ? 26
                                        : (isLargeFont
                                            ? 20
                                            : _getScaledSize(0.9)),
                                    fontWeight: FontWeight.bold,
                                    color: widget.textColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                        height:
                            _accessibilityMode ? 24 : (isLargeFont ? 16 : 12)),

                    // Difficulty indicator
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical:
                            _accessibilityMode ? 20 : (isLargeFont ? 12 : 8),
                        horizontal: _accessibilityMode ? 24 : 16,
                      ),
                      decoration: BoxDecoration(
                        color: widget.primaryColor.withOpacity(0.15),
                        borderRadius:
                            BorderRadius.circular(_accessibilityMode ? 16 : 12),
                        border: Border.all(
                          color: widget.primaryColor.withOpacity(0.5),
                          width: borderWidth,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Difficulty: ",
                            style: TextStyle(
                              fontSize: _accessibilityMode
                                  ? 26
                                  : (isLargeFont ? 20 : _getScaledSize(0.9)),
                              color: widget.textColor,
                            ),
                          ),
                          Text(
                            recipe['difficulty'],
                            style: TextStyle(
                              fontSize: _accessibilityMode
                                  ? 26
                                  : (isLargeFont ? 20 : _getScaledSize(0.9)),
                              fontWeight: FontWeight.bold,
                              color: widget.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // View Recipe button
              Container(
                margin: EdgeInsets.fromLTRB(_accessibilityMode ? 24 : 16, 0,
                    _accessibilityMode ? 24 : 16, _accessibilityMode ? 24 : 16),
                width: double.infinity,
                height: _accessibilityMode
                    ? 80
                    : (isExtremelyLargeFont ? 70 : (isLargeFont ? 60 : 50)),
                child: ElevatedButton.icon(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailScreen(
                          recipeTitle: recipe['title'],
                          ingredients: recipe['ingredients'],
                          steps: recipe['steps'],
                          primaryColor: widget.primaryColor,
                          accentColor: widget.accentColor,
                          backgroundColor: widget.backgroundColor,
                          textColor: widget.textColor,
                          selectedFontSize: _accessibilityMode
                              ? widget.selectedFontSize * 1.5
                              : widget.selectedFontSize,
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.menu_book,
                    size: _accessibilityMode ? 36 : (isLargeFont ? 28 : 24),
                    color: Colors.white,
                  ),
                  label: Text(
                    'View Recipe',
                    style: TextStyle(
                      fontSize: _accessibilityMode
                          ? 32
                          : (isLargeFont ? 24 : _getScaledSize(1.0)),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(_accessibilityMode ? 32 : 25),
                    ),
                    elevation: 6,
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
