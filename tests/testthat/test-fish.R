test_that("stockfish integration works", {

  # Skip if python-chess is not available
  if (!reticulate::py_module_available("chess")) {
    skip("python-chess not available for testing")
  }

  # Skip if not on Linux
  skip_on_os(c("windows", "mac"))

  # Create sample game
  board <- game() %>%
    move(
      "e4", "e5", "f4", "exf4", "Bc4", "Qh4+", "Kf1", "b5", "Bxb5", "Nf6", "Nf3",
      "Qh6", "d3", "Nh5", "Nh4", "Qg5", "Nf5", "c6", "g4", "Nf6", "Rg1", "cxb5"
    )

  # Configure Stockfish
  stockfish_configure(options = list("Skill Level" = "0"))
  expect_message(stockfish_configure(exe, list("Skill Level" = "0")), "already")

  # Move with skill 0
  move1 <- fish(board)$move$uci()
  expect_length(strsplit(move1, "")[[1]], 4)

  # Stop and reconfigure
  expect_invisible(stockfish_kill())
  stockfish_configure(options = list("Skill Level" = "20"))

  # Move with skill 20
  move2 <- fish(board, time = 1)$move$uci()
  expect_length(strsplit(move2, "")[[1]], 4)
})
