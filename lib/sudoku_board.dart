import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:sudoku_solver/solving_algorithm/solver.dart';
import 'package:sudoku_solver/number_picker.dart'; // Replace with your actual package name
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:async';
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
  bool isLoading = false;
  
  static void solveSudokuIsolate(Map<String, dynamic> args) {
    SendPort sendPort = args['sendPort'];
    List<int> gridValues = args['gridValues'];
    Solver solver = Solver();
    Tuple2<Sudoku?, String> result = solver.solve(gridValues);
    sendPort.send(Tuple2(result.item1?.toMap(), result.item2));
  }
  void solvePuzzle() async {
    final Completer<void> showDialogCompleter = Completer<void>();
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 1000));

    ifInputValues = gridValues.map((e) => e != 0).toList();

    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(solveSudokuIsolate, {
      'sendPort': receivePort.sendPort,
      'gridValues': gridValues,
    });

    final Tuple2<Map<String, dynamic>?, String> result = await receivePort.first;
    final Tuple2<Sudoku?, String> success = Tuple2(result.item1 != null ? Sudoku.fromMap(result.item1!) : null, result.item2);

    if (success.item1 != null) {
      Sudoku sudoku = success.item1!;
      setState(() {
        for (int i = 0; i < 9; i++) {
          for (int j = 0; j < 9; j++) {
            gridValues[i * 9 + j] = sudoku.cells[i][j].value!;
          }
        }
        buttonText = 'Back to input';
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      showDialogCompleter.complete();
    }

    await showDialogCompleter.future;
    if (context.mounted) {
      Future.microtask(() {
        showDialog(
          context: context,
          builder: (BuildContext dialog) {
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
      });
    }
  }

  void showInitialValues() {
    setState(() {
      gridValues =
          List.from(initialValues); // Update gridValues with solutionValues
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
    return Stack(
      children: [
        Column(children: [
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
                    onTap: buttonText == 'Solve Puzzle'
                        ? () async {
                            int? selectedNumber =
                                await showNumberPicker(context);
                            if (selectedNumber != null) {
                              setState(() {
                                gridValues[index] = selectedNumber;
                                ifInputValues[index] = true;
                                initialValues[index] = selectedNumber;
                              });
                            }
                          }
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        // color: ifInputValues[index] ? Colors.white : Colors.green[100],
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
                              color: ifInputValues[index]
                                  ? Colors.black
                                  : Colors.green[500]),
                        ),
                      ),
                    ),
                  );
                },
                shrinkWrap:
                    true, // This makes the GridView.builder take only as much space as it needs
                physics: const NeverScrollableScrollPhysics()),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 250.0,
            child: ElevatedButton(
              onPressed: buttonText == 'Solve Puzzle'
                  ? solvePuzzle
                  : showInitialValues,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonText == 'Solve Puzzle'
                    ? Theme.of(context).colorScheme.primary
                    : Colors.green[100],
                foregroundColor: buttonText == 'Solve Puzzle'
                    ? Colors.white
                    : Theme.of(context).colorScheme.primary,
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: buttonText == "Solve Puzzle"
                          ? buttonText
                          : "$buttonText  ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: buttonText == 'Solve Puzzle'
                            ? Colors.white
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    if (buttonText !=
                        'Solve Puzzle') // Only render the WidgetSpan if buttonText is 'Solve Puzzle'
                      const WidgetSpan(
                        child: Icon(Icons.undo, size: 16),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 250.0,
            child: ElevatedButton(
              onPressed: clearBoard,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Clear Board',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ]),
        if (isLoading) // Show a loading indicator when isLoading is true
          Container(
            color: Colors.white,
            child: Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                size: 75,
                color: Theme.of(context).colorScheme.primary,
              ), // Loading indicator
            ),
          ),
      ],
    );
  }
}
