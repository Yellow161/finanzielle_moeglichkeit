
import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const FinanzielleMoeglichkeitApp());
}

class FinanzielleMoeglichkeitApp extends StatelessWidget {
  const FinanzielleMoeglichkeitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finanzielle Möglichkeit',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const HomeScreen(),
    );
  }
}
