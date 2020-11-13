
# #' Setup a new board
# #' @return A board
# #' @export
# # board <- function() {
# #   chess$Board()
# # }

# #' Setup an empty board
# #' @return A board
# #' @export
# empty_board <- function() {
#   chess$Board$empty()
# }

# #' Undo last move
# #' @param board A board
# #' @param steps How many moves (half-turns) to revert
# #' @return A board
# undo <- function(board, steps = 1) {
#
#   # No side effects
#   tmp <- board$copy()
#
#   # Pop
#   for (i in seq_len(steps)) {
#     tmp$pop()
#   }
#
#   tmp
# }

#' Check board for checkmate
#' @param game A game node
#' @return A boolean
#' @export
is_checkmate <- function(game) {
  game$board()$is_checkmate()
}

#' Get FEN representation of board
#' @param game A game node
#' @return A string
#' @export
fen <- function(game) {
  game$board()$fen()
}
