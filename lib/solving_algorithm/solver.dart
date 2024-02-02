import 'package:tuple/tuple.dart';
import 'sudoku.dart';

class Solver {
  List<List<int>> mrv(Sudoku puzzle, List<List<int>> unassigned) {
    int min = 1000;
    List<List<int>> mrvList = [];
    for (List<int> cell in unassigned) {
      List<int> cellDomains = puzzle.cells[cell[0]][cell[1]].domain;
      if (cellDomains.length < min) {
        min = cellDomains.length;
        mrvList = [cell];
      }
      else if (cellDomains.length == min) {
        mrvList.add(cell);
      }
    }
    return mrvList;
  }

  List<List<int>> maxDegree(Sudoku puzzle, List<List<int>> tied) {
    int max = 0;
    List<List<int>> maxDegreeList = [];
    for (List<int> cell in tied) {
      int cur = countConstraints(puzzle, cell[0], cell[1]);
      if (cur > max) {
        max = cur;
        maxDegreeList = [cell];
      }
      else if (cur == max) {
        maxDegreeList.add(cell);
      }
      
    }
    return maxDegreeList;
  }

  int countConstraints(Sudoku puzzle, int row, int column) {
    int count = 0;
    List<int> gridCell = puzzle.getGridCell(row, column);
    int grid = gridCell[0];
    List<int> gridRows = [];
    List<int> gridColumns = [];
    if (grid == 0 || grid == 1 || grid == 2) {
      gridRows = [0, 1, 2];
    }
    if (grid == 3 || grid == 4 || grid == 5) {
      gridRows = [3, 4, 5];
    }
    if (grid == 6 || grid == 7 || grid == 8) {
      gridRows = [6, 7, 8];
    }
    if (grid == 0 || grid == 3 || grid == 6) {
      gridColumns = [0, 1, 2];
    }
    if (grid == 1 || grid == 4 || grid == 7) {
      gridColumns = [3, 4, 5];
    }
    if (grid == 2 || grid == 5 || grid == 8) {
      gridColumns = [6, 7, 8];
    }
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (r == row || c == column) {
          if (puzzle.cells[r][c].value == null && !(r == row && c == column)) {
            count++;
          }
        } else if (gridRows.contains(r) && gridColumns.contains(c)) {
          if (puzzle.cells[r][c].value == null) {
            count++;
          }
        }
      }
    }
    return count;
  }

  getUnassignedVariables(Sudoku puzzle) {
    List<List<int>> unassigned = [];
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (puzzle.cells[r][c].value == null) {
          unassigned.add([r, c]);
        }
      }
    }
    return unassigned;
  }

  List<int> selectVariable(Sudoku puzzle) {
    List<List<int>> unassigned = getUnassignedVariables(puzzle);
    List<List<int>> minimumRemainingValues = mrv(puzzle, unassigned);
    if (minimumRemainingValues.length == 1) {
      return minimumRemainingValues[0];
    }
    List<List<int>> mostConstrainingVariables =
        maxDegree(puzzle, minimumRemainingValues);
    return mostConstrainingVariables[0];
  }

  List<int> orderValues(Sudoku puzzle, int row, int column) {
    List<int> domain = puzzle.cells[row][column].domain;

    List<Tuple2<int, int>> domainWithCounts = domain.map((value) {
      int count = puzzle.forwardCheckCount(row, column, value);
      return Tuple2<int, int>(value, count);
    }).toList();
    domainWithCounts.sort((a, b) => a.item2.compareTo(b.item2));
    List<int> orderedDomain = domainWithCounts.map((tuple) => tuple.item1).toList();
    return orderedDomain;
  }

  Sudoku? backtrackingSearch(Sudoku puzzle) {
    if (puzzle.isSolved()) {
      return puzzle;
    }
    List<int> variable = selectVariable(puzzle);
    List<int> values = orderValues(puzzle, variable[0], variable[1]);
    for (int value in values) {
      Sudoku newPuzzle = Sudoku();
      newPuzzle.copyPuzzle(puzzle);
      newPuzzle.cells[variable[0]][variable[1]].assignValue(value);
      bool success = newPuzzle.forwardCheckRemove(variable[0], variable[1], value);
      if (!success) {
        continue;
      } else {
        Sudoku? solvedPuzzle = backtrackingSearch(newPuzzle);
        if (solvedPuzzle != null) {
          return solvedPuzzle;
        } else {
          continue;
        }
      }
    }
    return null;
  }

  Tuple2<Sudoku?, String> solve(List<int> puzzleValues) {
    Sudoku puzzle = Sudoku();
    bool validInput = puzzle.inputPuzzle(puzzleValues);
    if (!validInput) {
      return const Tuple2<Sudoku?, String>(null, "This is an invalid Input. Please try again.");
    }
    Sudoku? solvedPuzzle = backtrackingSearch(puzzle);
    if (solvedPuzzle != null) {
      return Tuple2<Sudoku?, String>(solvedPuzzle, "Solved");
    }
    else{
      return const Tuple2<Sudoku?, String>(null, "Puzzle has no solution. Please try again.");
    }
  }
}
