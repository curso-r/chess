
#' Start a new game
#' @return A board
#' @export
game <- function() {
  b <- chess$Board()
  # class(b) <- c("game", class(b))
  return(b)
}

#' Move a piece on the board
#' @param board A board
#' @param move Description of a move
#' @param notation Notation used for `move`
#' @return A board
#' @export
move <- function(board, move, notation = c("san", "uci", "xboard")) {

  # # Can't move a piece if it's not a game
  # stopifnot("game" %in% class(board))

  # Get notation
  notation <- match.arg(notation)

  # Move piece
  if (notation == "san") {
    board$push_san(move)
  } else if (notation == "uci") {
    board$push_uci(move)
  } else if (notation == "xboard") {
    board$push_xboard(move)
  }

  if (board$is_valid()) {
    return(board)
  } else {
    stop("Invalid move")
  }
}

#' Undo last move
#' @param board A board
#' @return A board
undo <- function(board) {
  board$pop()
  board
}

#' Check board for checkmate
#' @param board A board
#' @return A boolean
#' @export
is_checkmate <- function(board) {
  board$is_checkmate()
}

#' Get FEN representation of board
#' @param board A board
#' @return A string
#' @export
fen <- function(board) {
  board$fen()
}
