test_that("reading and writing PGN works", {

  # Skip if python-chess is not available
  if (!reticulate::py_module_available("chess")) {
    skip("python-chess not available for testing")
  }

  # Immortal game
  standard <- game() %>%
    move(
      "e4", "e5", "f4", "exf4", "Bc4", "Qh4+", "Kf1", "b5", "Bxb5", "Nf6", "Nf3",
      "Qh6", "d3", "Nh5", "Nh4", "Qg5", "Nf5", "c6", "g4", "Nf6", "Rg1", "cxb5",
      "h4", "Qg6", "h5", "Qg5", "Qf3", "Ng8", "Bxf4", "Qf6", "Nc3", "Bc5", "Nd5",
      "Qxb2", "Bd6", "Bxg1? {It is from this move that Black's defeat stems.}",
      list("Qxa1+ {Wilhelm Steinitz suggested in 1879...}", "Ke2", "Qb2", "Kd2", "Bxg1"),
      "e5", "Qxa1+", "Ke2", "Na6", "Nxg7+", "Kd8", "Qf6+", "Nxf6", "Be7#"
    )

  # Writing
  tmp <- tempfile(fileext = ".pgn")
  write_game(standard, tmp)
  expect_snapshot_file(tmp, "immortal.pgn")

  # Reading
  expect_snapshot(read_game(tmp))

  # Read a lot
  file <- system.file("m60mg.pgn", package = "chess")
  expect_equal(length(read_game(file)), 60)

  # SVG
  tmp <- tempfile(fileext = ".svg")
  write_svg(standard, tmp)
  expect_snapshot_file(tmp, "immortal.svg")

  # Str
  expect_snapshot(str(root(standard)))
})

test_that("plotting works", {

  # Skip if python-chess is not available
  if (!reticulate::py_module_available("chess")) {
    skip("python-chess not available for testing")
  }

  # Skip if not on Linux (resolutions break snapshot)
  skip_on_os(c("windows", "mac"))

  # Immortal game
  standard <- game() %>%
    move(
      "e4", "e5", "f4", "exf4", "Bc4", "Qh4+", "Kf1", "b5", "Bxb5", "Nf6", "Nf3",
      "Qh6", "d3", "Nh5", "Nh4", "Qg5", "Nf5", "c6", "g4", "Nf6", "Rg1", "cxb5",
      "h4", "Qg6", "h5", "Qg5", "Qf3", "Ng8", "Bxf4", "Qf6", "Nc3", "Bc5", "Nd5",
      "Qxb2", "Bd6", "Bxg1? {It is from this move that Black's defeat stems.}",
      list("Qxa1+ {Wilhelm Steinitz suggested in 1879...}", "Ke2", "Qb2", "Kd2", "Bxg1"),
      "e5", "Qxa1+", "Ke2", "Na6", "Nxg7+", "Kd8", "Qf6+", "Nxf6", "Be7#"
    )

  # Plot
  tmp <- tempfile(fileext = ".png")
  png(filename = tmp)
  plot(standard)
  dev.off()
  expect_snapshot_file(tmp, "immortal.png")
})
