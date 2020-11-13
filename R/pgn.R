
#' Save a game as an PGN
#' @param x Any node of a game
#' @param file File or connection to write to
#' @export
write_game <- function(x, file) {
  writeLines(utils::capture.output(utils::str(root(x))), file)
  invisible(x)
}

#' Read a game from a PGN
#' @param file File or connection to read from
#' @return A game node
#' @export
read_game <- function(file) {

  # Needs IO, but can't understand why
  io <- reticulate::import("io")

  # Read game from file
  file %>%
    readLines() %>%
    paste0(collapse = "\n") %>%
    reticulate::r_to_py() %>%
    io$StringIO() %>%
    chess_pgn$read_game()
}
