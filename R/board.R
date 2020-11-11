
# #' Get FEN representation of board
# #' @param board A board
# #' @return A string
# #' @export
# fen <- function(board) {
#   if ("board" %in% class(board)) {
#     board$board_fen()
#   } else {
#     board$fen()
#   }
# }

# #' Start an empty board
# #' @return A board
# #' @export
# board <- function() {
#   b <- chess$Board$empty()
#   class(b) <- c("board", class(b))
#   return(b)
# }

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
