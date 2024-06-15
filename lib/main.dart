import 'package:flutter/material.dart';
import 'package:sendyakala/screens/splash_screen.dart';  // Import the SplashScreen

void main() {
  runApp(const SendyakalaApp());
}

class SendyakalaApp extends StatelessWidget {
  const SendyakalaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sendyakala',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.amber),
        fontFamily: 'Georgia',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: const SplashScreen(),  // SplashScreen is the initial screen
    );
  }
}
