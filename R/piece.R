
# #' Create a piece object
# #' @param symbol Piece symbol (p, n, b, r, q, k, P, N, B, R, Q or K)
# #' @param color Piece color (B or W) if can't gess from `symbol`'s case
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
