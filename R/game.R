
#' Start a game
#' @return A game node
#' @export
game <- function() {
  chess$pgn$Game()
}

#' Advance in the game tree
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

#' Go back in the game tree
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

#' Get all variations for next move
#' @param game A game node
#' @return A list of games nodes
#' @export
variations <- function(game) {
  vars <- game$variations
  class(vars) <- c(class(vars), "chess.pgn.Variations")

  vars
}

#' Follow variation of a move
#' @param game A game node
#' @param id Index of variation (1 is the mainline)
#' @return A game node
#' @export
variation <- function(game, id = 1) {
  purrr::chuck(game$variations, id)
}
