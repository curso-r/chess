
#' Advance in the game tree
#' @param game A game
#' @param steps How many steps (half-turns) to advance
#' @return A game
#' @export
forward <- function(game, steps = 1) {
  for (i in seq_len(steps)) {
    game <- game$`next`()
  }
  game
}

#' Advance in the game tree
#' @param game A game
#' @param steps How many steps (half-turns) to go back
#' @return A game
#' @export
back <- function(game, steps = 1) {
  for (i in seq_len(steps)) {
    game <- game$parent
  }
  game
}

#' Get variations of a move
#' @param game A game
#' @return A list of games
#' @export
variations <- function(game) {
  vars <- game$variations
  class(vars) <- c(class(vars), "chess.pgn.Variations")

  vars
}
