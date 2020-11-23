
#' Plot rendering of the board
#' @param x A game node
#' @param ... Not used
#' @export
plot.chess.pgn.GameNode <- function(x, ...) {

  # Must have rsvg
  if (!requireNamespace("rsvg", quietly = TRUE)) {
    stop("Install the {rsvg} package")
  }

  # Create a temp file
  file <- tempfile(fileext = ".png")
  on.exit(file.remove(file))

  # Save as PNG
  x$board() %>%
    chess_env$chess_svg$board() %>%
    reticulate::py_str() %>%
    charToRaw() %>%
    rsvg::rsvg_png(file)

  # Restore old par on exit
  oldpar <- graphics::par(no.readonly = TRUE)
  on.exit(graphics::par(oldpar))

  # Show on Viewer
  img <- png::readPNG(file)
  graphics::par(mar = c(0, 0, 0, 0))
  graphics::plot.new()
  graphics::plot.window(c(0, 10), c(0, 10), asp = 1)
  graphics::rasterImage(img, xleft = 0, xright = 10, ybottom = 0, ytop = 10)
}

#' Save an SVG with rendering of the board
#' @param x A game node
#' @param file File or connection to write to
#' @export
write_svg <- function(x, file) {

  # Must have rsvg
  if (!requireNamespace("rsvg", quietly = TRUE)) {
    stop("Install the {rsvg} package")
  }

  x$board() %>%
    chess_env$chess_svg$board() %>%
    reticulate::py_str() %>%
    charToRaw() %>%
    rsvg::rsvg_png(file)
}
