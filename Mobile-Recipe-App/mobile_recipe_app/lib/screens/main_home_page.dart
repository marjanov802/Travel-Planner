import 'package:flutter/material.dart';

class MainHomePage extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color backgroundColor;
  final Color textColor;
  final double selectedFontSize;

  const MainHomePage({
    super.key,
    required this.primaryColor,
    required this.secondaryColor,
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
          'Home',
          style: TextStyle(fontSize: selectedFontSize, color: textColor),
        ),
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false, // This removes the back button
      ),
      body: Container(
        color: backgroundColor, // Set the background color
        child: Center(
          child: Text(
            'Welcome to the Home Page!',
            style: TextStyle(fontSize: selectedFontSize, color: textColor),
          ),
        ),
      ),
    );
  }
}
