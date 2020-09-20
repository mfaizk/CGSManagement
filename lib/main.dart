import 'package:CGSManagement/Authentication/landingScreen.dart';
import 'package:CGSManagement/Authentication/loginScreen.dart';
import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      return Container(
        child: Center(
          child: Column(
            children: [CircularProgressIndicator(), Text('Oops')],
          ),
        ),
      );
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return CircularProgressIndicator();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CGSManagement',
      theme:
          ThemeData(primaryColor: Colors.blue, accentColor: Colors.blueAccent),
      home: LandingScreen(),
    );
  }
}
