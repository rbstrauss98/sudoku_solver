import 'package:flutter/material.dart';
import 'package:sudoku_solver/pages/HomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku Solver',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(0, 0, 89, 69),
        ),
      ),
      home: const MyHomePage(title: 'Sudoku Solver'),
    );
  }
}
