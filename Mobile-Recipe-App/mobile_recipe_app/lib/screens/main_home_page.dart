import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'recipe_detail_screen.dart';

class RecipeVideoItem {
  final String title;
  final String duration;
  final String authorName;
  final List<String> ingredients;
  final List<String> steps;
  final String imagePath;

  RecipeVideoItem({
    required this.title,
    required this.duration,
    required this.authorName,
    required this.ingredients,
    required this.steps,
    required this.imagePath,
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

  final List<RecipeVideoItem> _videos = [
    RecipeVideoItem(
      title: 'Easy Pancakes',
      duration: '2:15',
      authorName: 'Chef Maria',
      imagePath: 'assets/pancakes.jpg',
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
      duration: '3:45',
      authorName: 'Chef John',
      imagePath: 'assets/pancakes.jpg',
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
      duration: '1:30',
      authorName: 'Healthy Cook',
      imagePath: 'assets/pancakes.jpg',
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

  void _onItemTapped(int index) {
    HapticFeedback.mediumImpact();
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onVideoChanged(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      _currentVideoIndex = index;
    });
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
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.video_library,
                  size: widget.selectedFontSize * 1.2),
              label: 'For You',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, size: widget.selectedFontSize * 1.2),
              label: 'Discover',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings, size: widget.selectedFontSize * 1.2),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: widget.accentColor,
          unselectedItemColor: widget.textColor.withOpacity(0.6),
          backgroundColor: widget.backgroundColor,
          selectedFontSize: widget.selectedFontSize * 0.8,
          unselectedFontSize: widget.selectedFontSize * 0.7,
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
        Image.asset(
          video.imagePath,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Container(
          color: Colors.black.withOpacity(0.3),
        ),
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                              fontSize: widget.selectedFontSize * 1.2,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 3,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'By ${video.authorName} • ${video.duration}',
                            style: TextStyle(
                              fontSize: widget.selectedFontSize * 0.8,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 3,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ],
                            ),
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
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.play_arrow, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'Start Cooking',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: widget.selectedFontSize * 0.8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildAccessibilityButton(
                          icon: Icons.closed_caption,
                          label: 'Captions',
                          onPressed: () {
                            HapticFeedback.lightImpact();
                          },
                        ),
                        _buildAccessibilityButton(
                          icon: Icons.record_voice_over,
                          label: 'Voice Over',
                          onPressed: () {
                            HapticFeedback.lightImpact();
                          },
                        ),
                        _buildAccessibilityButton(
                          icon: Icons.slow_motion_video,
                          label: 'Slow Down',
                          onPressed: () {
                            HapticFeedback.lightImpact();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Swipe up for next recipe',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: widget.selectedFontSize * 0.7,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccessibilityButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: widget.accentColor.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: widget.selectedFontSize,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: widget.selectedFontSize * 0.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    final List<Map<String, dynamic>> categories = [
      {'name': 'Breakfast', 'icon': Icons.free_breakfast},
      {'name': 'Quick Meals', 'icon': Icons.timer},
      {'name': 'One-Pot', 'icon': Icons.soup_kitchen},
      {'name': 'No Chopping', 'icon': Icons.do_not_touch},
      {'name': 'Vegetarian', 'icon': Icons.grass},
      {'name': 'Diabetic-Friendly', 'icon': Icons.health_and_safety},
    ];

    final List<RecipeVideoItem> discoverRecipes = List.from(_videos);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Discover Recipes',
          style: TextStyle(
            fontSize: widget.selectedFontSize,
            color: widget.textColor,
          ),
        ),
        backgroundColor: widget.primaryColor,
        automaticallyImplyLeading: false,
        actions: [
          Semantics(
            label: 'Search recipes with voice',
            child: IconButton(
              icon: Icon(
                Icons.mic,
                color: widget.textColor,
                size: widget.selectedFontSize * 1.2,
              ),
              onPressed: () {
                HapticFeedback.mediumImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Voice search coming soon!')),
                );
              },
              tooltip: 'Search recipes with voice',
            ),
          ),
        ],
      ),
      body: Container(
        color: widget.backgroundColor,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: widget.primaryColor),
                ),
                child: TextField(
                  style: TextStyle(
                    fontSize: widget.selectedFontSize,
                    color: widget.textColor,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search recipes...',
                    hintStyle: TextStyle(
                      color: widget.textColor.withOpacity(0.5),
                      fontSize: widget.selectedFontSize,
                    ),
                    icon: Icon(Icons.search, color: widget.accentColor),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: widget.selectedFontSize * 1.1,
                      fontWeight: FontWeight.bold,
                      color: widget.textColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: _buildCategoryItem(
                            categories[index]['name'],
                            categories[index]['icon'],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cooking Time',
                    style: TextStyle(
                      fontSize: widget.selectedFontSize * 1.1,
                      fontWeight: FontWeight.bold,
                      color: widget.textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildFilterChip('Under 15 min'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Under 30 min'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Slow Cook'),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recipes For You',
                    style: TextStyle(
                      fontSize: widget.selectedFontSize * 1.1,
                      fontWeight: FontWeight.bold,
                      color: widget.textColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: discoverRecipes.length,
                    itemBuilder: (context, index) {
                      return _buildRecipeGridItem(discoverRecipes[index]);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String name, IconData icon) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: widget.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: widget.accentColor.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: widget.selectedFontSize * 1.5,
              color: widget.accentColor,
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                fontSize: widget.selectedFontSize * 0.7,
                color: widget.textColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: widget.selectedFontSize * 0.7,
          color: widget.textColor,
        ),
      ),
      backgroundColor: widget.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: widget.accentColor),
      ),
      onSelected: (bool selected) {
        HapticFeedback.selectionClick();
      },
    );
  }

  Widget _buildRecipeGridItem(RecipeVideoItem recipe) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailScreen(
                recipeTitle: recipe.title,
                ingredients: recipe.ingredients,
                steps: recipe.steps,
                primaryColor: widget.primaryColor,
                accentColor: widget.accentColor,
                backgroundColor: widget.backgroundColor,
                textColor: widget.textColor,
                selectedFontSize: widget.selectedFontSize,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: SizedBox(
                height: 120,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      recipe.imagePath,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: IconButton(
                        icon: Icon(
                          Icons.record_voice_over,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Reading recipe aloud...')),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Recipe details
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: TextStyle(
                      fontSize: widget.selectedFontSize * 0.8,
                      fontWeight: FontWeight.bold,
                      color: widget.textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: widget.selectedFontSize * 0.7,
                        color: widget.textColor.withOpacity(0.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        recipe.duration,
                        style: TextStyle(
                          fontSize: widget.selectedFontSize * 0.6,
                          color: widget.textColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      color: widget.backgroundColor,
      child: Center(
        child: Text(
          'Settings',
          style: TextStyle(
            fontSize: widget.selectedFontSize,
            color: widget.textColor,
          ),
        ),
      ),
    );
  }
}
