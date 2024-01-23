import 'package:flutter/material.dart';

class SudokuGrid extends StatefulWidget {
  const SudokuGrid({super.key});

  @override
  _SudokuGridState createState() => _SudokuGridState();
}

class _SudokuGridState extends State<SudokuGrid> {
  List<int> gridValues = List<int>.generate(81, (index) => 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 9,
        ),
        itemCount: 81,
        itemBuilder: (BuildContext context, int index) {
          bool isFirstRow = index < 9; // Check if it's the first row
          bool isFirstColumn = index % 9 == 0; // Check if it's the first column
          bool isThirdOrSixthRow = (index ~/ 9) % 3 == 2; // Check if it's the end of the third or sixth row
          bool isThirdOrSixthColumn = index % 9 % 3 == 2; // Check if it's the end of the third or sixth column
          return InkWell(
            onTap: () async {
              int? selectedNumber = await showDialog<int>(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: const Text('Select a number'),
                    children: List<SimpleDialogOption>.generate(10, (index) {
                      return SimpleDialogOption(
                        onPressed: () {
                          Navigator.pop(context, index);
                        },
                        child: Text(index.toString()),
                      );
                    }),
                  );
                },
              );
              if (selectedNumber != null) {
                setState(() {
                  gridValues[index] = selectedNumber;
                });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                   top: BorderSide(
                    color: Colors.black,
                    width: isFirstRow ? 2.0 : 0.5, // Increase the width if it's the first row
                  ),
                  left: BorderSide(
                    color: Colors.black,
                    width: isFirstColumn ? 2.0 : 0.5, // Increase the width if it's the first column
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
                  gridValues[index] == 0 ? '' : gridValues[index].toString(),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
