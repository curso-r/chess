
#' Save a game as an PGN
#' @param x A game
#' @param file File or connection to write to
#' @export
write_game <- function(x, file) {
  writeLines(as.character(chess$pgn$Game$from_board(x)), file)
  invisible(x)
}

#' Read a game from a PGN
#' @param file File or connection to read from
#' @return A game
#' @export
read_game <- function(file) {

  # Needs IO, but can't understand why
  io <- reticulate::import("io")

  # Read game from file
  game <- file %>%
    readLines() %>%
    paste0(collapse = "\n") %>%
    reticulate::r_to_py() %>%
    io$StringIO() %>%
    chess$pgn$read_game()
}
