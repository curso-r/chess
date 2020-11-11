
#' Save a game as an PGN
#' @param x A board
#' @param file File or connection to write to
#' @export
write_pgn <- function(x, file) {
  writeLines(as.character(chess$pgn$Game$from_board(x)), file)
  invisible(x)
}

#' Read a game from a PGN
#' @param file File or connection to read from
#' @return A board
#' @export
read_pgn <- function(file) {

  # Needs IO, but can't understand why
  io <- reticulate::import("io")

  # Read game from file
  game <- file %>%
    readLines() %>%
    paste0(collapse = "\n") %>%
    reticulate::r_to_py() %>%
    io$StringIO() %>%
    chess$pgn$read_game()

  # Return board
  game$end()$board()
}
