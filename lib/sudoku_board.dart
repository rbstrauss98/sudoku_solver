import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:sudoku_solver/solving_algorithm/solver.dart';
import 'package:sudoku_solver/number_picker.dart'; // Replace with your actual package name

import 'solving_algorithm/sudoku.dart';

class SudokuGrid extends StatefulWidget {
  const SudokuGrid({super.key});

  @override
  _SudokuGridState createState() => _SudokuGridState();
}

class _SudokuGridState extends State<SudokuGrid> {
  List<int> gridValues = List<int>.generate(81, (index) => 0);
  List<bool> ifInputValues = List<bool>.generate(81, (index) => false);
  List<int> initialValues = List<int>.generate(81, (index) => 0); 
  String buttonText = 'Solve Puzzle'; 
  Solver solver = Solver(); // Create an instance of the SudokuSolver class

  void solvePuzzle() {
    ifInputValues = gridValues.map((e) => e != 0).toList();
    Tuple2<Sudoku?, String> success = solver.solve(gridValues);
    if (success.item1 != null) {
      Sudoku sudoku = success.item1!; 
      setState(() {
        for (int i = 0; i < 9; i++) {
          for (int j = 0; j < 9; j++) {
            gridValues[i * 9 + j] = sudoku.cells[i][j].value!;
          }
        }
        buttonText = 'Back to input'; 
      });
    } else {
      // clearBoard();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Solving Failed'),
            content: Text(success.item2),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void showInitialValues() {
    setState(() {
      gridValues = List.from(initialValues); // Update gridValues with solutionValues
      buttonText = 'Solve Puzzle'; // Reset the button text
    });
  }

  void clearBoard() {
    setState(() {
      for (int i = 0; i < gridValues.length; i++) {
        gridValues[i] = 0;
        ifInputValues[i] = false;
        initialValues[i] = 0;
      }
      buttonText = 'Solve Puzzle'; // Reset the button text
    });

  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SingleChildScrollView(
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 9,
            ),
            itemCount: 81,
            itemBuilder: (BuildContext context, int index) {
              bool isFirstRow = index < 9; // Check if it's the first row
              bool isFirstColumn =
                  index % 9 == 0; // Check if it's the first column
              bool isThirdOrSixthRow = (index ~/ 9) % 3 ==
                  2; // Check if it's the end of the third or sixth row
              bool isThirdOrSixthColumn = index % 9 % 3 ==
                  2; // Check if it's the end of the third or sixth column
              return InkWell(
                onTap: () async {
                  int? selectedNumber = await showNumberPicker(context);
                  if (selectedNumber != null) {
                    setState(() {
                      gridValues[index] = selectedNumber;
                      ifInputValues[index] = true;
                      initialValues[index] = selectedNumber; 
                    });
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.black,
                        width: isFirstRow
                            ? 2.0
                            : 0.5, // Increase the width if it's the first row
                      ),
                      left: BorderSide(
                        color: Colors.black,
                        width: isFirstColumn
                            ? 2.0
                            : 0.5, // Increase the width if it's the first column
                      ),
                      right: BorderSide(
                        color: Colors.black,
                        width: isThirdOrSixthColumn
                            ? 2.0
                            : 0.5, // Increase the width if it's the end of the third or sixth column
                      ),
                      bottom: BorderSide(
                        color: Colors.black,
                        width: isThirdOrSixthRow
                            ? 2.0
                            : 0.5, // Increase the width if it's the end of the third or sixth row
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      gridValues[index] == 0
                          ? ''
                          : gridValues[index].toString(),
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color:
                              ifInputValues[index] ? Colors.black : Colors.green[700]),
                    ),
                  ),
                ),
              );
            },
            shrinkWrap:
                true, // This makes the GridView.builder take only as much space as it needs
            physics: const NeverScrollableScrollPhysics()),
      ),
      ElevatedButton(
        onPressed: buttonText == 'Solve Puzzle' ? solvePuzzle : showInitialValues, 
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonText == 'Solve Puzzle' ? Colors.green[700] : Colors.green[100], 
          foregroundColor: buttonText == 'Solve Puzzle' ? Colors.white : Colors.green[700],
        ),
        child: Text(buttonText),
      ),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed:
            clearBoard, // Call the clearBoard method when the button is pressed
        style: ElevatedButton.styleFrom(
          backgroundColor:  Colors.green[700],
          foregroundColor:  Colors.white,
        ),
        child: const Text('Clear Board')
      ),
    ]);
  }
}
