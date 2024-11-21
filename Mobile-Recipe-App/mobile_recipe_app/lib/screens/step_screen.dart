import 'package:flutter/material.dart';

class StepScreen extends StatefulWidget {
  final String recipeTitle;
  final List<String> steps;
  final Color primaryColor;
  final Color backgroundColor;
  final Color textColor;
  final Color accentColor;
  final double selectedFontSize;

  const StepScreen({
    super.key,
    required this.recipeTitle,
    required this.steps,
    required this.primaryColor,
    required this.backgroundColor,
    required this.textColor,
    required this.accentColor,
    required this.selectedFontSize,
  });

  @override
  _StepScreenState createState() => _StepScreenState();
}

class _StepScreenState extends State<StepScreen> {
  int currentStep = 0;

  void _nextStep() {
    if (currentStep < widget.steps.length - 1) {
      setState(() {
        currentStep++;
      });
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  void _finishCooking() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final double progress = (currentStep + 1) / widget.steps.length;
    final int percentage = (progress * 100).toInt();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.recipeTitle,
          style: TextStyle(color: widget.textColor),
        ),
        backgroundColor: widget.primaryColor,
      ),
      body: Container(
        color: widget.backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Progress Bar with Percentage
            Column(
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: widget.primaryColor.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(widget.accentColor),
                ),
                const SizedBox(height: 8),
                Text(
                  '$percentage% Complete',
                  style: TextStyle(
                    fontSize: widget.selectedFontSize * 0.8,
                    fontWeight: FontWeight.bold,
                    color: widget.textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Step Content
            Expanded(
              child: Center(
                child: Text(
                  widget.steps[currentStep],
                  style: TextStyle(
                    fontSize: widget.selectedFontSize + 2,
                    color: widget.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Navigation Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Previous Button
                if (currentStep > 0)
                  ElevatedButton(
                    onPressed: _previousStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.primaryColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 24.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.arrow_back),
                        SizedBox(width: 8),
                        Text('Previous'),
                      ],
                    ),
                  ),
                // Next or Finish Button
                ElevatedButton(
                  onPressed: currentStep == widget.steps.length - 1
                      ? _finishCooking
                      : _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.accentColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 24.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        currentStep == widget.steps.length - 1
                            ? 'Finish'
                            : 'Next',
                      ),
                      const SizedBox(width: 8),
                      Icon(currentStep == widget.steps.length - 1
                          ? Icons.check
                          : Icons.arrow_forward),
                    ],
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
