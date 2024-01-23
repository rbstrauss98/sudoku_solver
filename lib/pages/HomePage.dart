import 'package:flutter/material.dart';
import 'package:sudoku_solver/sudoku_board.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  
  final String title;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.0), // Set the desired padding value
          child: SudokuGrid(),
        ),
      ),
    );
  }
}
  

