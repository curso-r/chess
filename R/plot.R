
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
    chess_svg$board() %>%
    reticulate::py_str() %>%
    charToRaw() %>%
    rsvg::rsvg_png(file)

  # Show on Viewer
  img <- png::readPNG(file)
  graphics::plot.new()
  graphics::plot.window(0:1, 0:1, asp = 1)
  graphics::rasterImage(img, xleft=0, xright=1, ybottom=0, ytop=1)
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
    chess_svg$board() %>%
    reticulate::py_str() %>%
    charToRaw() %>%
    rsvg::rsvg_png(file)
}
