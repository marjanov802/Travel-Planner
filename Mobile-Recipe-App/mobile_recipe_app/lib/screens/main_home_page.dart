//comments added so i can traverse the file to edit using crtl f faster
import 'signup_font_screen.dart';
import 'signup_color_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'recipe_detail_screen.dart';
import 'category_recipes_screen.dart';
import 'dietary_recipes_screen.dart';
import 'accessibility_controller.dart';

class RecipeVideoItem {
  final String title;
  final String duration;
  final String authorName;
  final List<String> ingredients;
  final List<String> steps;
  final String imagePath;
  final String? difficulty;
  final String? category;

  RecipeVideoItem({
    required this.title,
    required this.duration,
    required this.authorName,
    required this.ingredients,
    required this.steps,
    required this.imagePath,
    this.difficulty,
    this.category,
  });
}

class MainHomePage extends StatefulWidget {
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
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int _selectedIndex = 0;
  int _currentVideoIndex = 0;
  final PageController _pageController = PageController();

  // Use AccessibilityController instead of local variables
  final AccessibilityController _accessibilityController =
      AccessibilityController();
  bool _guidedModeEnabled = false;

  final List<RecipeVideoItem> _videos = [
    RecipeVideoItem(
      title: 'Easy Pancakes',
      duration: '15 min',
      authorName: 'Chef Maria',
      imagePath: 'assets/pancakes.jpg',
      difficulty: 'Easy',
      category: 'Breakfast',
      ingredients: [
        '1 cup flour',
        '2 eggs',
        '1 cup milk',
        '2 tbsp sugar',
      ],
      steps: [
        'Mix all ingredients in a bowl',
        'Heat pan with butter',
        'Pour batter and cook until bubbles form',
        'Flip and cook other side',
        'Serve with maple syrup'
      ],
    ),
    RecipeVideoItem(
      title: 'Quick Pasta',
      duration: '20 min',
      authorName: 'Chef John',
      imagePath: 'assets/pasta.jpg',
      difficulty: 'Medium',
      category: 'Main Course',
      ingredients: [
        '200g pasta',
        '1 can tomato sauce',
        '1 garlic clove',
        'Basil leaves',
      ],
      steps: [
        'Boil pasta in salted water',
        'Sauté minced garlic in olive oil',
        'Add tomato sauce and simmer',
        'Drain pasta and mix with sauce',
        'Garnish with fresh basil'
      ],
    ),
    RecipeVideoItem(
      title: 'Fruit Smoothie',
      duration: '5 min',
      authorName: 'Healthy Cook',
      imagePath: 'assets/fruit-smoothie.jpg',
      difficulty: 'Easy',
      category: 'Beverages',
      ingredients: [
        '1 banana',
        '1 cup strawberries',
        '1/2 cup yogurt',
        'Ice cubes',
      ],
      steps: [
        'Add all ingredients to blender',
        'Blend until smooth',
        'Add honey if needed for sweetness',
        'Pour into glass',
        'Garnish with fresh fruit'
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _accessibilityController.initTTS();

    // Add a slight delay before calling _updateAccessibilityContext
    // to ensure context is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateAccessibilityContext();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Add method to update captions and voice over based on context
  void _updateAccessibilityContext() {
    if (_accessibilityController.captionsEnabled) {
      String caption = '';

      if (_selectedIndex == 0) {
        // For You
        final currentRecipe = _videos[_currentVideoIndex];
        caption = "Now viewing: ${currentRecipe.title}. "
            "This recipe takes ${currentRecipe.duration} and has a ${currentRecipe.difficulty} difficulty level.";
      } else if (_selectedIndex == 1) {
        // Discover
        caption = "Discover recipes by category or dietary preferences";
      } else if (_selectedIndex == 2) {
        // Settings
        caption = "Accessibility and app settings";
      }

      _accessibilityController.updateCaption(caption, context);
    }

    if (_accessibilityController.voiceOverEnabled) {
      String voiceText = '';

      if (_selectedIndex == 0) {
        // For You
        final currentRecipe = _videos[_currentVideoIndex];
        voiceText = "Recipe for ${currentRecipe.title}. "
            "This recipe takes ${currentRecipe.duration} and is ${currentRecipe.difficulty} to make. "
            "It's made by ${currentRecipe.authorName}. "
            "You can swipe up to see more recipes.";
      } else if (_selectedIndex == 1) {
        voiceText =
            "You are on the Discover screen. Browse recipes by category or dietary needs.";
      } else if (_selectedIndex == 2) {
        voiceText =
            "You are on the Settings screen. Adjust text size, colors and other preferences.";
      }

      _accessibilityController.speak(voiceText);
    }
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      HapticFeedback.mediumImpact();
      setState(() {
        _selectedIndex = index;
      });
      // Update captions and voice over when tab changes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateAccessibilityContext();
      });
    }
  }

