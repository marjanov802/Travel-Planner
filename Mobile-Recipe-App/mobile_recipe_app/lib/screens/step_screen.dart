import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'accessibility_controller.dart';

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
  final AccessibilityController _accessibilityController =
      AccessibilityController();

  // Font size helpers
  double get _headerSize => widget.selectedFontSize * 1.2;
  double get _normalSize => widget.selectedFontSize;
  double get _buttonSize => widget.selectedFontSize * 0.9;
  bool get _isLargeFont => widget.selectedFontSize >= 30.0;

  @override
  void initState() {
    super.initState();

    // Announce first step on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _announceCurrentStep();
    });
  }

  void _announceCurrentStep() {
    if (_accessibilityController.voiceOverEnabled) {
      _accessibilityController.speak(
          "Step ${_currentStepIndex + 1} of ${widget.steps.length}. ${widget.steps[_currentStepIndex]}");
    }

    if (_accessibilityController.captionsEnabled) {
      _accessibilityController.updateCaption(
          "Step ${_currentStepIndex + 1}: ${widget.steps[_currentStepIndex]}",
          context);
    }
  }

  void _nextStep() {
    HapticFeedback.mediumImpact();

    if (_currentStepIndex < widget.steps.length - 1) {
      setState(() {
        _currentStepIndex++;
      });
      _announceCurrentStep();
    } else {
      // Last step completed
      if (_accessibilityController.voiceOverEnabled) {
        _accessibilityController
            .speak("Recipe complete! Returning to ingredients.");
      }
      Navigator.pop(context);
    }
  }

  void _previousStep() {
    HapticFeedback.mediumImpact();

    if (_currentStepIndex > 0) {
      setState(() {
        _currentStepIndex--;
      });
      _announceCurrentStep();
    } else {
      // First step - can't go back further
      if (_accessibilityController.voiceOverEnabled) {
        _accessibilityController.speak("This is the first step.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final int totalSteps = widget.steps.length;

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
          maxLines: 1,
        ),
        backgroundColor: widget.primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            HapticFeedback.mediumImpact();
            Navigator.pop(context);
          },
          tooltip: "Return to ingredients",
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Step progress indicator
              _buildProgressIndicator(totalSteps),

              // Current step display
              Expanded(
                child: _buildStepCard(),
              ),

              // Navigation buttons
              _buildNavigationButtons(totalSteps),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(int totalSteps) {
    return Column(
      children: [
        // Header with step count
        Semantics(
          label: "Step ${_currentStepIndex + 1} of $totalSteps",
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
              color: widget.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Step ${_currentStepIndex + 1} of $totalSteps',
              style: TextStyle(
                fontSize: _headerSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        SizedBox(height: 16),

        // Progress bar
        Container(
          height: _isLargeFont ? 16 : 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: widget.primaryColor,
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: (_currentStepIndex + 1) / totalSteps,
              backgroundColor: widget.backgroundColor,
              valueColor: AlwaysStoppedAnimation(widget.accentColor),
              minHeight: _isLargeFont ? 14 : 10,
            ),
          ),
        ),

        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildStepCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: widget.primaryColor,
          width: 2,
        ),
      ),
      color: widget.primaryColor.withOpacity(0.1),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(_isLargeFont ? 24 : 20),
        child: Column(
          children: [
            // Step title
            Text(
              "Step ${_currentStepIndex + 1}",
              style: TextStyle(
                fontSize: _headerSize,
                fontWeight: FontWeight.bold,
                color: widget.textColor,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 20),

            // Step instructions - in a scrollable container if text is long
            Text(
              widget.steps[_currentStepIndex],
              style: TextStyle(
                fontSize: _normalSize,
                color: widget.textColor,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(int totalSteps) {
    final isFirstStep = _currentStepIndex == 0;
    final isLastStep = _currentStepIndex == totalSteps - 1;

    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Previous button
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: ElevatedButton.icon(
                onPressed: isFirstStep ? null : _previousStep,
                icon: Icon(
                  Icons.arrow_back,
                  size: _isLargeFont ? 28 : 24,
                  color: isFirstStep ? Colors.grey : Colors.white,
                ),
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Previous Step',
                    style: TextStyle(
                      fontSize: _buttonSize,
                      fontWeight: FontWeight.bold,
                      color: isFirstStep ? Colors.grey : Colors.white,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isFirstStep ? Colors.grey.shade300 : widget.primaryColor,
                  padding: EdgeInsets.symmetric(
                    vertical: _isLargeFont ? 20 : 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: isFirstStep ? 0 : 4,
                ),
              ),
            ),
          ),

          // Next/Finish button
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 8),
              child: ElevatedButton.icon(
                onPressed: _nextStep,
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    isLastStep ? 'Finish Recipe' : 'Next Step',
                    style: TextStyle(
                      fontSize: _buttonSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                icon: Icon(
                  isLastStep ? Icons.check_circle : Icons.arrow_forward,
                  size: _isLargeFont ? 28 : 24,
                  color: Colors.white,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.accentColor,
                  padding: EdgeInsets.symmetric(
                    vertical: _isLargeFont ? 20 : 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
