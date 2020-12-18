
#' Configure and start Stockfish engine
#'
#' @param path Path to Stockfish executable (defaults to bundled version)
#' @param options A list of options passed on to Stockfish
#'
#' @export
fish_configure <- function(path = NULL, options = list()) {

  # Find executable
  exe <- if (is.null(path)) stockfish::fish_find() else path.expand(path)

  # Configure Stockfish only if necessary
  if (!is.null(chess_env$stockfish)) {
    message("Stockfish already configured")
  } else {
    assign("stockfish", chess_env$chess_engine$SimpleEngine$popen_uci(exe), chess_env)
    if (length(options) > 0) chess_env$stockfish$configure(options)
  }

  invisible(TRUE)
}

#' Have Stockfish play the next move
#'
#' @param game A game node
#' @param time Time limit (in seconds) allocated to Stockfish
#'
#' @return A game node
#' @export
fish_move <- function(game, time = 0.1) {

  # Configure Stockfish if necessary
  if (is.null(chess_env$stockfish)) {
    fish_configure()
  }

  # Make move
  result <- chess_env$stockfish$play(game$board(), chess_env$chess_engine$Limit(time = time))
  move(game, result$move$uci(), notation = "uci")
}
