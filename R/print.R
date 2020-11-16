
#' Print a list of variations
#' @param x A game node
#' @param unicode Use unicode characters?
#' @param invert_color Invert piece color? Useful for white text on dark
#' background
#' @param empty_square Character used for empty square
#' @param ... Not used
#' @export
print.chess.pgn.Variations <- function(x, unicode = FALSE, invert_color = FALSE,
                                       empty_square = ".", ...) {

  # Handle list
  vars <- x
  x <- vars[[1]]

  # Get information about variations
  turn <- ifelse(!x$turn(), (x$ply() - 1) / 2, (x$ply() - 2) / 2) + 1
  turn <- ifelse(!x$turn(), paste0(turn, ". "), paste0(turn, "... "))
  next_move <- purrr::map_chr(vars, ~ .x$san())

  # Print variation headers
  paste0("<", turn, next_move, ">") %>%
    paste0(strrep(" ", 15 - nchar(.)), .) %>%
    paste0(collapse = "    ") %>%
    cli::col_grey() %>%
    paste0("\n") %>%
    cat()

  # Print variations
  vars %>%
    purrr::map(~ .x$board()) %>%
    purrr::map(board_to_string, unicode, invert_color, empty_square) %>%
    purrr::map(format, ...) %>%
    purrr::map(strsplit, "\n") %>%
    purrr::map(magrittr::extract2, 1) %>%
    purrr::transpose() %>%
    purrr::map_chr(paste0, collapse = "    ") %>%
    paste0(collapse = "\n") %>%
    cat()
}

#' Print game node
#' @param x A game node
#' @param unicode Use unicode characters?
#' @param invert_color Invert piece color? Useful for white text on dark
#' background.
#' @param empty_square Character used for empty square
#' @param ... Not used
#' @export
print.chess.pgn.GameNode <- function(x, unicode = FALSE, invert_color = FALSE,
                                     empty_square = ".", ...) {

  # Change method depending on state
  if (is.null(x$parent)) {

    # Denote start of game
    "<Start>" %>%
      paste0(strrep(" ", 15 - nchar(.)), .) %>%
      cli::col_grey() %>%
      paste0("\n") %>%
      cat()

    # Print initial board
    print.chess.Board(x$board(), unicode, invert_color, empty_square, ...)
  } else {

    # Get information about variations
    turn <- ifelse(!x$turn(), (x$ply() - 1) / 2, (x$ply() - 2) / 2) + 1
    turn <- ifelse(!x$turn(), paste0(turn, ". "), paste0(turn, "... "))

    # Print header
    paste0("<", turn, x$san(), ">") %>%
      paste0(strrep(" ", 15 - nchar(.)), .) %>%
      paste0("\n") %>%
      cli::col_grey() %>%
      cat()

    # Print variations
    x$board() %>%
      board_to_string(unicode, invert_color, empty_square) %>%
      format(...) %>%
      cat()
  }
}

#' Print board
#' @param x A game board
#' @param unicode Use unicode characters?
#' @param invert_color Invert piece color? Useful for white text on dark
#' background.
#' @param empty_square Character used for empty square
#' @param ... Not used
#' @export
print.chess.Board <- function(x, unicode = FALSE, invert_color = FALSE,
                              empty_square = ".", ...) {
  cat(format(board_to_string(x, unicode, invert_color, empty_square), ...))
}

#' Convert a board to either unicode or ASCII string
#' @param x A board
#' @param unicode Use unicode characters?
#' @param invert_color Invert piece color? Useful for white text on dark
#' background.
#' @param empty_square Character used for empty square
#' @return A string
board_to_string <- function(x, unicode = FALSE, invert_color = FALSE,
                            empty_square = ".") {

  # Pretty
  if (unicode) {
    text <- x$unicode(invert_color = invert_color, empty_square = empty_square)
  } else {
    text <- x
  }

  as.character(text)
}
