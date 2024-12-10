import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:engv1/utils/splash.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'sign_up.dart';

/*
1. Added error handling for Firebase initialization to catch any issues during app startup.
2. Enhanced the app theme with primary, accent colors, text styles, and button theme for a consistent look.
3. Defined named routes to simplify navigation between screens (e.g., Splash and SignUp pages).
4. Included comments and organized the code for better readability and maintainability.
*/ 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Error handling during Firebase initialization
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
  
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the debug banner
      theme: ThemeData(
        primaryColor: Colors.blue[900], // Main app color
        accentColor: Colors.orange, // Highlight color
        textTheme: const TextTheme(
          bodyText1: TextStyle(fontSize: 16.0, color: Colors.black),
          bodyText2: TextStyle(fontSize: 14.0, color: Colors.black54),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue[900], // Button color
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      // Define the initial page
      home: const Splash(),
      // Define named routes for navigation
      routes: {
        '/signup': (context) => SignUp(),
      },
    );
  }
}
