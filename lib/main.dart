import 'package:flutter/material.dart';
import 'screens/swipe_screen.dart';

void main() {
  runApp(const MusifyApp());
}

class MusifyApp extends StatelessWidget {
  const MusifyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Musify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.purple.shade50,
      ),
      home: SwipeScreen(),
    );
  }
}
