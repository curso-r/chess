
#' Configure and start Stockfish engine
#'
#' @param path Path to Stockfish executable
#' @param options A list of options passed on to Stockfish
#'
#' @return `TRUE` if startup is successful
#' @export
stockfish_configure <- function(path = Sys.getenv("STOCKFISH_PATH"), options = list()) {

  # Configure Stockfish only if necessary
  if (!is.null(chess_env$stockfish)) {
    message("Stockfish already configured")
  } else {
    path <- path.expand(path)
    assign("stockfish", chess_env$chess_engine$SimpleEngine$popen_uci(path), chess_env)
    if (length(options) > 0) chess_env$stockfish$configure(options)
  }

  invisible(TRUE)
}

#' Kill current Stockfish engine
#'
#' @return `TRUE` if shutdown in sucessful
#' @export
stockfish_kill <- function() {
  chess_env$stockfish$close()
  rm("stockfish", pos = chess_env)
  invisible(TRUE)
}

#' Download Stockfish executable according to platform
#'
#' @param path Path where to save executable
#'
#' @return Path to executable
#' @export
stockfish_download <- function(path = "~/.stockfish") {

  # Create folder
  dir.create(path, showWarnings = FALSE, recursive = TRUE)

  # Get version requirements
  url <- "https://stockfishchess.org/files/"
  version <- switch (Sys.info()["sysname"],
    "Linux" = "stockfish_12_linux_x64_bmi2.zip"
  )

  # Download and unzip
  zipfile <- paste0(path, "/", version)
  utils::download.file(paste0(url, version), zipfile)
  utils::unzip(zipfile, exdir = path, overwrite = TRUE)
  file.remove(zipfile)

  # Let user know final path
  exefile <- list.files(path, full.names = TRUE)
  message("Add the following to your .Renviron:")
  message('  STOCKFISH_PATH="', exefile, '"')

  invisible(exefile)
}

#' Have Stockfish play the next move
#'
#' @param game A game node
#' @param time Time limit (in seconds) allocated to Stockfish
#'
#' @return A game node
#' @export
fish <- function(game, time = 0.1) {

  # Configure Stockfish if necessary
  if (is.null(chess_env$stockfish)) {
    stockfish_configure()
  }

  # Make move
  result <- chess_env$stockfish$play(game$board(), chess_env$chess_engine$Limit(time = time))
  move(game, result$move$uci(), notation = "uci")
}
