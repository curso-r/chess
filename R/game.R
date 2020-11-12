
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

#' Add next move as one branch of the tree
#' @param game A game node
#' @param move Description of a move
#' @param notation Notation used for `move`
#' @param enter Follow move into new branch? Works like `git checkout`
#' @return A game node
#' @export
branch <- function(game, move, notation = c("san", "uci", "xboard"),
                   enter = TRUE) {

  # Get notation
  notation <- match.arg(notation)

  # Parse move in context
  if (notation == "san") {
    move <- game$board()$parse_san(move)
  } else if (notation == "uci") {
    move <- game$board()$parse_uci(move)
  } else if (notation == "xboard") {
    move <- game$board()$parse_xboard(move)
  }

  if (enter) return(game$add_variation(move))
  else return(game$add_variation(move)$parent)
}
