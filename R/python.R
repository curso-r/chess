
#' Install python-chess
#' @param method Installation method
#' @param conda The path to a conda executable
#' @param ... Other arguments passed on to [reticulate::py_install()]
#' @export
install_chess <- function(method = "auto", conda = "auto", ...) {
  reticulate::py_install("chess", method = method, conda = conda, ...)
}

# Environment for globals
chess_env <- new.env(parent = emptyenv())

# Load python-chess
.onLoad <- function(libname, pkgname) {
  reticulate::configure_environment(pkgname)

  assign("chess_svg", reticulate::import("chess.svg", delay_load = TRUE), chess_env)
  assign("chess_pgn", reticulate::import("chess.pgn", delay_load = TRUE), chess_env)
}
