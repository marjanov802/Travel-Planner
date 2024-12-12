import 'package:flutter/material.dart';

class StepScreen extends StatefulWidget {
  final String recipeTitle;
  final List<String> steps;
  final Color primaryColor;
  final Color accentColor;
  final Color backgroundColor;
  final Color textColor;
  final double selectedFontSize;

  const StepScreen({
    super.key,
    required this.recipeTitle,
    required this.steps,
    required this.primaryColor,
    required this.accentColor,
    required this.backgroundColor,
    required this.textColor,
    required this.selectedFontSize,
  });

  @override
  _StepScreenState createState() => _StepScreenState();
}

class _StepScreenState extends State<StepScreen> {
  int _currentStepIndex = 0;

  void _nextStep() {
    if (_currentStepIndex < widget.steps.length - 1) {
      setState(() {
        _currentStepIndex++;
      });
    } else {
      Navigator.pop(context); // Navigate back to the main menu after last step
    }
  }

  void _previousStep() {
    if (_currentStepIndex > 0) {
      setState(() {
        _currentStepIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final int totalSteps = widget.steps.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Step-by-Step', style: TextStyle(color: widget.textColor)),
        backgroundColor: widget.primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: widget.backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Step Progress Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Step ${_currentStepIndex + 1} of $totalSteps',
                  style: TextStyle(
                    fontSize: widget.selectedFontSize,
                    fontWeight: FontWeight.bold,
                    color: widget.textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: (_currentStepIndex + 1) / totalSteps,
              backgroundColor: widget.backgroundColor.withOpacity(0.5),
              valueColor: AlwaysStoppedAnimation(widget.accentColor),
            ),
            const SizedBox(height: 16),
            // Current Step Card
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                // Explicitly set card color to ensure consistency
                color: widget.primaryColor
                    .withOpacity(0.1), // Consistent with the main menu
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      widget.steps[_currentStepIndex],
                      style: TextStyle(
                        fontSize: widget.selectedFontSize,
                        color: widget.textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Navigation Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _previousStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentStepIndex > 0
                        ? widget.accentColor
                        : widget.backgroundColor.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 24.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Previous',
                    style: TextStyle(
                      fontSize: widget.selectedFontSize * 0.9,
                      color: _currentStepIndex > 0
                          ? widget.textColor
                          : widget.textColor.withOpacity(0.5),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.accentColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 24.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    _currentStepIndex == totalSteps - 1 ? 'Finish' : 'Next',
                    style: TextStyle(
                      fontSize: widget.selectedFontSize * 0.9,
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
