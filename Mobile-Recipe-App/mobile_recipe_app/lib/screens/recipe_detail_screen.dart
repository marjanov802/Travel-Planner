import 'package:flutter/material.dart';
import 'step_screen.dart';

class RecipeDetailScreen extends StatefulWidget {
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

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late List<bool> _checkedIngredients;

  @override
  void initState() {
    super.initState();
    _checkedIngredients = List<bool>.filled(widget.ingredients.length, false);
  }

  void _toggleSelectAll() {
    final allSelected = _checkedIngredients.every((isChecked) => isChecked);
    setState(() {
      _checkedIngredients =
          List<bool>.filled(widget.ingredients.length, !allSelected);
    });
  }

  void _navigateToSteps() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StepScreen(
          recipeTitle: widget.recipeTitle,
          steps: widget.steps,
          primaryColor: widget.primaryColor,
          accentColor: widget.accentColor,
          backgroundColor: widget.backgroundColor,
          textColor: widget.textColor,
          selectedFontSize: widget.selectedFontSize,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.recipeTitle, style: TextStyle(color: widget.textColor)),
        backgroundColor: widget.primaryColor,
      ),
      body: Container(
        color: widget.backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Ingredients',
              style: TextStyle(
                fontSize: widget.selectedFontSize + 4,
                fontWeight: FontWeight.bold,
                color: widget.textColor,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: widget.ingredients.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    color: widget.primaryColor.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      child: Row(
                        children: [
                          Checkbox(
                            activeColor: widget.accentColor,
                            value: _checkedIngredients[index],
                            onChanged: (bool? value) {
                              setState(() {
                                _checkedIngredients[index] = value ?? false;
                              });
                            },
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              widget.ingredients[index],
                              style: TextStyle(
                                fontSize: widget.selectedFontSize,
                                color: widget.textColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _toggleSelectAll,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.accentColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 24.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    _checkedIngredients.every((isChecked) => isChecked)
                        ? 'Unselect All'
                        : 'Select All',
                    style: TextStyle(
                      fontSize: widget.selectedFontSize * 0.9,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _navigateToSteps,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.accentColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 24.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Start Cooking',
                    style: TextStyle(
                      fontSize: widget.selectedFontSize * 0.9,
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
