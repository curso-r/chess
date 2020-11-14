
# Regex for finding NAGs
nag_regex <- "[\\u2212\\-\\+\\u2213\\u21c6\\u2a01\\u2a71\\u2a00\\?\\!\\=\\u25a1\\u221e\\u00b1\\u2a72]+$"

#' Parse Numeric Annotation Glyph (NAG) of a move
#' @param game A game node
#' @return A string
#' @export
nag <- function(game) {
  id <- game$nags %>%
    reticulate::py_str() %>%
    stringr::str_remove_all("[{}]") %>%
    as.numeric()

  # This is insane. switch() doesn't work with integers?
  if (id == chess_pgn$NAG_BLACK_DECISIVE_ADVANTAGE) return("-+")
  if (id == chess_pgn$NAG_BLACK_MODERATE_ADVANTAGE) return("\u2213")
  if (id == chess_pgn$NAG_BLACK_MODERATE_COUNTERPLAY) return("\u21c6")
  if (id == chess_pgn$NAG_BLACK_SEVERE_TIME_PRESSURE) return("\u2a01")
  if (id == chess_pgn$NAG_BLACK_SLIGHT_ADVANTAGE) return("\u2a71")
  if (id == chess_pgn$NAG_BLACK_ZUGZWANG) return("\u2a00")
  if (id == chess_pgn$NAG_BLUNDER) return("??")
  if (id == chess_pgn$NAG_BRILLIANT_MOVE) return("!!")
  if (id == chess_pgn$NAG_DRAWISH_POSITION) return("=")
  if (id == chess_pgn$NAG_DUBIOUS_MOVE) return("?!")
  if (id == chess_pgn$NAG_FORCED_MOVE) return("\u25a1")
  if (id == chess_pgn$NAG_GOOD_MOVE) return("!")
  if (id == chess_pgn$NAG_MISTAKE) return("?")
  if (id == chess_pgn$NAG_SPECULATIVE_MOVE) return("!?")
  if (id == chess_pgn$NAG_UNCLEAR_POSITION) return("\u221e")
  if (id == chess_pgn$NAG_WHITE_DECISIVE_ADVANTAGE) return("+-")
  if (id == chess_pgn$NAG_WHITE_MODERATE_ADVANTAGE) return("\u00b1")
  if (id == chess_pgn$NAG_WHITE_MODERATE_COUNTERPLAY) return("\u21c6")
  if (id == chess_pgn$NAG_WHITE_SEVERE_TIME_PRESSURE) return("\u2a01")
  if (id == chess_pgn$NAG_WHITE_SLIGHT_ADVANTAGE) return("\u2a72")
  if (id == chess_pgn$NAG_WHITE_ZUGZWANG) return("\u2a00")
}

#' Convert glyph to NAG
#' @param glyph A game node
#' @return An integer
glyph_to_nag <- function(glyph) {
  switch (glyph,
    "\u2212+" = chess_pgn$NAG_BLACK_DECISIVE_ADVANTAGE,
    "-+" = chess_pgn$NAG_BLACK_DECISIVE_ADVANTAGE,
    "\u2213" = chess_pgn$NAG_BLACK_MODERATE_ADVANTAGE,
    "\u21c6" = chess_pgn$NAG_BLACK_MODERATE_COUNTERPLAY,
    "\u2a01" = chess_pgn$NAG_BLACK_SEVERE_TIME_PRESSURE,
    "\u2a71" = chess_pgn$NAG_BLACK_SLIGHT_ADVANTAGE,
    "\u2a00" = chess_pgn$NAG_BLACK_ZUGZWANG,
    "??" = chess_pgn$NAG_BLUNDER,
    "!!" = chess_pgn$NAG_BRILLIANT_MOVE,
    "=" = chess_pgn$NAG_DRAWISH_POSITION,
    "?!" = chess_pgn$NAG_DUBIOUS_MOVE,
    "\u25a1" = chess_pgn$NAG_FORCED_MOVE,
    "!" = chess_pgn$NAG_GOOD_MOVE,
    "?" = chess_pgn$NAG_MISTAKE,
    "!?" = chess_pgn$NAG_SPECULATIVE_MOVE,
    "\u221e" = chess_pgn$NAG_UNCLEAR_POSITION,
    "+\u2212" = chess_pgn$NAG_WHITE_DECISIVE_ADVANTAGE,
    "+-" = chess_pgn$NAG_WHITE_DECISIVE_ADVANTAGE,
    "\u00b1" = chess_pgn$NAG_WHITE_MODERATE_ADVANTAGE,
    "\u21c6" = chess_pgn$NAG_WHITE_MODERATE_COUNTERPLAY,
    "\u2a01" = chess_pgn$NAG_WHITE_SEVERE_TIME_PRESSURE,
    "\u2a72" = chess_pgn$NAG_WHITE_SLIGHT_ADVANTAGE,
    "\u2a00" = chess_pgn$NAG_WHITE_ZUGZWANG
  )
}

#' Get comment for a move
#' @param game A game node
#' @return A string
#' @export
note <- function(game) {
  game$comment
}
