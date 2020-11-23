
# Regex for finding NAGs
nag_regex <- "[\u2212\\-\\+\u2213\u21C6\u2A01\u2A71\u2A00\\?\\!\\=\u25A1\u221E\u00B1\u2A72]+$"


#' Parse Numeric Annotation Glyph (NAG) of a move
#' @param game A game node
#' @return A string
#' @export
nag <- function(game) {
  id <- game$nags %>%
    reticulate::py_str() %>%
    sub("[{]", "", .) %>%
    sub("[}]", "", .) %>%
    as.numeric()

  # This is insane. switch() doesn't work with integers?
  if (id == chess_env$chess_pgn$NAG_BLACK_DECISIVE_ADVANTAGE) {
    return("-+")
  }
  if (id == chess_env$chess_pgn$NAG_BLACK_MODERATE_ADVANTAGE) {
    return("\u2213")
  }
  if (id == chess_env$chess_pgn$NAG_BLACK_MODERATE_COUNTERPLAY) {
    return("\u21c6")
  }
  if (id == chess_env$chess_pgn$NAG_BLACK_SEVERE_TIME_PRESSURE) {
    return("\u2a01")
  }
  if (id == chess_env$chess_pgn$NAG_BLACK_SLIGHT_ADVANTAGE) {
    return("\u2a71")
  }
  if (id == chess_env$chess_pgn$NAG_BLACK_ZUGZWANG) {
    return("\u2a00")
  }
  if (id == chess_env$chess_pgn$NAG_BLUNDER) {
    return("??")
  }
  if (id == chess_env$chess_pgn$NAG_BRILLIANT_MOVE) {
    return("!!")
  }
  if (id == chess_env$chess_pgn$NAG_DRAWISH_POSITION) {
    return("=")
  }
  if (id == chess_env$chess_pgn$NAG_DUBIOUS_MOVE) {
    return("?!")
  }
  if (id == chess_env$chess_pgn$NAG_FORCED_MOVE) {
    return("\u25a1")
  }
  if (id == chess_env$chess_pgn$NAG_GOOD_MOVE) {
    return("!")
  }
  if (id == chess_env$chess_pgn$NAG_MISTAKE) {
    return("?")
  }
  if (id == chess_env$chess_pgn$NAG_SPECULATIVE_MOVE) {
    return("!?")
  }
  if (id == chess_env$chess_pgn$NAG_UNCLEAR_POSITION) {
    return("\u221e")
  }
  if (id == chess_env$chess_pgn$NAG_WHITE_DECISIVE_ADVANTAGE) {
    return("+-")
  }
  if (id == chess_env$chess_pgn$NAG_WHITE_MODERATE_ADVANTAGE) {
    return("\u00b1")
  }
  if (id == chess_env$chess_pgn$NAG_WHITE_MODERATE_COUNTERPLAY) {
    return("\u21c6")
  }
  if (id == chess_env$chess_pgn$NAG_WHITE_SEVERE_TIME_PRESSURE) {
    return("\u2a01")
  }
  if (id == chess_env$chess_pgn$NAG_WHITE_SLIGHT_ADVANTAGE) {
    return("\u2a72")
  }
  if (id == chess_env$chess_pgn$NAG_WHITE_ZUGZWANG) {
    return("\u2a00")
  }
}

#' Convert glyph to NAG
#' @param glyph A game node
#' @return An integer
glyph_to_nag <- function(glyph) {

  # Avoid warnings on Windows
  if (is.na(glyph)) {
    return(NULL)
  }
  if (glyph == "\u2212+") {
    return(chess_env$chess_pgn$NAG_BLACK_DECISIVE_ADVANTAGE)
  }
  if (glyph == "-+") {
    return(chess_env$chess_pgn$NAG_BLACK_DECISIVE_ADVANTAGE)
  }
  if (glyph == "\u2213") {
    return(chess_env$chess_pgn$NAG_BLACK_MODERATE_ADVANTAGE)
  }
  if (glyph == "\u21c6") {
    return(chess_env$chess_pgn$NAG_BLACK_MODERATE_COUNTERPLAY)
  }
  if (glyph == "\u2a01") {
    return(chess_env$chess_pgn$NAG_BLACK_SEVERE_TIME_PRESSURE)
  }
  if (glyph == "\u2a71") {
    return(chess_env$chess_pgn$NAG_BLACK_SLIGHT_ADVANTAGE)
  }
  if (glyph == "\u2a00") {
    return(chess_env$chess_pgn$NAG_BLACK_ZUGZWANG)
  }
  if (glyph == "??") {
    return(chess_env$chess_pgn$NAG_BLUNDER)
  }
  if (glyph == "!!") {
    return(chess_env$chess_pgn$NAG_BRILLIANT_MOVE)
  }
  if (glyph == "=") {
    return(chess_env$chess_pgn$NAG_DRAWISH_POSITION)
  }
  if (glyph == "?!") {
    return(chess_env$chess_pgn$NAG_DUBIOUS_MOVE)
  }
  if (glyph == "\u25a1") {
    return(chess_env$chess_pgn$NAG_FORCED_MOVE)
  }
  if (glyph == "!") {
    return(chess_env$chess_pgn$NAG_GOOD_MOVE)
  }
  if (glyph == "?") {
    return(chess_env$chess_pgn$NAG_MISTAKE)
  }
  if (glyph == "!?") {
    return(chess_env$chess_pgn$NAG_SPECULATIVE_MOVE)
  }
  if (glyph == "\u221e") {
    return(chess_env$chess_pgn$NAG_UNCLEAR_POSITION)
  }
  if (glyph == "+\u2212") {
    return(chess_env$chess_pgn$NAG_WHITE_DECISIVE_ADVANTAGE)
  }
  if (glyph == "+-") {
    return(chess_env$chess_pgn$NAG_WHITE_DECISIVE_ADVANTAGE)
  }
  if (glyph == "\u00b1") {
    return(chess_env$chess_pgn$NAG_WHITE_MODERATE_ADVANTAGE)
  }
  if (glyph == "\u21c6") {
    return(chess_env$chess_pgn$NAG_WHITE_MODERATE_COUNTERPLAY)
  }
  if (glyph == "\u2a01") {
    return(chess_env$chess_pgn$NAG_WHITE_SEVERE_TIME_PRESSURE)
  }
  if (glyph == "\u2a72") {
    return(chess_env$chess_pgn$NAG_WHITE_SLIGHT_ADVANTAGE)
  }
  if (glyph == "\u2a00") {
    return(chess_env$chess_pgn$NAG_WHITE_ZUGZWANG)
  }
}

#' Get comment for a move
#' @param game A game node
#' @return A string
#' @export
note <- function(game) {
  game$comment
}
