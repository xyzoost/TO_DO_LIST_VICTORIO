import 'package:flutter/material.dart';
import 'signin_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Laravel Auth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Georgia',
        scaffoldBackgroundColor: Colors.white, // White background
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white, // White app bar
          foregroundColor: Colors.black, // Black icons and text
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Black text
            fontFamily: 'Georgia',
          ),
          iconTheme: IconThemeData(color: Colors.black), // Black icons
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[100], // Light grey background for inputs
          labelStyle: const TextStyle(color: Colors.black), // Black labels
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red), // Red borders
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: Colors.red), // Red focused borders
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, // Red buttons
            foregroundColor: Colors.white, // White text
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Georgia',
            ),
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black), // Black text
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.red, // Red progress indicators
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black, // Black text for text buttons
          ),
        ),
      ),
      home: const SignInPage(),
    );
  }
}
