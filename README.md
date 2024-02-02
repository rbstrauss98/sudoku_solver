# sudoku_solver

This is a simple sudoku solver app using a backtracking search that solves a puzzle by treating it as a Constraint Satisfaction Problem.

In an iteration of the backtracking search, a variable is selected using the Minimum Remaining Values heuristic. In cases of a tie, the Maximum Degree heuristic was used. If there continues to be a tie the smallest number would be chosen. After the variable is chosen, its domain would be ordered using the Least-Constraining Value heuristic. The algorithm then will attempt to assign the first value in the variable's domain into the variable, and a copy of the original puzzle is created, but including the most recent variable's assignment. If this succeeds, backtracking is recursively called again with the new puzzle until the puzzle is solved. If an assignment of a value does not succeed, it will then in order try to assign the values from its domain until there it succeeds. If it exhausts all its options the backtracking search will retun null, and the process goes back. At the end of the recursion, if no solution is found, an error message will pop up.





