import 'package:flutter/material.dart';
import 'screens/launch_screen.dart'; // Importing the launch screen

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cooking Recipes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LaunchScreen(), // Launch screen as the initial screen
      debugShowCheckedModeBanner: false,
    );
  }
}
