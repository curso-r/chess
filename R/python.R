
#' Install python-chess
#'
#' Install the python library used as the backbone of this package. You can
#' pass arguments on to [reticulate::py_install()], but `python-chess` needs
#' `python_version = "3.8"` and `pip = TRUE`.
#'
#' @param method Installation method (by default, "auto" automatically finds a
#' method that will work in the local environment, but note that the
#' "virtualenv" method is not available on Windows)
#' @param conda Path to conda executable (or "auto" to find conda using the PATH
#' and other conventional install locations)
#' @param envname Name of Python environment to install within
#' @param conda_python_version the python version installed in the created conda
#' environment (Python 3.8 is installed by default)
#' @param ... other arguments passed to [reticulate::conda_install()] or
#' [reticulate::virtualenv_install()]
#'
#' @return `TRUE` if installation is successful
#' @export
install_chess <- function(method = c("auto", "virtualenv", "conda"),
                          conda = "auto", envname = NULL,
                          conda_python_version = "3.8", ...) {

  # Install
  method <- match.arg(method)
  reticulate::py_install(
    packages = "chess",  envname = envname, method = method, conda = conda,
    python_version = conda_python_version, pip = TRUE, ...)

  # Should probably restart session
  message("Please restart your R session")

  invisible(TRUE)
}

# Environment for globals
chess_env <- new.env(parent = emptyenv())

# Load python-chess
.onLoad <- function(libname, pkgname) {
  reticulate::configure_environment(pkgname)

  assign("chess_svg", reticulate::import("chess.svg", delay_load = TRUE), chess_env)
  assign("chess_pgn", reticulate::import("chess.pgn", delay_load = TRUE), chess_env)
}