  void _onVideoChanged(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      _currentVideoIndex = index;
    });
    // Update captions and voice over when video changes
    _updateAccessibilityContext();
  }

  // For extremely large font sizes, provide helper methods
  bool get isExtremelyLargeFont => widget.selectedFontSize >= 42.0;
  bool get isLargeFont => widget.selectedFontSize >= 36.0;
  bool get isSmallFont => widget.selectedFontSize <= 18.0;

  // Utility method for consistent font scaling
  double _getScaledSize(double factor) {
    return widget.selectedFontSize * factor;
  }

  // Utility method for icon sizes
  double _getIconSize() {
    return widget.selectedFontSize * 1.2;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _sections = [
      _buildVideoFeed(),
      _buildSearchSection(),
      _buildSettingsSection(),
    ];

    return Scaffold(
      body: _sections[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
            )
          ],
        ),
        height: isLargeFont ? 80 : (isSmallFont ? 56 : 70), // Adaptive height
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.video_library,
                  size: isLargeFont ? 32 : (isSmallFont ? 24 : 28)),
              label: isLargeFont
                  ? ''
                  : 'For You', // Hide label for very large fonts
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search,
                  size: isLargeFont ? 32 : (isSmallFont ? 24 : 28)),
              label: isLargeFont ? '' : 'Discover',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings,
                  size: isLargeFont ? 32 : (isSmallFont ? 24 : 28)),
              label: isLargeFont ? '' : 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: widget.accentColor,
          unselectedItemColor: widget.textColor.withOpacity(0.6),
          backgroundColor: widget.backgroundColor,
          selectedFontSize:
              isSmallFont ? 12 : 14, // Fixed smaller font for nav bar
          unselectedFontSize:
              isSmallFont ? 10 : 12, // Fixed smaller font for nav bar
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
      ),
    );
  }

  Widget _buildVideoFeed() {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      onPageChanged: _onVideoChanged,
      itemCount: _videos.length,
      itemBuilder: (context, index) {
        return _buildVideoItem(_videos[index]);
      },
    );
  }

  Widget _buildVideoItem(RecipeVideoItem video) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Recipe image with gradient overlay
        ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.black.withOpacity(0.9)
              ],
            ).createShader(rect);
          },
          blendMode: BlendMode.darken,
          child: Image.asset(
            video.imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),

        // Content
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top bar with info badges
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    if (video.difficulty != null)
                      _buildInfoBadge(
                        video.difficulty!,
                        icon: Icons.signal_cellular_alt,
                      ),
                    const SizedBox(width: 8),
                    _buildInfoBadge(
                      video.duration,
                      icon: Icons.timer,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: _getScaledSize(1.2),
                      ),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Recipe saved to favorites!')),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Bottom content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipe details and start button
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                video.title,
                                style: TextStyle(
                                  fontSize: _getScaledSize(1.3),
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.3,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: isLargeFont ? 1 : 2,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: _getScaledSize(0.8),
                                    backgroundColor: widget.accentColor,
                                    child: Text(
                                      video.authorName[0],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: _getScaledSize(0.7),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      'By ${video.authorName}',
                                      style: TextStyle(
                                        fontSize: _getScaledSize(0.8),
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            HapticFeedback.mediumImpact();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipeDetailScreen(
                                  recipeTitle: video.title,
                                  ingredients: video.ingredients,
                                  steps: video.steps,
                                  primaryColor: widget.primaryColor,
                                  accentColor: widget.accentColor,
                                  backgroundColor: widget.backgroundColor,
                                  textColor: widget.textColor,
                                  selectedFontSize: widget.selectedFontSize,
                                ),
                              ),
                            );

                            // Update captions and voice over for the detail screen
                            if (_accessibilityController.captionsEnabled) {
                              _accessibilityController.updateCaption(
                                "Viewing recipe: ${video.title}. Tap ingredients to check them off your list.",
                                context,
                              );
                            }

                            if (_accessibilityController.voiceOverEnabled) {
                              _accessibilityController.speak(
                                  "Now viewing recipe details for ${video.title}. This page shows ingredients and steps.");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.accentColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: isLargeFont ? 16 : 12,
                              horizontal: isLargeFont ? 20 : 16,
                            ),
                            elevation: 4,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: _getScaledSize(1.0),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Start Cooking',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: _getScaledSize(0.8),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Accessibility features - Replaced with new implementation
                  _buildAccessibilityFeatures(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Improved implementation for accessibility features
  Widget _buildAccessibilityFeatures() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.6),
          ],
        ),
      ),
      child: Column(
        children: [
          // Show appropriate number of buttons based on font size
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Captions Button - Updated to use AccessibilityController
              _buildAccessibilityButton(
                icon: _accessibilityController.captionsEnabled
                    ? Icons.closed_caption
                    : Icons.closed_caption_outlined,
                label: 'Captions',
                isActive: _accessibilityController.captionsEnabled,
                tooltip: _accessibilityController.captionsEnabled
                    ? 'Turn off captions'
                    : 'Turn on captions for recipe instructions',
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  final newState = !_accessibilityController.captionsEnabled;

                  setState(() {});
                  _accessibilityController.setCaptionsEnabled(
                      newState, context);

                  // Show confirmation message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          newState ? 'Captions enabled' : 'Captions disabled'),
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'OK',
                        onPressed: () {},
                      ),
                    ),
                  );

                  // When captions are enabled, update the caption
                  if (newState) {
                    _updateAccessibilityContext();
                  }
                },
              ),

              // Only show these buttons if not using extremely large font
              if (!isExtremelyLargeFont) ...[
                // Voice Over Button - Updated to use AccessibilityController
                _buildAccessibilityButton(
                  icon: _accessibilityController.voiceOverEnabled
                      ? Icons.record_voice_over
                      : Icons.record_voice_over_outlined,
                  label: 'Voice Over',
                  isActive: _accessibilityController.voiceOverEnabled,
                  tooltip: _accessibilityController.voiceOverEnabled
                      ? 'Turn off voice guidance'
                      : 'Turn on voice guidance for this recipe',
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    final newState = !_accessibilityController.voiceOverEnabled;

                    setState(() {});
                    _accessibilityController.setVoiceOverEnabled(newState);

                    // Show confirmation message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(newState
                            ? 'Voice over enabled'
                            : 'Voice over disabled'),
                        duration: Duration(seconds: 2),
                        action: SnackBarAction(
                          label: 'OK',
                          onPressed: () {},
                        ),
                      ),
                    );

                    // When voice over is enabled, start speaking
                    if (newState) {
                      _updateAccessibilityContext();
                    }
                  },
                ),

                // Step-by-Step Guided Mode
                _buildAccessibilityButton(
                  icon: _guidedModeEnabled
                      ? Icons.accessibility
                      : Icons.accessibility_new_outlined,
                  label: 'Guided Mode',
                  isActive: _guidedModeEnabled,
                  tooltip: _guidedModeEnabled
                      ? 'Turn off guided mode'
                      : 'Turn on step-by-step guided mode with extra help',
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    setState(() {
                      _guidedModeEnabled = !_guidedModeEnabled;
                    });

                    // Show confirmation message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_guidedModeEnabled
                            ? 'Guided mode enabled'
                            : 'Guided mode disabled'),
                        duration: Duration(seconds: 2),
                        action: SnackBarAction(
                          label: 'OK',
                          onPressed: () {},
                        ),
                      ),
                    );

                    // When guided mode is enabled, open recipe in special guided mode
                    if (_guidedModeEnabled) {
                      _openGuidedMode();
                    }
                  },
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.keyboard_arrow_up,
                color: Colors.white70,
                size: _getScaledSize(0.9),
              ),
              const SizedBox(width: 4),
              Text(
                'Swipe up for next recipe',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: _getScaledSize(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Improved accessibility button with active state
  Widget _buildAccessibilityButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onPressed,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(isLargeFont ? 14 : 10),
              decoration: BoxDecoration(
                color: isActive
                    ? widget.accentColor
                    : widget.accentColor.withOpacity(0.5),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: isActive ? Colors.white : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: isLargeFont ? _getScaledSize(0.7) : _getScaledSize(0.9),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize:
                    isLargeFont ? _getScaledSize(0.5) : _getScaledSize(0.6),
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to open recipe in guided mode
  void _openGuidedMode() {
    if (!_guidedModeEnabled) return;

    // Get current recipe
    RecipeVideoItem currentRecipe = _videos[_currentVideoIndex];

    // Update captions if enabled
    if (_accessibilityController.captionsEnabled) {
      _accessibilityController.updateCaption(
          "Guided mode enabled for ${currentRecipe.title}. Follow each step carefully.",
          context);
    }

    // Speak if voice over is enabled
    if (_accessibilityController.voiceOverEnabled) {
      _accessibilityController
          .speak("Guided mode has been enabled for ${currentRecipe.title}. "
              "We'll walk you through each step with extra guidance.");
    }

    // Navigate to a special version of the recipe screen with extra help
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(
          recipeTitle: currentRecipe.title,
          ingredients: currentRecipe.ingredients,
          steps: currentRecipe.steps,
          primaryColor: widget.primaryColor,
          accentColor: widget.accentColor,
          backgroundColor: widget.backgroundColor,
          textColor: widget.textColor,
          selectedFontSize: widget.selectedFontSize,
          // You would add extra parameters here for guided mode
          // isGuidedMode: true,
        ),
      ),
    );
  }

  Widget _buildInfoBadge(String text, {required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: _getScaledSize(0.7),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: _getScaledSize(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    // Show even fewer items with extremely large fonts
    final int numItems = isExtremelyLargeFont ? 1 : (isLargeFont ? 2 : 3);

    // Modified trending recipes code - trimmed for extremely large fonts
    final List<Map<String, dynamic>> trendingRecipes = [
      {
        'title': 'One-Pot Pasta',
        'image': 'assets/pancakes.jpg',
        'chef': 'Chef Maria',
        'time': '20 min',
        'rating': 4.8,
        'difficulty': 'Easy',
      },
      {
        'title': 'Quick Breakfast',
        'image': 'assets/omelete vegan.jpg',
        'chef': 'Healthy Cook',
        'time': '10 min',
        'rating': 4.7,
        'difficulty': 'Easy',
      },
      {
        'title': 'Vegetable Curry',
        'image': 'assets/vegetable curry.jpg',
        'chef': 'Chef John',
        'time': '30 min',
        'rating': 4.9,
        'difficulty': 'Medium',
      },
    ];

    // Show fewer categories for very large font sizes
    final List<Map<String, dynamic>> mealTypes = isExtremelyLargeFont
        ? [
            {'name': 'Breakfast', 'icon': Icons.breakfast_dining},
            {'name': 'Lunch', 'icon': Icons.lunch_dining},
          ]
        : isLargeFont
            ? [
                {'name': 'Breakfast', 'icon': Icons.breakfast_dining},
                {'name': 'Lunch', 'icon': Icons.lunch_dining},
                {'name': 'Dinner', 'icon': Icons.dinner_dining},
              ]
            : [
                {'name': 'Breakfast', 'icon': Icons.breakfast_dining},
                {'name': 'Lunch', 'icon': Icons.lunch_dining},
                {'name': 'Dinner', 'icon': Icons.dinner_dining},
                {'name': 'Snacks', 'icon': Icons.cookie},
                {'name': 'Desserts', 'icon': Icons.icecream},
              ];

    // Show even fewer dietary needs for extremely large fonts
    final List<Map<String, dynamic>> dietaryNeeds = isExtremelyLargeFont
        ? [
            {'name': 'Vegetarian', 'icon': Icons.spa},
          ]
        : isLargeFont
            ? [
                {'name': 'Vegetarian', 'icon': Icons.spa},
                {'name': 'Vegan', 'icon': Icons.grass},
              ]
            : [
                {'name': 'Vegetarian', 'icon': Icons.spa},
                {'name': 'Vegan', 'icon': Icons.grass},
                {'name': 'Gluten-Free', 'icon': Icons.do_not_touch},
                {'name': 'Low-Carb', 'icon': Icons.monitor_weight},
                {'name': 'Diabetic', 'icon': Icons.health_and_safety},
              ];

    return Scaffold(
      body: Container(
        color: widget.backgroundColor,
        child: ListView(
          // Using ListView instead of CustomScrollView for simpler navigation
          children: [
            // Large, accessible search bar
            Container(
              color: widget.primaryColor,
              padding: EdgeInsets.all(isLargeFont ? 16 : 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isExtremelyLargeFont ? 'Search' : 'Find Recipes',
                    style: TextStyle(
                      fontSize: isLargeFont ? 32 : _getScaledSize(1.3),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isLargeFont ? 16 : 12),
                  Container(
                    height: isLargeFont ? 70 : (isSmallFont ? 48 : 56),
                    padding:
                        EdgeInsets.symmetric(horizontal: isLargeFont ? 16 : 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(isLargeFont ? 24 : 20),
                      border: Border.all(
                          color: widget.accentColor,
                          width: isLargeFont ? 3 : 2),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: widget.accentColor,
                          size: isLargeFont ? 32 : 24,
                        ),
                        SizedBox(width: isLargeFont ? 12 : 8),
                        Expanded(
                          child: TextField(
                            style: TextStyle(
                              fontSize: isLargeFont ? 24 : _getScaledSize(1.0),
                              color: widget.textColor,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search recipes...',
                              hintStyle: TextStyle(
                                fontSize:
                                    isLargeFont ? 24 : _getScaledSize(1.0),
                                color: widget.textColor.withOpacity(0.6),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isLargeFont ? 16 : 12),
                  // Voice search button - large, clear, with tooltip
                  Container(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(
                        Icons.mic,
                        size: isLargeFont ? 32 : 24,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Search with voice',
                        style: TextStyle(
                          fontSize: isLargeFont ? 24 : _getScaledSize(1.0),
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () {
                        HapticFeedback.mediumImpact();

                        // Update captions if enabled
                        if (_accessibilityController.captionsEnabled) {
                          _accessibilityController.updateCaption(
                              "Voice search activated. Please speak your search query now.",
                              context);
                        }

                        // Speak if voice over is enabled
                        if (_accessibilityController.voiceOverEnabled) {
                          _accessibilityController.speak(
                              "Voice search activated. Please speak your search query now.");
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Voice search activated. Please speak now...'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.accentColor,
                        padding: EdgeInsets.symmetric(
                          vertical: isLargeFont ? 20 : 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(isLargeFont ? 16 : 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Section: Meal Categories
            _buildSectionHeader(
              'Meal Categories',
              Icons.restaurant_menu,
              isLargeFont ? 24 : _getScaledSize(1.2),
              isLargeFont ? 16 : 12,
            ),

            // Display categories as a vertical list for better accessibility
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isLargeFont ? 16 : 12,
                vertical: isLargeFont ? 8 : 6,
              ),
              child: Column(
                children: mealTypes
                    .map((category) => _buildAccessibleCategoryButton(
                          name: category['name'],
                          icon: category['icon'],
                        ))
                    .toList(),
              ),
            ),

            // Dietary Needs section (if small font or just first few if large font)
            _buildSectionHeader(
              'Dietary Needs',
              Icons.health_and_safety_rounded,
              isLargeFont ? 24 : _getScaledSize(1.2),
              isLargeFont ? 16 : 12,
            ),

            // Updated dietary needs section with navigation
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isLargeFont ? 16 : 12,
                vertical: isLargeFont ? 8 : 6,
              ),
              child: Column(
                children: dietaryNeeds
                    .map((category) => Padding(
                          padding:
                              EdgeInsets.only(bottom: isLargeFont ? 16 : 8),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                HapticFeedback.mediumImpact();

                                // Update captions if enabled
                                if (_accessibilityController.captionsEnabled) {
                                  _accessibilityController.updateCaption(
                                      "Viewing ${category['name']} recipes.",
                                      context);
                                }

                                // Speak if voice over is enabled
                                if (_accessibilityController.voiceOverEnabled) {
                                  _accessibilityController.speak(
                                      "Showing ${category['name']} recipes. These recipes are specially made for ${category['name']} diets.");
                                }

                                // Navigate to the dietary recipes screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DietaryRecipesScreen(
                                      dietaryType: category['name'],
                                      dietaryIcon: category['icon'],
                                      primaryColor: widget.primaryColor,
                                      accentColor: widget.accentColor,
                                      backgroundColor: widget.backgroundColor,
                                      textColor: widget.textColor,
                                      selectedFontSize: widget.selectedFontSize,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                height: isLargeFont
                                    ? (isExtremelyLargeFont ? 90 : 72)
                                    : null,
                                padding: EdgeInsets.all(isLargeFont
                                    ? (isExtremelyLargeFont ? 24 : 16)
                                    : 12),
                                decoration: BoxDecoration(
                                  color: widget.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(
                                      isLargeFont ? 16 : 12),
                                  border: Border.all(
                                    color: widget.primaryColor.withOpacity(0.3),
                                    width: isLargeFont ? 3 : 2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      category['icon'],
                                      size: isLargeFont
                                          ? (isExtremelyLargeFont ? 42 : 36)
                                          : (isSmallFont ? 20 : 24),
                                      color: widget.primaryColor,
                                    ),
                                    SizedBox(
                                        width: isLargeFont
                                            ? (isExtremelyLargeFont ? 20 : 16)
                                            : 12),
                                    Expanded(
                                      child: Text(
                                        category['name'],
                                        style: TextStyle(
                                          fontSize: isLargeFont
                                              ? (isExtremelyLargeFont ? 30 : 24)
                                              : (isSmallFont
                                                  ? 16
                                                  : _getScaledSize(1.0)),
                                          fontWeight: FontWeight.bold,
                                          color: widget.textColor,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: isLargeFont ? 24 : 20,
                                      color: widget.primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),

            // Trending Recipes section
            _buildSectionHeader(
              'Popular Recipes',
              Icons.trending_up,
              isLargeFont ? 24 : _getScaledSize(1.2),
              isLargeFont ? 16 : 12,
            ),

            // Show recipe cards in vertical list for easier scanning
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isLargeFont ? 16 : 12,
                vertical: isLargeFont ? 8 : 6,
              ),
              child: Column(
                children: trendingRecipes
                    .take(numItems)
                    .map((recipe) => _buildAccessibleRecipeCard(recipe))
                    .toList(),
              ),
            ),

            // Enhanced Recommended For You section
            _buildEnhancedSectionHeader(
              'Recommended For You',
              Icons.recommend,
              isLargeFont ? 24 : _getScaledSize(1.2),
              isLargeFont ? 16 : 12,
            ),

            Container(
              margin: EdgeInsets.symmetric(
                horizontal: isLargeFont ? 16 : 12,
                vertical: isLargeFont ? 8 : 6,
              ),
              child: Column(
                children: _videos
                    .take(numItems)
                    .map((recipe) => _buildEnhancedRecommendedCard({
                          'title': recipe.title,
                          'image': recipe.imagePath,
                          'chef': recipe.authorName,
                          'time': recipe.duration,
                          'rating': 4.8,
                          'difficulty': recipe.difficulty ?? 'Medium',
                        }))
                    .toList(),
              ),
            ),

            // Help button at the bottom
            Padding(
              padding: EdgeInsets.all(isLargeFont ? 16 : 12),
              child: ElevatedButton.icon(
                icon: Icon(
                  Icons.help_outline,
                  size: isLargeFont ? 32 : 24,
                  color: Colors.white,
                ),
                label: Text(
                  'Need help finding a recipe?',
                  style: TextStyle(
                    fontSize: isLargeFont ? 24 : _getScaledSize(1.0),
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  HapticFeedback.mediumImpact();

                  // Update captions if enabled
                  if (_accessibilityController.captionsEnabled) {
                    _accessibilityController.updateCaption(
                        "Help section will guide you through finding recipes.",
                        context);
                  }

                  // Speak if voice over is enabled
                  if (_accessibilityController.voiceOverEnabled) {
                    _accessibilityController.speak(
                        "The help section will guide you through finding recipes based on your preferences.");
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Help section coming soon!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.primaryColor,
                  padding:
                      EdgeInsets.symmetric(vertical: isLargeFont ? 20 : 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(isLargeFont ? 16 : 12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Enhanced recipe card for popular recipes
  Widget _buildAccessibleRecipeCard(Map<String, dynamic> recipe) {
    return Card(
      margin: EdgeInsets.only(bottom: isLargeFont ? 20 : 12),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: widget.primaryColor,
          width: isLargeFont ? 3 : 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          // Find matching recipe in _videos
          RecipeVideoItem? matchingRecipe = _videos.firstWhere(
            (v) => v.title == recipe['title'],
            orElse: () => _videos[0], // Default to first recipe if not found
          );

          // Update captions if enabled
          if (_accessibilityController.captionsEnabled) {
            _accessibilityController.updateCaption(
                "Opening recipe: ${matchingRecipe.title}.", context);
          }

          // Speak if voice over is enabled
          if (_accessibilityController.voiceOverEnabled) {
            _accessibilityController.speak(
                "Opening recipe details for ${matchingRecipe.title}. This recipe takes ${matchingRecipe.duration} and has a ${matchingRecipe.difficulty} difficulty level.");
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailScreen(
                recipeTitle: matchingRecipe.title,
                ingredients: matchingRecipe.ingredients,
                steps: matchingRecipe.steps,
                primaryColor: widget.primaryColor,
                accentColor: widget.accentColor,
                backgroundColor: widget.backgroundColor,
                textColor: widget.textColor,
                selectedFontSize: widget.selectedFontSize,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: widget.backgroundColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Recipe title banner
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: isLargeFont ? 16 : 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: widget.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Text(
                  recipe['title'],
                  style: TextStyle(
                    fontSize: isExtremelyLargeFont
                        ? 32
                        : (isLargeFont ? 28 : _getScaledSize(1.1)),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Recipe image with border
              if (!isExtremelyLargeFont)
                Container(
                  margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  height: isLargeFont ? 180 : 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: widget.primaryColor,
                      width: 2,
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
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Chef & Time in clear boxes
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(isLargeFont ? 12 : 8),
                            decoration: BoxDecoration(
                              color: widget.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: widget.primaryColor.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: widget.primaryColor,
                                  size: isLargeFont ? 28 : 24,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  recipe['chef'],
                                  style: TextStyle(
                                    fontSize:
                                        isLargeFont ? 20 : _getScaledSize(0.9),
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
                        SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(isLargeFont ? 12 : 8),
                            decoration: BoxDecoration(
                              color: widget.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: widget.primaryColor.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.timer,
                                  color: widget.primaryColor,
                                  size: isLargeFont ? 28 : 24,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  recipe['time'],
                                  style: TextStyle(
                                    fontSize:
                                        isLargeFont ? 20 : _getScaledSize(0.9),
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

                    SizedBox(height: isLargeFont ? 16 : 12),

                    // Difficulty with clearer labeling
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: isLargeFont ? 12 : 8,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: widget.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: widget.primaryColor.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Difficulty: ",
                            style: TextStyle(
                              fontSize: isLargeFont ? 20 : _getScaledSize(0.9),
                              color: widget.textColor,
                            ),
                          ),
                          Text(
                            recipe['difficulty'],
                            style: TextStyle(
                              fontSize: isLargeFont ? 20 : _getScaledSize(0.9),
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

              // View Recipe button - large and clear
              Container(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                width: double.infinity,
                height: isExtremelyLargeFont ? 70 : (isLargeFont ? 60 : 50),
                child: ElevatedButton.icon(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    // Find matching recipe in _videos
                    RecipeVideoItem? matchingRecipe = _videos.firstWhere(
                      (v) => v.title == recipe['title'],
                      orElse: () => _videos[0],
                    );

                    // Update captions if enabled
                    if (_accessibilityController.captionsEnabled) {
                      _accessibilityController.updateCaption(
                          "Opening recipe: ${matchingRecipe.title}.", context);
                    }

                    // Speak if voice over is enabled
                    if (_accessibilityController.voiceOverEnabled) {
                      _accessibilityController.speak(
                          "Opening recipe details for ${matchingRecipe.title}. This recipe takes ${matchingRecipe.duration} and has a ${matchingRecipe.difficulty} difficulty level.");
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailScreen(
                          recipeTitle: matchingRecipe.title,
                          ingredients: matchingRecipe.ingredients,
                          steps: matchingRecipe.steps,
                          primaryColor: widget.primaryColor,
                          accentColor: widget.accentColor,
                          backgroundColor: widget.backgroundColor,
                          textColor: widget.textColor,
                          selectedFontSize: widget.selectedFontSize,
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.menu_book,
                    size: isLargeFont ? 28 : 24,
                    color: Colors.white,
                  ),
                  label: Text(
                    'View Recipe',
                    style: TextStyle(
                      fontSize: isLargeFont ? 24 : _getScaledSize(1.0),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedRecommendedCard(Map<String, dynamic> recipe) {
    return Card(
      margin: EdgeInsets.only(bottom: isLargeFont ? 20 : 12),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: widget.accentColor,
          width: isLargeFont ? 3 : 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          // Find matching recipe in _videos
          RecipeVideoItem? matchingRecipe = _videos.firstWhere(
            (v) => v.title == recipe['title'],
            orElse: () => _videos[0],
          );

          // Update captions if enabled
          if (_accessibilityController.captionsEnabled) {
            _accessibilityController.updateCaption(
                "Opening recommended recipe: ${matchingRecipe.title}.",
                context);
          }

          // Speak if voice over is enabled
          if (_accessibilityController.voiceOverEnabled) {
            _accessibilityController.speak(
                "Opening recommended recipe for ${matchingRecipe.title}. This recipe is specially recommended for you.");
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailScreen(
                recipeTitle: matchingRecipe.title,
                ingredients: matchingRecipe.ingredients,
                steps: matchingRecipe.steps,
                primaryColor: widget.primaryColor,
                accentColor: widget.accentColor,
                backgroundColor: widget.backgroundColor,
                textColor: widget.textColor,
                selectedFontSize: widget.selectedFontSize,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: widget.backgroundColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Recipe title with "For You" ribbon
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: isLargeFont ? 16 : 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: widget.accentColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Text(
                      recipe['title'],
                      style: TextStyle(
                        fontSize: isExtremelyLargeFont
                            ? 32
                            : (isLargeFont ? 28 : _getScaledSize(1.1)),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // "For You" ribbon
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isLargeFont ? 16 : 12,
                        vertical: isLargeFont ? 8 : 6,
                      ),
                      decoration: BoxDecoration(
                        color: widget.primaryColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Text(
                        'For You',
                        style: TextStyle(
                          fontSize: isLargeFont ? 18 : 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Recipe image with special styling
              if (!isExtremelyLargeFont)
                Container(
                  margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  height: isLargeFont ? 180 : 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: widget.accentColor,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.accentColor.withOpacity(0.2),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
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

              // Recipe info in horizontal format
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Chef info
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: EdgeInsets.all(isLargeFont ? 12 : 8),
                        decoration: BoxDecoration(
                          color: widget.accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: widget.accentColor.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.person,
                              color: widget.accentColor,
                              size: isLargeFont ? 28 : 24,
                            ),
                            SizedBox(height: 4),
                            Text(
                              recipe['chef'],
                              style: TextStyle(
                                fontSize:
                                    isLargeFont ? 20 : _getScaledSize(0.9),
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

                    SizedBox(width: 12),

                    // Time info
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.all(isLargeFont ? 12 : 8),
                        decoration: BoxDecoration(
                          color: widget.accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: widget.accentColor.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.timer,
                              color: widget.accentColor,
                              size: isLargeFont ? 28 : 24,
                            ),
                            SizedBox(height: 4),
                            Text(
                              recipe['time'],
                              style: TextStyle(
                                fontSize:
                                    isLargeFont ? 20 : _getScaledSize(0.9),
                                fontWeight: FontWeight.bold,
                                color: widget.textColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(width: 12),

                    // Difficulty info
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.all(isLargeFont ? 12 : 8),
                        decoration: BoxDecoration(
                          color: widget.accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: widget.accentColor.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.signal_cellular_alt,
                              color: widget.accentColor,
                              size: isLargeFont ? 28 : 24,
                            ),
                            SizedBox(height: 4),
                            Text(
                              recipe['difficulty'],
                              style: TextStyle(
                                fontSize:
                                    isLargeFont ? 20 : _getScaledSize(0.9),
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
              ),

              // Start cooking button - simple and clear
              Container(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                width: double.infinity,
                height: isExtremelyLargeFont ? 70 : (isLargeFont ? 60 : 50),
                child: ElevatedButton.icon(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    // Find matching recipe in _videos
                    RecipeVideoItem? matchingRecipe = _videos.firstWhere(
                      (v) => v.title == recipe['title'],
                      orElse: () => _videos[0],
                    );

                    // Update captions if enabled
                    if (_accessibilityController.captionsEnabled) {
                      _accessibilityController.updateCaption(
                          "Opening recommended recipe: ${matchingRecipe.title}.",
                          context);
                    }

                    // Speak if voice over is enabled
                    if (_accessibilityController.voiceOverEnabled) {
                      _accessibilityController.speak(
                          "Starting to cook ${matchingRecipe.title}. Let's follow the steps together.");
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailScreen(
                          recipeTitle: matchingRecipe.title,
                          ingredients: matchingRecipe.ingredients,
                          steps: matchingRecipe.steps,
                          primaryColor: widget.primaryColor,
                          accentColor: widget.accentColor,
                          backgroundColor: widget.backgroundColor,
                          textColor: widget.textColor,
                          selectedFontSize: widget.selectedFontSize,
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.restaurant_menu,
                    size: isLargeFont ? 28 : 24,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Start Cooking',
                    style: TextStyle(
                      fontSize: isLargeFont ? 24 : _getScaledSize(1.0),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for section headers
  Widget _buildSectionHeader(
      String title, IconData icon, double fontSize, double padding) {
    return Padding(
      padding:
          EdgeInsets.fromLTRB(padding, padding * 1.5, padding, padding / 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: widget.primaryColor,
                size: fontSize * 1.2,
              ),
              SizedBox(width: padding / 1.5),
              // Wrap text in Flexible to prevent overflow
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: widget.textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Enhanced section header with better visibility
  Widget _buildEnhancedSectionHeader(
      String title, IconData icon, double fontSize, double padding) {
    return Container(
      margin: EdgeInsets.fromLTRB(padding, padding * 1.5, padding, padding / 2),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: widget.primaryColor,
        borderRadius: BorderRadius.circular(isLargeFont ? 16 : 12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: fontSize * 1.2,
          ),
          SizedBox(width: padding / 1.5),
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Updated Accessible category button with navigation
  Widget _buildAccessibleCategoryButton({
    required String name,
    required IconData icon,
  }) {
    // Adjust height and padding for very large fonts
    final double? buttonHeight =
        isLargeFont ? (isExtremelyLargeFont ? 90 : 72) : null;
    final double iconPadding =
        isLargeFont ? (isExtremelyLargeFont ? 24 : 16) : 12;

    return Padding(
      padding: EdgeInsets.only(bottom: isLargeFont ? 16 : 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.mediumImpact();

            // Update captions if enabled
            if (_accessibilityController.captionsEnabled) {
              _accessibilityController.updateCaption(
                  "Viewing ${name} recipes.", context);
            }

            // Speak if voice over is enabled
            if (_accessibilityController.voiceOverEnabled) {
              _accessibilityController.speak(
                  "Showing ${name} recipes. These are recipes typically served for ${name}.");
            }

            // Navigate to the category recipes screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryRecipesScreen(
                  categoryName: name,
                  categoryIcon: icon,
                  primaryColor: widget.primaryColor,
                  accentColor: widget.accentColor,
                  backgroundColor: widget.backgroundColor,
                  textColor: widget.textColor,
                  selectedFontSize: widget.selectedFontSize,
                ),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            height: buttonHeight,
            padding: EdgeInsets.all(iconPadding),
            decoration: BoxDecoration(
              color: widget.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(isLargeFont ? 16 : 12),
              border: Border.all(
                color: widget.primaryColor.withOpacity(0.3),
                width: isLargeFont ? 3 : 2,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: isLargeFont
                      ? (isExtremelyLargeFont ? 42 : 36)
                      : (isSmallFont ? 20 : 24),
                  color: widget.primaryColor,
                ),
                SizedBox(
                    width: isLargeFont ? (isExtremelyLargeFont ? 20 : 16) : 12),
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: isLargeFont
                          ? (isExtremelyLargeFont ? 30 : 24)
                          : (isSmallFont ? 16 : _getScaledSize(1.0)),
                      fontWeight: FontWeight.bold,
                      color: widget.textColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: isLargeFont ? 24 : 20,
                  color: widget.primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: isLargeFont ? 32 : 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: widget.primaryColor,
        automaticallyImplyLeading: false,
        elevation: 8,
      ),
      body: Container(
        color: widget.backgroundColor,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top explanation - Very prominent
              Container(
                padding: EdgeInsets.all(24),
                margin: EdgeInsets.only(bottom: 32),
                decoration: BoxDecoration(
                  color: widget.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.settings_accessibility,
                      color: Colors.white,
                      size: isLargeFont ? 48 : 40,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Accessibility Settings',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isLargeFont ? 28 : 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Customize the app to make it easier to see and use.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isLargeFont ? 20 : 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Text Size Setting - Most important setting at the top
              _buildSettingCard(
                title: 'Text Size',
                icon: Icons.format_size,
                currentValue: '${widget.selectedFontSize.toInt()} points',
                isHighlighted: true,
                onTap: () {
                  HapticFeedback.mediumImpact();

                  // Update captions if enabled
                  if (_accessibilityController.captionsEnabled) {
                    _accessibilityController.updateCaption(
                        "Adjust text size to make content easier to read.",
                        context);
                  }

                  // Speak if voice over is enabled
                  if (_accessibilityController.voiceOverEnabled) {
                    _accessibilityController.speak(
                        "Text size settings. Current size is ${widget.selectedFontSize.toInt()} points. You can increase or decrease the text size to make it more comfortable to read.");
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpFontScreen(
                        selectedPalette: [
                          widget.primaryColor,
                          widget.backgroundColor,
                          widget.textColor,
                          widget.accentColor,
                        ],
                        isGuest: false,
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 20),

              // Color Theme Setting
              _buildSettingCard(
                title: 'Color Theme',
                icon: Icons.palette,
                showColorSample: true,
                onTap: () {
                  HapticFeedback.mediumImpact();

                  // Update captions if enabled
                  if (_accessibilityController.captionsEnabled) {
                    _accessibilityController.updateCaption(
                        "Choose color theme with high contrast for better visibility.",
                        context);
                  }

                  // Speak if voice over is enabled
                  if (_accessibilityController.voiceOverEnabled) {
                    _accessibilityController.speak(
                        "Color theme settings. You can choose from several high-contrast color themes to improve visibility and readability.");
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpColorScreen(
                        isGuest: false,
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 20),

              // Screen Reader Toggle - Updated to use AccessibilityController
              _buildToggleCard(
                title: 'Screen Reader',
                icon: Icons.record_voice_over,
                isEnabled: _accessibilityController.voiceOverEnabled,
                onChanged: (value) {
                  HapticFeedback.mediumImpact();

                  setState(() {});
                  _accessibilityController.setVoiceOverEnabled(value);

                  // Update captions if enabled
                  if (_accessibilityController.captionsEnabled) {
                    _accessibilityController.updateCaption(
                        value
                            ? "Voice guidance enabled."
                            : "Voice guidance disabled.",
                        context);
                  }

                  // Speak confirmation if enabling
                  if (value) {
                    _accessibilityController.speak(
                        "Voice guidance is now enabled. I will speak descriptions of what you're looking at.");
                  }
                },
              ),

              SizedBox(height: 20),

              // Captions Toggle - Updated to use AccessibilityController
              _buildToggleCard(
                title: 'Captions',
                icon: Icons.closed_caption,
                isEnabled: _accessibilityController.captionsEnabled,
                onChanged: (value) {
                  HapticFeedback.mediumImpact();

                  setState(() {});
                  _accessibilityController.setCaptionsEnabled(value, context);

                  // Speak if voice over is enabled
                  if (_accessibilityController.voiceOverEnabled) {
                    _accessibilityController.speak(value
                        ? "Captions are now enabled. Text descriptions will appear at the bottom of the screen."
                        : "Captions are now disabled.");
                  }

                  // Update caption
                  if (value) {
                    _updateAccessibilityContext();
                  }
                },
              ),

              SizedBox(height: 20),

              _buildToggleCard(
                title: 'Reduce Motion',
                icon: Icons.animation,
                isEnabled: false,
                onChanged: (value) {
                  HapticFeedback.mediumImpact();

                  if (_accessibilityController.captionsEnabled) {
                    _accessibilityController.updateCaption(
                        value
                            ? "Animations reduced for comfort."
                            : "Standard animations restored.",
                        context);
                  }

                  if (_accessibilityController.voiceOverEnabled) {
                    _accessibilityController.speak(value
                        ? "Reduced motion mode enabled. Animations will be minimized for your comfort."
                        : "Standard animations restored.");
                  }
                },
              ),

              SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: widget.primaryColor,
                      thickness: 2,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OTHER SETTINGS',
                      style: TextStyle(
                        fontSize: isLargeFont ? 18 : 16,
                        fontWeight: FontWeight.bold,
                        color: widget.primaryColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: widget.primaryColor,
                      thickness: 2,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              _buildSettingCard(
                title: 'Language',
                icon: Icons.language,
                currentValue: 'English',
                onTap: () {
                  HapticFeedback.mediumImpact();

                  if (_accessibilityController.captionsEnabled) {
                    _accessibilityController.updateCaption(
                        "Choose your preferred language.", context);
                  }

                  if (_accessibilityController.voiceOverEnabled) {
                    _accessibilityController.speak(
                        "Language settings. Current language is English. You can change the app language here.");
                  }
                },
              ),

              SizedBox(height: 20),

              _buildSettingCard(
                title: 'Measurement Units',
                icon: Icons.straighten,
                currentValue: 'Metric',
                onTap: () {
                  HapticFeedback.mediumImpact();

                  if (_accessibilityController.captionsEnabled) {
                    _accessibilityController.updateCaption(
                        "Choose between metric and imperial measurement units.",
                        context);
                  }

                  if (_accessibilityController.voiceOverEnabled) {
                    _accessibilityController.speak(
                        "Measurement units settings. Current unit system is Metric. You can switch between Metric and Imperial units.");
                  }
                },
              ),

              SizedBox(height: 32),

              Container(
                height: isLargeFont ? 80 : 70,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ElevatedButton.icon(
                  icon: Icon(
                    Icons.help_outline,
                    size: isLargeFont ? 36 : 32,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Get Help',
                    style: TextStyle(
                      fontSize: isLargeFont ? 28 : 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    HapticFeedback.mediumImpact();

                    if (_accessibilityController.captionsEnabled) {
                      _accessibilityController.updateCaption(
                          "Help and support resources.", context);
                    }

                    if (_accessibilityController.voiceOverEnabled) {
                      _accessibilityController.speak(
                          "Help and support section. Here you can find assistance with using the app and troubleshooting common issues.");
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Help section coming soon!'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.accentColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 8,
                  ),
                ),
              ),

              SizedBox(height: 20),

              Center(
                child: Text(
                  'App Version 1.0.0',
                  style: TextStyle(
                    color: widget.textColor.withOpacity(0.7),
                    fontSize: isLargeFont ? 20 : 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required IconData icon,
    String? currentValue,
    bool showColorSample = false,
    bool isHighlighted = false,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: isHighlighted
            ? widget.primaryColor.withOpacity(0.15)
            : widget.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border.all(
                color: isHighlighted
                    ? widget.primaryColor
                    : widget.primaryColor.withOpacity(0.3),
                width: isHighlighted ? 4 : 3,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: isLargeFont ? 70 : 60,
                  height: isLargeFont ? 70 : 60,
                  decoration: BoxDecoration(
                    color: widget.primaryColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.primaryColor,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: widget.primaryColor,
                    size: isLargeFont ? 36 : 30,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: isLargeFont ? 26 : 22,
                          fontWeight: FontWeight.bold,
                          color: widget.textColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      if (currentValue != null)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: widget.accentColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: widget.accentColor,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            currentValue,
                            style: TextStyle(
                              fontSize: isLargeFont ? 20 : 18,
                              fontWeight: FontWeight.bold,
                              color: widget.accentColor,
                            ),
                          ),
                        ),
                      if (showColorSample)
                        Container(
                          height: isLargeFont ? 36 : 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              colors: [widget.primaryColor, widget.accentColor],
                            ),
                            border: Border.all(
                              color: widget.textColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  width: isLargeFont ? 48 : 40,
                  height: isLargeFont ? 48 : 40,
                  decoration: BoxDecoration(
                    color: widget.accentColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    color: widget.accentColor,
                    size: isLargeFont ? 30 : 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleCard({
    required String title,
    required IconData icon,
    required bool isEnabled,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            border: Border.all(
              color: isEnabled
                  ? widget.accentColor
                  : widget.primaryColor.withOpacity(0.3),
              width: isEnabled ? 4 : 3,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                width: isLargeFont ? 70 : 60,
                height: isLargeFont ? 70 : 60,
                decoration: BoxDecoration(
                  color: isEnabled
                      ? widget.accentColor.withOpacity(0.2)
                      : widget.primaryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isEnabled ? widget.accentColor : widget.primaryColor,
                    width: 2,
                  ),
                ),
                child: Icon(
                  icon,
                  color: isEnabled ? widget.accentColor : widget.primaryColor,
                  size: isLargeFont ? 36 : 30,
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: isLargeFont ? 26 : 22,
                    fontWeight: FontWeight.bold,
                    color: widget.textColor,
                  ),
                ),
              ),
              Container(
                width: isLargeFont ? 80 : 70,
                child: Transform.scale(
                  scale: isLargeFont ? 1.8 : 1.5,
                  child: Switch(
                    value: isEnabled,
                    onChanged: onChanged,
                    activeColor: widget.accentColor,
                    activeTrackColor: widget.accentColor.withOpacity(0.5),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: widget.textColor.withOpacity(0.3),
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
