
#' Install python-chess
#' @param method Installation method
#' @param conda The path to a conda executable
#' @param ... Other arguments passed on to [reticulate::py_install()]
#' @export
install_chess <- function(method = "auto", conda = "auto", ...) {
  reticulate::py_install("chess", method = method, conda = conda, ...)
}

# Global reference to chess
chess <- NULL
chess_svg <- NULL
chess_pgn <- NULL

# Load python-chess
.onLoad <- function(libname, pkgname) {
  reticulate::configure_environment(pkgname)
  chess <<- reticulate::import("chess", delay_load = TRUE)
  chess_svg <<- reticulate::import("chess.svg", delay_load = TRUE)
  chess_pgn <<- reticulate::import("chess.pgn", delay_load = TRUE)
}
