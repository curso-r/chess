
#' Create a new game
#'
#' @description A game is a tree with nodes, where each node represents the
#' board after a move and each branch represents a variation of the game (not
#' to be confused with a variant of chess). This tree mirrors the
#' [PGN](https://en.wikipedia.org/wiki/Portable_Game_Notation) of the game.
#'
#' To explore a game, an object of this class supports [print()], [plot()],
#' [str()], [fen()], [pgn()] and more.
#'
#' @param headers A named list like `list("Header1" = "Value1", ...)`
#' @param fen FEN representing the starting position of the board
#'
#' @return A game root node
#' @export
game <- function(headers = NULL, fen = NULL) {
  x <- chess_env$chess_pgn$Game(headers = headers)
  if (!is.null(fen)) {
    x$setup(fen)
  }

  return(x)
}

#' Advance in the game tree, playing next move from current branch
#' @param game A game node
#' @param steps How many steps (half-turns) to advance
#' @return A game node
#' @export
forward <- function(game, steps = 1) {
  for (i in seq_len(steps)) {
    game <- game$`next`()
  }
  game
}

#' Go back in the game tree, reverting the last move from current branch
#' @param game A game node
#' @param steps How many steps (half-turns) to go back
#' @return A game node
#' @export
back <- function(game, steps = 1) {
  for (i in seq_len(steps)) {
    game <- game$parent
  }
  game
}

#' Get all variations for next move (the children of current node)
#' @param game A game node
#' @return A list of games nodes
#' @export
variations <- function(game) {
  vars <- game$variations
  class(vars) <- c(class(vars), "chess.pgn.Variations")

  vars
}

#' Follow variation of a move, playing its first move
#' @param game A game node
#' @param id Index of variation (1 is the current branch)
#' @return A game node
#' @export
variation <- function(game, id = 1) {
  purrr::chuck(game$variations, id)
}

#' Get the root node of a game
#' @param game A game node
#' @return A game node
#' @export
root <- function(game) {
  game$root()
}
