
#' Plot board
#' @param x A board
#' @param ... Not used
#' @export
plot.chess.Board <- function(x, ...) {

  # Must have rsvg
  if (!requireNamespace("rsvg", quietly = TRUE)) {
    stop("Install the {rsvg} package")
  }

  # Create a temp file
  file <- tempfile(fileext = ".png")
  on.exit(file.remove(file))

  # Save as PNG
  x %>%
    chess$svg$board() %>%
    reticulate::py_str() %>%
    charToRaw() %>%
    rsvg::rsvg_png(file)

  # Show on Viewer
  img <- png::readPNG(file)
  graphics::plot.new()
  graphics::plot.window(0:1, 0:1, asp = 1)
  graphics::rasterImage(img, xleft=0, xright=1, ybottom=0, ytop=1)
}

#' Save a board as an SVG
#' @param x A board
#' @param file File or connection to write to
#' @export
write_svg <- function(x, file) {

  # Must have rsvg
  if (!requireNamespace("rsvg", quietly = TRUE)) {
    stop("Install the {rsvg} package")
  }

  x %>%
    chess$svg$board() %>%
    reticulate::py_str() %>%
    charToRaw() %>%
    rsvg::rsvg_png(file)
}
