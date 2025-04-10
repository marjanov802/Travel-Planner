import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'step_screen.dart';
import 'accessibility_controller.dart';

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
  final AccessibilityController _accessibilityController =
      AccessibilityController();
  bool _viewingIngredients = true;

  // Font size helpers
  double get _headerSize => widget.selectedFontSize * 1.2;
  double get _normalSize => widget.selectedFontSize;
  double get _buttonSize => widget.selectedFontSize * 0.9;
  bool get _isLargeFont => widget.selectedFontSize >= 30.0;

  @override
  void initState() {
    super.initState();
    _checkedIngredients = List<bool>.filled(widget.ingredients.length, false);

    // Announce screen on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _announceScreen();
    });
  }

  void _announceScreen() {
    if (_accessibilityController.voiceOverEnabled) {
      _accessibilityController.speak("Recipe for ${widget.recipeTitle}. "
          "You are viewing the ingredients list. "
          "Tap ingredients to check them off.");
    }
  }

  void _toggleIngredientCheck(int index) {
    HapticFeedback.selectionClick();
    setState(() {
      _checkedIngredients[index] = !_checkedIngredients[index];
    });

    if (_accessibilityController.voiceOverEnabled) {
      _accessibilityController.speak(
          "${widget.ingredients[index]} ${_checkedIngredients[index] ? 'checked' : 'unchecked'}");
    }
  }

  void _toggleSelectAll() {
    HapticFeedback.mediumImpact();
    final allSelected = _checkedIngredients.every((checked) => checked);
    setState(() {
      _checkedIngredients =
          List<bool>.filled(widget.ingredients.length, !allSelected);
    });

    if (_accessibilityController.voiceOverEnabled) {
      _accessibilityController.speak(allSelected
          ? "All ingredients unchecked"
          : "All ingredients checked");
    }
  }

  void _navigateToSteps() {
    HapticFeedback.mediumImpact();

    if (_accessibilityController.voiceOverEnabled) {
      _accessibilityController.speak(
          "Starting step by step cooking instructions for ${widget.recipeTitle}");
    }

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

  void _toggleView() {
    HapticFeedback.mediumImpact();
    setState(() {
      _viewingIngredients = !_viewingIngredients;
    });

    if (_accessibilityController.voiceOverEnabled) {
      if (_viewingIngredients) {
        _accessibilityController.speak(
            "Showing ingredients list. ${widget.ingredients.length} ingredients.");
      } else {
        _accessibilityController.speak(
            "Showing cooking steps. ${widget.steps.length} steps to follow.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        title: Text(
          widget.recipeTitle,
          style: TextStyle(
            color: Colors.white,
            fontSize: _isLargeFont ? 24 : 20,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        backgroundColor: widget.primaryColor,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // View Toggle Buttons
            Container(
              color: widget.primaryColor.withOpacity(0.1),
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: _buildToggleButton(
                      title: "Ingredients",
                      icon: Icons.shopping_basket,
                      isSelected: _viewingIngredients,
                      onPressed: _viewingIngredients ? null : _toggleView,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildToggleButton(
                      title: "Steps",
                      icon: Icons.menu_book,
                      isSelected: !_viewingIngredients,
                      onPressed: _viewingIngredients ? _toggleView : null,
                    ),
                  ),
                ],
              ),
            ),

            // Main content area
            Expanded(
              child: _viewingIngredients
                  ? _buildIngredientsView()
                  : _buildStepsView(),
            ),

            // Bottom Action Button
            Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                height: _isLargeFont ? 70 : 60,
                child: ElevatedButton.icon(
                  onPressed: _navigateToSteps,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.accentColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    elevation: 4,
                  ),
                  icon: Icon(
                    Icons.play_arrow,
                    size: _isLargeFont ? 32 : 28,
                  ),
                  label: Text(
                    'Start Cooking',
                    style: TextStyle(
                      fontSize: _buttonSize,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: _isLargeFont ? 28 : 24,
        color: isSelected ? Colors.white : widget.primaryColor,
      ),
      label: Text(
        title,
        style: TextStyle(
          fontSize: _buttonSize,
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.white : widget.primaryColor,
        ),
        overflow: TextOverflow.visible,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? widget.primaryColor : Colors.white,
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: widget.primaryColor,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildIngredientsView() {
    return Column(
      children: [
        // Title and Actions
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Ingredients',
                style: TextStyle(
                  fontSize: _headerSize,
                  fontWeight: FontWeight.bold,
                  color: widget.textColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _toggleSelectAll,
                icon: Icon(Icons.select_all, size: _isLargeFont ? 28 : 24),
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    _checkedIngredients.every((checked) => checked)
                        ? 'Uncheck All Items'
                        : 'Check All Items',
                    style: TextStyle(
                      fontSize: _buttonSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Ingredients List
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: widget.ingredients.length,
            itemBuilder: (context, index) {
              return _buildIngredientItem(index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientItem(int index) {
    final isChecked = _checkedIngredients[index];

    return Semantics(
      checked: isChecked,
      label: "Ingredient ${index + 1}: ${widget.ingredients[index]}",
      child: Card(
        margin: EdgeInsets.only(bottom: 12),
        elevation: 2,
        color: isChecked
            ? widget.accentColor.withOpacity(0.15)
            : widget.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isChecked
                ? widget.accentColor
                : widget.primaryColor.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: InkWell(
          onTap: () => _toggleIngredientCheck(index),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom Checkbox
                Container(
                  width: _isLargeFont ? 32 : 28,
                  height: _isLargeFont ? 32 : 28,
                  margin: EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    color: isChecked ? widget.accentColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          isChecked ? widget.accentColor : widget.primaryColor,
                      width: 2,
                    ),
                  ),
                  child: isChecked
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                          size: _isLargeFont ? 24 : 20,
                        )
                      : null,
                ),
                SizedBox(width: 16),

                // Ingredient Text
                Expanded(
                  child: Text(
                    widget.ingredients[index],
                    style: TextStyle(
                      fontSize: _normalSize,
                      color: widget.textColor,
                      decoration: isChecked ? TextDecoration.lineThrough : null,
                      decorationThickness: 2,
                      height: 1.3,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepsView() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: widget.steps.length,
      itemBuilder: (context, index) {
        return _buildStepItem(index);
      },
    );
  }

  Widget _buildStepItem(int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: widget.primaryColor.withOpacity(0.1),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step number
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: widget.primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Step ${index + 1}",
                style: TextStyle(
                  fontSize: _buttonSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 12),

            // Step instructions
            Text(
              widget.steps[index],
              style: TextStyle(
                fontSize: _normalSize,
                color: widget.textColor,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
