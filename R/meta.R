
#' Get FEN representation of board
#' @param game A game node
#' @return A string
#' @export
fen <- function(game) {
  game$board()$fen()
}

#' Get whose turn it is
#' @param game A game node
#' @return A boolean (`TRUE` is White and `FALSE` is Black)
#' @export
turn <- function(game) {
  game$board()$turn
}

#' Get number of move
#' @param game A game node
#' @return An integer
#' @export
move_number <- function(game) {
  game$board()$fullmove_number
}

#' Get number of ply
#' @param game A game node
#' @return An integer
#' @export
ply_number <- function(game) {
  game$board()$ply()
}

#' Get number of half-moves since the last capture or pawn move
#' @param game A game node
#' @return An integer
#' @export
halfmove_clock <- function(game) {
  game$board()$halfmove_clock
}

#' Get result of the game ("*" if it hasn't ended)
#' @param game Any node of a game
#' @return A string
#' @export
result <- function(game) {
  game$root()$end()$board()$result()
}

#' Get all legal moves available
#' @param game A game node
#' @return A vector of strings
#' @export
moves <- function(game) {
  game$board()$legal_moves %>%
    reticulate::py_str() %>%
    sub(".*\\(", "", ., perl = TRUE) %>%
    sub("\\).*", "", ., perl = TRUE) %>%
    strsplit(", ") %>%
    magrittr::extract2(1)
}

#' Get information about the current board
#' @param game A game node
#' @param count Number of moves to count for repetition
#' @return A boolean
#' @name board_is
NULL

#' @rdname board_is
#' @export
is_checkmate <- function(game) {
  game$board()$is_checkmate()
}

#' @rdname board_is
#' @export
is_check <- function(game) {
  game$board()$is_check()
}

#' @rdname board_is
#' @export
is_game_over <- function(game) {
  game$board()$is_game_over()
}

#' @rdname board_is
#' @export
is_stalemate <- function(game) {
  game$board()$is_stalemate()
}

#' @rdname board_is
#' @export
is_insufficient_material <- function(game) {
  game$board()$is_insufficient_material()
}

#' @rdname board_is
#' @export
is_seventyfive_moves <- function(game) {
  game$board()$is_seventyfive_moves()
}

#' @rdname board_is
#' @export
is_fivefold_repetition <- function(game) {
  game$board()$is_fivefold_repetition()
}

#' @rdname board_is
#' @export
is_repetition <- function(game, count = 3) {
  game$board()$is_repetition(count)
}

#' @rdname board_is
#' @export
can_claim_draw <- function(game) {
  game$board()$can_claim_draw()
}

#' @rdname board_is
#' @export
can_claim_fifty_moves <- function(game) {
  game$board()$can_claim_fifty_moves()
}

#' @rdname board_is
#' @export
can_claim_threefold_repetition <- function(game) {
  game$board()$can_claim_threefold_repetition()
}

#' @rdname board_is
#' @export
has_en_passant <- function(game) {
  game$board()$has_legal_en_passant()
}

#' Get information about the current board given a move
#' @param game A game node
#' @param move Move to consider
#' @param notation Notation used for `move`
#' @return A boolean
#' @name board_move
NULL

#' @rdname board_move
#' @export
gives_check <- function(game, move, notation = c("san", "uci", "xboard")) {
  game$board()$gives_check(parse_move(game, move, notation))
}

#' @rdname board_move
#' @export
is_en_passant <- function(game, move, notation = c("san", "uci", "xboard")) {
  game$board()$is_en_passant(parse_move(game, move, notation))
}

#' @rdname board_move
#' @export
is_capture <- function(game, move, notation = c("san", "uci", "xboard")) {
  game$board()$is_capture(parse_move(game, move, notation))
}

#' @rdname board_move
#' @export
is_zeroing <- function(game, move, notation = c("san", "uci", "xboard")) {
  game$board()$is_zeroing(parse_move(game, move, notation))
}

#' @rdname board_move
#' @export
is_irreversible <- function(game, move, notation = c("san", "uci", "xboard")) {
  game$board()$is_irreversible(parse_move(game, move, notation))
}

#' @rdname board_move
#' @export
is_castling <- function(game, move, notation = c("san", "uci", "xboard")) {
  game$board()$is_castling(parse_move(game, move, notation))
}

#' @rdname board_move
#' @export
is_kingside_castling <- function(game, move, notation = c("san", "uci", "xboard")) {
  game$board()$is_kingside_castling(parse_move(game, move, notation))
}

#' @rdname board_move
#' @export
is_queenside_castling <- function(game, move, notation = c("san", "uci", "xboard")) {
  game$board()$is_queenside_castling(parse_move(game, move, notation))
}

#' Get information about the current board given a color
#' @param game A game node
#' @param color Color to use (`TRUE` is White and `FALSE` is Black)
#' @return A boolean
#' @name board_color
NULL

#' @rdname board_color
#' @export
has_insufficient_material <- function(game, color) {
  game$board()$has_insufficient_material(color)
}

#' @rdname board_color
#' @export
has_castling_rights <- function(game, color) {
  game$board()$has_castling_rights(color)
}

#' @rdname board_color
#' @export
has_kingside_castling_rights <- function(game, color) {
  game$board()$has_kingside_castling_rights(color)
}

#' @rdname board_color
#' @export
has_queenside_castling_rights <- function(game, color) {
  game$board()$has_queenside_castling_rights(color)
}
