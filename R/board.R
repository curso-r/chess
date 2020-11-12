
#' Setup a new board
#' @return A board
#' @export
board <- function() {
  chess$Board()
}

#' Setup an empty board
#' @return A board
#' @export
empty_board <- function() {
  chess$Board$empty()
}

#' Move a piece on the board
#' @param board A board
#' @param move Description of a move
#' @param notation Notation used for `move`
#' @return A board
#' @export
move <- function(board, move, notation = c("san", "uci", "xboard")) {

  # No side effects
  tmp <- board$copy()

  # Get notation
  notation <- match.arg(notation)

  # Move piece
  if (notation == "san") {
    tmp$push_san(move)
  } else if (notation == "uci") {
    tmp$push_uci(move)
  } else if (notation == "xboard") {
    tmp$push_xboard(move)
  }

  tmp
}

#' Undo last move
#' @param board A board
#' @param steps How many moves (half-turns) to revert
#' @return A board
undo <- function(board, steps = 1) {

  # No side effects
  tmp <- board$copy()

  # Pop
  for (i in seq_len(steps)) {
    tmp$pop()
  }

  tmp
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

# #' Place a piece on the board
# #' @param board A board
# #' @param piece A piece or its symbol (see [piece()])
# #' @param square A square or its name (see [square()])
# #' @param promoted Promoted?
# #' @return A board
# #' @export
# place <- function(board, piece, square, promoted = FALSE) {
#
#   # Can't place a piece during a game
#   stopifnot("board" %in% class(board))
#
#   # Convert to expected format
#   if (!"chess.Piece" %in% class(piece)) {
#     piece <- piece(piece)
#   }
#   if (is.character(square)) {
#     square <- square(square)
#   }
#
#   # Set piece on board
#   board$set_piece_at(square, piece, promoted)
#   board
# }
