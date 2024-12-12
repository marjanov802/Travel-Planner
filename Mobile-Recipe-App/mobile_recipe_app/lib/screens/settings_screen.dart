import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final Color primaryColor;
  final Color accentColor;
  final Color backgroundColor;
  final Color textColor;
  final double selectedFontSize;

  const SettingsScreen({
    super.key,
    required this.primaryColor,
    required this.accentColor,
    required this.backgroundColor,
    required this.textColor,
    required this.selectedFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: primaryColor,
      ),
      body: Container(
        color: backgroundColor,
        child: Center(
          child: Text(
            'Settings Page',
            style: TextStyle(
              fontSize: selectedFontSize,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
