import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'recipe_detail_screen.dart';

class DietaryRecipesScreen extends StatefulWidget {
  final String dietaryType;
  final IconData dietaryIcon;
  final Color primaryColor;
  final Color accentColor;
  final Color backgroundColor;
  final Color textColor;
  final double selectedFontSize;

  const DietaryRecipesScreen({
    super.key,
    required this.dietaryType,
    required this.dietaryIcon,
    required this.primaryColor,
    required this.accentColor,
    required this.backgroundColor,
    required this.textColor,
    required this.selectedFontSize,
  });

  @override
  _DietaryRecipesScreenState createState() => _DietaryRecipesScreenState();
}

class _DietaryRecipesScreenState extends State<DietaryRecipesScreen> {
  late List<Map<String, dynamic>> _recipes;
  bool _isFilteredByDifficulty = false;
  String _selectedDifficulty = 'All';
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
    switch (widget.dietaryType) {
      case 'Vegetarian':
        return [
          {
            'title': 'Vegetable Stir Fry',
            'image': 'assets/vegetable stir fry.jpg',
            'chef': 'Healthy Cook',
            'time': '20 min',
            'rating': 4.7,
            'difficulty': 'Easy',
            'ingredients': [
              'Mixed vegetables',
              'Tofu',
              'Soy sauce',
              'Rice',
            ],
            'steps': [
              'Cut vegetables and tofu',
              'Heat oil in wok',
              'Stir fry vegetables and tofu',
              'Add soy sauce',
              'Serve with rice'
            ],
          },
          {
            'title': 'Mushroom Risotto',
            'image': 'assets/mushroom risotto.jpg',
            'chef': 'Chef Maria',
            'time': '35 min',
            'rating': 4.8,
            'difficulty': 'Medium',
            'ingredients': [
              'Arborio rice',
              'Mushrooms',
              'Vegetable broth',
              'Parmesan cheese',
              'White wine',
            ],
            'steps': [
              'Sauté mushrooms',
              'Toast rice in oil',
              'Add wine and reduce',
              'Gradually add broth, stirring constantly',
              'Finish with parmesan cheese'
            ],
          },
          {
            'title': 'Vegetable Lasagna',
            'image': 'assets/lasanga.jpg',
            'chef': 'Chef John',
            'time': '50 min',
            'rating': 4.9,
            'difficulty': 'Medium',
            'ingredients': [
              'Lasagna noodles',
              'Zucchini',
              'Spinach',
              'Ricotta cheese',
              'Tomato sauce',
              'Mozzarella cheese',
            ],
            'steps': [
              'Layer sauce, noodles, and vegetables',
              'Add ricotta cheese mixture between layers',
              'Top with mozzarella cheese',
              'Bake until bubbly and golden',
              'Let rest before serving',
            ],
          },
          {
            'title': 'Caprese Salad',
            'image': 'assets/greek salad.jpg',
            'chef': 'Chef Maria',
            'time': '10 min',
            'rating': 4.7,
            'difficulty': 'Easy',
            'ingredients': [
              'Tomatoes',
              'Fresh mozzarella',
              'Basil leaves',
              'Olive oil',
              'Balsamic glaze',
              'Salt and pepper',
            ],
            'steps': [
              'Slice tomatoes and mozzarella',
              'Arrange alternating on plate with basil',
              'Drizzle with olive oil and balsamic',
              'Season with salt and pepper',
              'Serve immediately',
            ],
          },
          {
            'title': 'Spinach and Feta Pie',
            'image': 'assets/spinach and feta pie.jpg',
            'chef': 'Chef Anna',
            'time': '45 min',
            'rating': 4.6,
            'difficulty': 'Medium',
            'ingredients': [
              'Phyllo dough',
              'Spinach',
              'Feta cheese',
              'Eggs',
              'Onions',
              'Olive oil',
            ],
            'steps': [
              'Sauté onions until translucent',
              'Add spinach and cook until wilted',
              'Mix with crumbled feta and eggs',
              'Layer phyllo sheets, brushing with oil',
              'Add filling and fold over phyllo',
              'Bake until golden brown',
            ],
          },
          {
            'title': 'Eggplant Parmesan',
            'image': 'assets/eggplant parmesan.jpg',
            'chef': 'Chef Mario',
            'time': '60 min',
            'rating': 4.8,
            'difficulty': 'Hard',
            'ingredients': [
              'Eggplant',
              'Breadcrumbs',
              'Eggs',
              'Marinara sauce',
              'Mozzarella cheese',
              'Parmesan cheese',
              'Basil',
            ],
            'steps': [
              'Slice eggplant and salt to remove bitterness',
              'Dip in egg then breadcrumbs',
              'Fry until golden brown',
              'Layer with marinara and cheeses',
              'Bake until bubbly and cheese is melted',
              'Garnish with fresh basil',
            ],
          },
          {
            'title': 'Stuffed Bell Peppers',
            'image': 'assets/download.jpg',
            'chef': 'Chef Thomas',
            'time': '40 min',
            'rating': 4.5,
            'difficulty': 'Medium',
            'ingredients': [
              'Bell peppers',
              'Rice',
              'Black beans',
              'Corn',
              'Cheese',
              'Spices',
            ],
            'steps': [
              'Cut tops off peppers and remove seeds',
              'Cook rice according to package',
              'Mix rice with beans, corn, and spices',
              'Stuff mixture into peppers',
              'Top with cheese',
              'Bake until peppers are tender',
            ],
          },
          {
            'title': 'Vegetable Pot Pie',
            'image': 'assets/vegetable pot pie.jpg',
            'chef': 'Chef Sarah',
            'time': '55 min',
            'rating': 4.7,
            'difficulty': 'Hard',
            'ingredients': [
              'Pie crust',
              'Mixed vegetables',
              'Vegetable broth',
              'Flour',
              'Butter',
              'Milk',
              'Herbs',
            ],
            'steps': [
              'Prepare pie crust',
              'Make vegetable filling with roux',
              'Line pie dish with bottom crust',
              'Add filling',
              'Top with second crust and crimp edges',
              'Cut steam vents and bake until golden',
            ],
          },
        ];
      case 'Vegan':
        return [
          {
            'title': 'Vegan Buddha Bowl',
            'image': 'assets/greek salad.jpg',
            'chef': 'Healthy Cook',
            'time': '25 min',
            'rating': 4.8,
            'difficulty': 'Medium',
            'ingredients': [
              'Quinoa',
              'Roasted vegetables',
              'Avocado',
              'Tahini sauce',
            ],
            'steps': [
              'Cook quinoa',
              'Roast vegetables',
              'Arrange in bowl',
              'Add sliced avocado',
              'Drizzle with tahini sauce'
            ],
          },
          {
            'title': 'Chickpea Curry',
            'image': 'assets/vegetable curry.jpg',
            'chef': 'Chef John',
            'time': '30 min',
            'rating': 4.7,
            'difficulty': 'Medium',
            'ingredients': [
              'Chickpeas',
              'Coconut milk',
              'Curry powder',
              'Onion and garlic',
              'Rice',
            ],
            'steps': [
              'Sauté onions and garlic',
              'Add curry powder and toast',
              'Add chickpeas and coconut milk',
              'Simmer until thickened',
              'Serve with rice',
            ],
          },
          {
            'title': 'Vegan Chocolate Cake',
            'image': 'assets/chocolate cake.jpg',
            'chef': 'Chef Maria',
            'time': '45 min',
            'rating': 4.9,
            'difficulty': 'Hard',
            'ingredients': [
              'Flour',
              'Sugar',
              'Cocoa powder',
              'Vegetable oil',
              'Vanilla extract',
              'Apple cider vinegar',
            ],
            'steps': [
              'Mix dry ingredients',
              'Add wet ingredients and mix well',
              'Pour into cake pan',
              'Bake until toothpick comes out clean',
              'Cool before frosting',
            ],
          },
          {
            'title': 'Lentil Shepherd\'s Pie',
            'image': 'assets/shepards pie.jpg',
            'chef': 'Chef Michael',
            'time': '50 min',
            'rating': 4.6,
            'difficulty': 'Medium',
            'ingredients': [
              'Lentils',
              'Carrots',
              'Onions',
              'Garlic',
              'Potatoes',
              'Plant milk',
              'Vegan butter',
            ],
            'steps': [
              'Cook lentils until tender',
              'Sauté vegetables with herbs',
              'Mix lentils with vegetable mixture',
              'Boil and mash potatoes with plant milk and vegan butter',
              'Layer lentil mixture in dish and top with mashed potatoes',
              'Bake until golden on top',
            ],
          },
          {
            'title': 'Vegan Stir-fried Noodles',
            'image': 'assets/vegetable stir fry.jpg',
            'chef': 'Chef Lin',
            'time': '20 min',
            'rating': 4.7,
            'difficulty': 'Easy',
            'ingredients': [
              'Rice noodles',
              'Tofu',
              'Bell peppers',
              'Carrots',
              'Snow peas',
              'Soy sauce',
              'Sesame oil',
            ],
            'steps': [
              'Soak rice noodles in hot water',
              'Press and cube tofu',
              'Stir-fry tofu until golden',
              'Add vegetables and cook until tender-crisp',
              'Add drained noodles and sauce',
              'Toss until well combined and heated through',
            ],
          },
          {
            'title': 'Stuffed Baked Sweet Potatoes',
            'image': 'assets/baked potatoes.jpg',
            'chef': 'Chef Emma',
            'time': '40 min',
            'rating': 4.5,
            'difficulty': 'Easy',
            'ingredients': [
              'Sweet potatoes',
              'Black beans',
              'Corn',
              'Avocado',
              'Lime juice',
              'Cilantro',
              'Spices',
            ],
            'steps': [
              'Bake sweet potatoes until tender',
              'Mix beans, corn, and spices',
              'Slice open potatoes and fluff flesh',
              'Top with bean mixture',
              'Add diced avocado',
              'Sprinkle with cilantro and lime juice',
            ],
          },
          {
            'title': 'Mushroom Risotto (Vegan)',
            'image': 'assets/mushroom risotto.jpg',
            'chef': 'Chef Sophia',
            'time': '35 min',
            'rating': 4.8,
            'difficulty': 'Medium',
            'ingredients': [
              'Arborio rice',
              'Mushrooms',
              'Vegetable broth',
              'Nutritional yeast',
              'White wine',
              'Onion',
              'Garlic',
            ],
            'steps': [
              'Sauté onions and garlic',
              'Add mushrooms and cook until golden',
              'Toast rice briefly',
              'Add wine and simmer until absorbed',
              'Gradually add broth, stirring constantly',
              'Finish with nutritional yeast for cheesy flavor',
            ],
          },
        ];
      case 'Gluten-Free':
        return [
          {
            'title': 'Gluten-Free Pancakes',
            'image': 'assets/pancakes.jpg',
            'chef': 'Healthy Cook',
            'time': '20 min',
            'rating': 4.6,
            'difficulty': 'Medium',
            'ingredients': [
              'Gluten-free flour',
              'Eggs',
              'Milk',
              'Baking powder',
            ],
            'steps': [
              'Mix dry ingredients',
              'Whisk eggs and milk',
              'Combine wet and dry ingredients',
              'Cook on griddle',
              'Serve with maple syrup'
            ],
          },
          {
            'title': 'Quinoa Salad',
            'image': 'assets/quinoa salad.jpg',
            'chef': 'Chef Maria',
            'time': '25 min',
            'rating': 4.7,
            'difficulty': 'Easy',
            'ingredients': [
              'Quinoa',
              'Bell peppers',
              'Cucumber',
              'Feta cheese',
              'Lemon dressing',
            ],
            'steps': [
              'Cook quinoa and cool',
              'Dice vegetables',
              'Mix quinoa with vegetables',
              'Add feta cheese',
              'Toss with lemon dressing',
            ],
          },
          {
            'title': 'Baked Salmon with Rice',
            'image': 'assets/baked salmon with rice.jpg',
            'chef': 'Chef Gordon',
            'time': '30 min',
            'rating': 4.9,
            'difficulty': 'Medium',
            'ingredients': [
              'Salmon fillets',
              'Rice',
              'Lemon',
              'Dill',
              'Olive oil',
              'Garlic',
            ],
            'steps': [
              'Cook rice according to package',
              'Season salmon with salt, pepper, and dill',
              'Sear in hot pan, skin side down',
              'Finish in oven until cooked through',
              'Serve over rice with lemon wedges',
            ],
          },
          {
            'title': 'Gluten-Free Pasta Primavera',
            'image': 'assets/pasta.jpg',
            'chef': 'Chef Isabella',
            'time': '25 min',
            'rating': 4.6,
            'difficulty': 'Easy',
            'ingredients': [
              'Gluten-free pasta',
              'Mixed vegetables',
              'Olive oil',
              'Garlic',
              'Parmesan cheese',
              'Fresh herbs',
            ],
            'steps': [
              'Cook pasta according to package',
              'Sauté vegetables until tender-crisp',
              'Toss pasta with vegetables',
              'Add olive oil and garlic',
              'Sprinkle with cheese and herbs',
            ],
          },
          {
            'title': 'Flourless Chocolate Cake',
            'image': 'assets/chocolate cake.jpg',
            'chef': 'Chef David',
            'time': '50 min',
            'rating': 4.9,
            'difficulty': 'Hard',
            'ingredients': [
              'Dark chocolate',
              'Butter',
              'Eggs',
              'Sugar',
              'Cocoa powder',
              'Vanilla extract',
            ],
            'steps': [
              'Melt chocolate and butter together',
              'Whisk eggs and sugar until pale and fluffy',
              'Fold chocolate mixture into egg mixture',
              'Add cocoa powder and vanilla',
              'Bake until set around edges but slightly soft in center',
              'Cool before serving',
            ],
          },
          {
            'title': 'Sweet Potato Hash',
            'image': 'assets/sweet potato hash.jpg',
            'chef': 'Chef Olivia',
            'time': '25 min',
            'rating': 4.5,
            'difficulty': 'Easy',
            'ingredients': [
              'Sweet potatoes',
              'Bell peppers',
              'Onions',
              'Eggs',
              'Avocado',
              'Spices',
            ],
            'steps': [
              'Dice sweet potatoes and vegetables',
              'Sauté until tender',
              'Season with spices',
              'Make wells in hash and crack eggs into them',
              'Cover and cook until eggs are set',
              'Top with sliced avocado',
            ],
          },
        ];
      case 'Low-Carb':
        return [
          {
            'title': 'Cauliflower Rice Bowl',
            'image': 'assets/cauliflower rice.jpg',
            'chef': 'Healthy Cook',
            'time': '25 min',
            'rating': 4.7,
            'difficulty': 'Medium',
            'ingredients': [
              'Cauliflower',
              'Grilled chicken',
              'Avocado',
              'Lime',
            ],
            'steps': [
              'Pulse cauliflower in food processor',
              'Sauté cauliflower rice',
              'Season with salt and lime',
              'Top with grilled chicken',
              'Add sliced avocado'
            ],
          },
          {
            'title': 'Zucchini Noodles',
            'image': 'assets/noodles.jpg',
            'chef': 'Chef John',
            'time': '20 min',
            'rating': 4.6,
            'difficulty': 'Easy',
            'ingredients': [
              'Zucchini',
              'Olive oil',
              'Garlic',
              'Cherry tomatoes',
              'Parmesan cheese',
            ],
            'steps': [
              'Spiralize zucchini into noodles',
              'Sauté garlic in olive oil',
              'Add zucchini noodles and cook briefly',
              'Toss with tomatoes',
              'Top with parmesan cheese',
            ],
          },
          {
            'title': 'Bacon and Egg Cups',
            'image': 'assets/bacon and eggs.jpg',
            'chef': 'Chef Robert',
            'time': '25 min',
            'rating': 4.8,
            'difficulty': 'Easy',
            'ingredients': [
              'Eggs',
              'Bacon',
              'Spinach',
              'Cheese',
              'Salt and pepper',
            ],
            'steps': [
              'Line muffin cups with bacon',
              'Add chopped spinach',
              'Crack an egg into each cup',
              'Sprinkle with cheese',
              'Bake until eggs are set',
            ],
          },
          {
            'title': 'Steak with Garlic Butter',
            'image': 'assets/steak with garlic butter.jpg',
            'chef': 'Chef James',
            'time': '20 min',
            'rating': 4.9,
            'difficulty': 'Medium',
            'ingredients': [
              'Steak (ribeye or sirloin)',
              'Butter',
              'Garlic',
              'Rosemary',
              'Thyme',
              'Salt and pepper',
            ],
            'steps': [
              'Season steak generously',
              'Sear in hot pan until browned',
              'Add butter, garlic, and herbs',
              'Baste steak with butter as it cooks',
              'Rest before slicing',
              'Serve with pan sauce',
            ],
          },
          {
            'title': 'Keto Chicken Parmesan',
            'image': 'assets/keto chicken parmesan.jpg',
            'chef': 'Chef Maria',
            'time': '35 min',
            'rating': 4.7,
            'difficulty': 'Medium',
            'ingredients': [
              'Chicken breasts',
              'Almond flour',
              'Parmesan cheese',
              'Eggs',
              'Marinara sauce',
              'Mozzarella cheese',
              'Italian herbs',
            ],
            'steps': [
              'Pound chicken to even thickness',
              'Dip in egg then almond flour/parmesan mixture',
              'Pan-fry until golden and cooked through',
              'Top with marinara and mozzarella',
              'Broil until cheese is bubbly',
              'Sprinkle with fresh herbs',
            ],
          },
          {
            'title': 'Stuffed Bell Peppers (Low-Carb)',
            'image': 'assets/download.jpg',
            'chef': 'Chef Daniel',
            'time': '40 min',
            'rating': 4.6,
            'difficulty': 'Medium',
            'ingredients': [
              'Bell peppers',
              'Ground beef',
              'Cauliflower rice',
              'Onions',
              'Garlic',
              'Cheese',
              'Spices',
            ],
            'steps': [
              'Cut tops off peppers and remove seeds',
              'Brown ground beef with onions and garlic',
              'Mix with cauliflower rice and spices',
              'Stuff mixture into peppers',
              'Top with cheese',
              'Bake until peppers are tender',
            ],
          },
          {
            'title': 'Salmon Avocado Salad',
            'image': 'assets/salmon avocado salad.jpg',
            'chef': 'Chef Lisa',
            'time': '15 min',
            'rating': 4.7,
            'difficulty': 'Easy',
            'ingredients': [
              'Salmon (cooked)',
              'Mixed greens',
              'Avocado',
              'Cucumber',
              'Olive oil',
              'Lemon juice',
              'Dill',
            ],
            'steps': [
              'Arrange greens on plate',
              'Top with flaked salmon',
              'Add sliced avocado and cucumber',
              'Mix olive oil, lemon juice, and dill for dressing',
              'Drizzle over salad',
            ],
          },
        ];
      case 'Diabetic':
        return [
          {
            'title': 'Diabetic-Friendly Oatmeal',
            'image': 'assets/oats.jpg',
            'chef': 'Healthy Cook',
            'time': '15 min',
            'rating': 4.5,
            'difficulty': 'Easy',
            'ingredients': [
              'Steel-cut oats',
              'Cinnamon',
              'Berries',
              'Stevia',
            ],
            'steps': [
              'Cook oats in water',
              'Add cinnamon',
              'Sweeten with stevia if needed',
              'Top with fresh berries',
              'Serve warm'
            ],
          },
          {
            'title': 'Grilled Chicken Salad',
            'image': 'assets/grilled chicken salad.jpg',
            'chef': 'Chef Maria',
            'time': '25 min',
            'rating': 4.7,
            'difficulty': 'Medium',
            'ingredients': [
              'Chicken breast',
              'Mixed greens',
              'Cucumber',
              'Cherry tomatoes',
              'Olive oil dressing',
            ],
            'steps': [
              'Grill seasoned chicken breast',
              'Chop vegetables',
              'Mix greens and vegetables',
              'Slice chicken and place on top',
              'Drizzle with olive oil dressing',
            ],
          },
          {
            'title': 'Turkey and Vegetable Stir-Fry',
            'image': 'assets/vegetable stir fry.jpg',
            'chef': 'Chef Alex',
            'time': '20 min',
            'rating': 4.6,
            'difficulty': 'Medium',
            'ingredients': [
              'Ground turkey',
              'Broccoli',
              'Bell peppers',
              'Carrots',
              'Snow peas',
              'Low-sodium soy sauce',
              'Ginger',
              'Garlic',
            ],
            'steps': [
              'Brown turkey in wok or large pan',
              'Add garlic and ginger',
              'Add vegetables and stir-fry until tender-crisp',
              'Season with small amount of low-sodium soy sauce',
              'Serve over small portion of brown rice or alone',
            ],
          },
          {
            'title': 'Baked Fish with Roasted Vegetables',
            'image': 'assets/baked fish roasted potatoes.jpg',
            'chef': 'Chef Martin',
            'time': '30 min',
            'rating': 4.8,
            'difficulty': 'Medium',
            'ingredients': [
              'White fish (cod or tilapia)',
              'Zucchini',
              'Bell peppers',
              'Cherry tomatoes',
              'Olive oil',
              'Lemon',
              'Herbs',
            ],
            'steps': [
              'Preheat oven and prepare vegetables',
              'Place fish and vegetables on sheet pan',
              'Drizzle with olive oil',
              'Season with herbs, salt, and pepper',
              'Bake until fish is flaky and vegetables are tender',
              'Serve with lemon wedges',
            ],
          },
          {
            'title': 'Lentil Soup',
            'image': 'assets/lentil soup.jpg',
            'chef': 'Chef Sophia',
            'time': '40 min',
            'rating': 4.6,
            'difficulty': 'Easy',
            'ingredients': [
              'Lentils',
              'Carrots',
              'Celery',
              'Onions',
              'Garlic',
              'Low-sodium vegetable broth',
              'Spinach',
              'Herbs',
            ],
            'steps': [
              'Sauté onions, carrots, and celery',
              'Add garlic and cook briefly',
              'Add lentils and broth',
              'Simmer until lentils are tender',
              'Stir in spinach until wilted',
              'Season with herbs and serve',
            ],
          },
          {
            'title': 'Greek Yogurt Parfait',
            'image': 'assets/fruit parfait.jpg',
            'chef': 'Chef Emily',
            'time': '10 min',
            'rating': 4.5,
            'difficulty': 'Easy',
            'ingredients': [
              'Plain Greek yogurt',
              'Berries',
              'Walnuts',
              'Cinnamon',
              'Stevia (optional)',
            ],
            'steps': [
              'Layer yogurt in a glass',
              'Add berries between layers',
              'Sprinkle with crushed walnuts',
              'Add cinnamon',
              'Sweeten lightly with stevia if desired',
            ],
          },
        ];
      default:
        return [
          {
            'title': 'Healthy Recipe',
            'image': 'assets/fruit parfuit.jpg',
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

  List<Map<String, dynamic>> _getFilteredRecipes() {
    if (!_isFilteredByDifficulty || _selectedDifficulty == 'All') {
      return _recipes;
    }
    return _recipes
        .where((recipe) => recipe['difficulty'] == _selectedDifficulty)
        .toList();
  }

  void _filterByDifficulty(String difficulty) {
    setState(() {
      _selectedDifficulty = difficulty;
      _isFilteredByDifficulty = difficulty != 'All';
    });
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
    final filteredRecipes = _getFilteredRecipes();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(widget.dietaryIcon,
                color: Colors.white, size: _accessibilityMode ? 32 : 24),
            SizedBox(width: 12),
            Text(
              widget.dietaryType,
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
            // Dietary header
            Container(
              padding: EdgeInsets.all(_accessibilityMode ? 24 : 16),
              color: widget.primaryColor.withOpacity(0.2),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        widget.dietaryIcon,
                        color: widget.primaryColor,
                        size: _accessibilityMode ? 36 : (isLargeFont ? 32 : 24),
                      ),
                      SizedBox(width: _accessibilityMode ? 12 : 8),
                      Text(
                        widget.dietaryType,
                        style: TextStyle(
                          fontSize: _accessibilityMode
                              ? 32
                              : (isLargeFont ? 28 : _getScaledSize(1.2)),
                          fontWeight: FontWeight.bold,
                          color: widget.textColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: _accessibilityMode ? 16 : 8),
                  Text(
                    _getDietaryDescription(widget.dietaryType),
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

            // Filter section
            if (!isExtremelyLargeFont || _accessibilityMode)
              Container(
                padding: EdgeInsets.all(_accessibilityMode ? 20 : 16),
                color: widget.accentColor.withOpacity(0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filter by Difficulty:',
                      style: TextStyle(
                        fontSize: _accessibilityMode
                            ? 24
                            : (isLargeFont ? 20 : _getScaledSize(0.9)),
                        fontWeight: FontWeight.bold,
                        color: widget.textColor,
                      ),
                    ),
                    SizedBox(height: _accessibilityMode ? 16 : 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('All'),
                          SizedBox(width: _accessibilityMode ? 16 : 8),
                          _buildFilterChip('Easy'),
                          SizedBox(width: _accessibilityMode ? 16 : 8),
                          _buildFilterChip('Medium'),
                          SizedBox(width: _accessibilityMode ? 16 : 8),
                          _buildFilterChip('Hard'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            Container(
              padding: EdgeInsets.all(_accessibilityMode ? 20 : 16),
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
                    '${filteredRecipes.length} ${_selectedDifficulty != "All" ? _selectedDifficulty : ""} Recipes Found',
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
              child: filteredRecipes.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.all(_accessibilityMode ? 20 : 16),
                      itemCount: filteredRecipes.length,
                      itemBuilder: (context, index) {
                        return Semantics(
                          label:
                              'Recipe for ${filteredRecipes[index]['title']}',
                          hint: 'Tap to view recipe details',
                          child: _buildAccessibleRecipeCard(
                              filteredRecipes[index]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      // Floating back button for easier navigation, as per hci
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

  Widget _buildFilterChip(String difficulty) {
    final bool isSelected = _selectedDifficulty == difficulty;
    final double chipHeight = _accessibilityMode ? 56 : (isLargeFont ? 48 : 36);

    return Container(
      height: chipHeight,
      child: FilterChip(
        label: Text(
          difficulty,
          style: TextStyle(
            fontSize: _accessibilityMode
                ? 22
                : (isLargeFont ? 18 : _getScaledSize(0.8)),
            color: isSelected ? Colors.white : widget.textColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        onSelected: (bool selected) {
          HapticFeedback.selectionClick();
          _filterByDifficulty(difficulty);
        },
        backgroundColor: widget.backgroundColor,
        selectedColor: widget.accentColor,
        checkmarkColor: Colors.white,
        padding: EdgeInsets.symmetric(
            horizontal: _accessibilityMode ? 16 : 8,
            vertical: _accessibilityMode ? 12 : 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_accessibilityMode ? 24 : 16),
          side: BorderSide(
            color: isSelected
                ? widget.accentColor
                : widget.primaryColor.withOpacity(0.5),
            width: _accessibilityMode ? 3 : 2,
          ),
        ),
      ),
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
            'Try a different filter',
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
              setState(() {
                _selectedDifficulty = 'All';
                _isFilteredByDifficulty = false;
              });
            },
            icon:
                Icon(Icons.filter_list_off, size: _accessibilityMode ? 28 : 24),
            label: Text(
              'Clear Filters',
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

  String _getDietaryDescription(String dietaryType) {
    switch (dietaryType) {
      case 'Vegetarian':
        return 'Delicious recipes without meat or fish';
      case 'Vegan':
        return 'Plant-based recipes without animal products';
      case 'Gluten-Free':
        return 'Recipes without wheat, barley, or rye';
      case 'Low-Carb':
        return 'Meals with reduced carbohydrate content';
      case 'Diabetic':
        return 'Recipes suitable for managing blood sugar levels';
      default:
        return 'Specialized recipes for dietary preferences';
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
                    // Information on ched and time
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

                    // Difficulty inidcator
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical:
                            _accessibilityMode ? 20 : (isLargeFont ? 12 : 8),
                        horizontal: _accessibilityMode ? 24 : 16,
                      ),
                      decoration: BoxDecoration(
                        color: _isFilteredByDifficulty &&
                                _selectedDifficulty == recipe['difficulty']
                            ? widget.accentColor.withOpacity(0.2)
                            : widget.primaryColor.withOpacity(0.15),
                        borderRadius:
                            BorderRadius.circular(_accessibilityMode ? 16 : 12),
                        border: Border.all(
                          color: _isFilteredByDifficulty &&
                                  _selectedDifficulty == recipe['difficulty']
                              ? widget.accentColor
                              : widget.primaryColor.withOpacity(0.5),
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
                              color: _isFilteredByDifficulty &&
                                      _selectedDifficulty ==
                                          recipe['difficulty']
                                  ? widget.accentColor
                                  : widget.primaryColor,
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
