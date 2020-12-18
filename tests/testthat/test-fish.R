test_that("stockfish works", {

  # Test Stockfish
  expect_true(fish_configure(options = list("Skill Level" = "0")))

  # Create game
  game <- game() %>%
    move("e4", "e5", "f4", "exf4", "Bc4", "Qh4+", "Kf1", "b5", "Bxb5", "Nf6", "Nf3") %>%
    fish_move()

  # Check that a move was played
  expect_equal(ply_number(game), 12)
})
