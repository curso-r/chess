
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

# #' Create a piece object
# #' @param symbol Piece symbol (p, n, b, r, q, k, P, N, B, R, Q or K)
# #' @param color Piece color (B or W) if can't guess from `symbol`'s case
# #' @return A piece
# #' @export
# piece <- function(symbol, color = NULL) {
#
#   # Convert to one-letter symbol
#   if (tolower(symbol) == "knight") {
#     symbol <- substr(symbol, 2, 2)
#   } else {
#     symbol <- substr(symbol, 1, 1)
#   }
#
#   # If color isn't specified, infer from symbol
#   if (is.null(color)) {
#     return(chess$Piece$from_symbol(symbol))
#   }
#
#   # Convert to expected symbol
#   symbol <- tolower(symbol)
#   color <- substr(tolower(color), 1, 1)
#
#   # Convert from symbol
#   if (color == "b") {
#     return(chess$Piece$from_symbol(toupper(symbol)))
#   } else if (color == "w") {
#     return(chess$Piece$from_symbol(symbol))
#   }
#
#   stop("Invalid color")
# }

# #' Create a square object
# #' @param name Square name (A1, B1, ..., G8 or H8)
# #' @return A square
# #' @export
# square <- function(name) {
#   chess$parse_square(tolower(name))
# }
