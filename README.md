# sudoku_solver

This is a simple sudoku solver app using a backtracking search that solves a puzzle by treating it as a Constraint Satisfaction Problem.

In an iteration of the backtracking search, a variable is selected using the Minimum Remaining Values heuristic. In cases of a tie, the Maximum Degree heuristic was used. If there continues to be a tie the smallest number would be chosen. After the variable is chosen, its domain would be ordered using the Least-Constraining Value heuristic. The algorithm then will attempt to assign the first value in the variable's domain into the variable, and a copy of the original puzzle is created, but including the most recent variable's assignment. If this succeeds, backtracking is recursively called again with the new puzzle until the puzzle is solved. If an assignment of a value does not succeed, it will then in order try to assign the values from its domain until there it succeeds. If it exhausts all its options the backtracking search will retun null, and the process goes back. At the end of the recursion, if no solution is found, an error message will pop up.

<img src="https://github.com/rbstrauss98/sudoku_solver/assets/86329701/35dd330b-d87e-4e29-89ee-4b984c8a8bfb" width=240 height=560>

<img src="https://github.com/rbstrauss98/sudoku_solver/assets/86329701/af12fd16-be8a-4dac-9c0f-2d42a619a913" width=240 height=560>

<img src="https://github.com/rbstrauss98/sudoku_solver/assets/86329701/1fb58f58-0387-40d6-9dc3-2d0dcc22a63a" width=240 height=560>

<img src="https://github.com/rbstrauss98/sudoku_solver/assets/86329701/8cbaa734-e802-403d-b77c-94c65b43b4bf" width=240 height=560>

