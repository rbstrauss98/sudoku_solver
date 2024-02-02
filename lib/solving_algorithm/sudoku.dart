import 'cell.dart';
class Sudoku {
  List<List<Cell>> cells = List.generate(9, (i) => List.generate(9, (j) => Cell()));

  void copyPuzzle(Sudoku other) {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9;j++) {
        cells[i][j].copyCell(other.cells[i][j]);
      }
    }
  }

  String puzzleToString() {
    String outputString = '';
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9;c++) {
        if (cells[r][c].value != 0 && cells[r][c].value != null) {
          outputString += cells[r][c].value.toString();
        } else {
          outputString += '.';
        }
      }
    }
    return outputString;
  }

  bool isSolved() {
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9;c++) {
        if (cells[r][c].value == null) {
          return false;
        }
      }
    }
    return true;
  }

  bool inputPuzzle(List<int> puzzleList) {
    int r = 0;
    int c = 0;
    for (int v in puzzleList) {
      if (v != 0) {
        cells[r][c].assignValue(v);
      }
      c++;
      if (c > 8) {
        c = 0;
        r++;
      }
    }
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9;c++) {
        if (cells[r][c].value != null) {
          bool success = forwardCheckRemove(r, c, cells[r][c].value!, isInitial: true);
          if (!success) {
            return false;
          }
        }
      }
    }
    return true;
  }

  bool forwardCheckRemove(int row, int col, int value, {bool isInitial = false}){
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9;j++) {
        if (i == row || j == col) {
          if (cells[i][j].value == null) {
            if (!cells[i][j].removeValue(value)) {
              return false;
            }
          }
          else if (isInitial && !(i == row && j == col) && cells[i][j].value == value) {
            return false;
          }
        } 
      }
    }
    int gridRow = 3 * (row ~/ 3);
    int gridColumn = 3 * (col ~/ 3);
    for (int i = gridRow; i < gridRow + 3; i++) {
      for (int j = gridColumn; j < gridColumn + 3; j++) {
        if (cells[i][j].value == null) {
          if (!cells[i][j].removeValue(value)) {
            return false;
          }
        }
        else if (isInitial && !(i == row && j == col) && cells[i][j].value == value) {
          return false;
        }
      }
    }
    return true;
  }

  int forwardCheckCount(int row, int col, int value){
    int count = 0;
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (i == row || j == col) {
          if (cells[i][j].value == null) {
            if (cells[i][j].domain.contains(value)) {
              count += 1;
            }
          }
        }
      }
    }
    int gridRow = 3 * (row ~/ 3);
    int gridColumn = 3 * (col ~/ 3);
    for (int i = gridRow; i < gridRow + 3; i++) {
      for (int j = gridColumn; j < gridColumn + 3; j++) {
        if (cells[i][j].value == null) {
          if (cells[i][j].domain.contains(value)) {
            count += 1;
          }
        }
      }
    }
    return count;
  }

  List<int> getRowColumn(int grid, int cell) {
    int baseR = 3 * (grid ~/ 3);
    int baseC = 3 * (grid % 3);
    int offR = cell ~/ 3;
    int offC = cell % 3;
    return [baseR + offR, baseC + offC];
  }

  List<int> getGridCell(int row, int column) {
    int grid = 3 * (row ~/ 3) + (column ~/ 3);
    int baseR = 3 * (grid ~/ 3);
    int baseC = 3 * (grid % 3);
    int offR = row - baseR;
    int offC = column - baseC;
    int cell = 3 * (offR) + (offC);
    return [grid, cell];
  }
}
