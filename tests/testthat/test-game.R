test_that("basic games can be created", {

  # Skip if python-chess is not available
  if (!reticulate::py_module_available("chess")) {
    skip("python-chess not available for testing")
  }

  # Empty game
  expect_snapshot(game())
  expect_equal(pgn(game()), "[Event \"?\"]\n[Site \"?\"]\n[Date \"????.??.??\"]\n[Round \"?\"]\n[White \"?\"]\n[Black \"?\"]\n[Result \"*\"]\n\n*")

  # Game from FEN
  expect_snapshot(
    game(fen = "r1bk3r/p2pBpNp/n4n2/1p1NP2P/6P1/3P4/P1P1K3/q5b1 b - - 1 23")
  )
  expect_equal(
    pgn(game(fen = "r1bk3r/p2pBpNp/n4n2/1p1NP2P/6P1/3P4/P1P1K3/q5b1 b - - 1 23")),
    "[Event \"?\"]\n[Site \"?\"]\n[Date \"????.??.??\"]\n[Round \"?\"]\n[White \"?\"]\n[Black \"?\"]\n[Result \"*\"]\n[FEN \"r1bk3r/p2pBpNp/n4n2/1p1NP2P/6P1/3P4/P1P1K3/q5b1 b - - 1 23\"]\n[SetUp \"1\"]\n\n*"
  )

  # Game with headers
  expect_snapshot(
    game(headers = list("White" = "Anderssen", "Black" = "Kieseritzky"))
  )
  expect_equal(
    pgn(game(headers = list("White" = "Anderssen", "Black" = "Kieseritzky"))),
    "[White \"Anderssen\"]\n[Black \"Kieseritzky\"]\n\n*"
  )

  # Game from FEN with headers
  expect_snapshot(
    game(
      headers = list("White" = "Anderssen", "Black" = "Kieseritzky"),
      fen = "r1bk3r/p2pBpNp/n4n2/1p1NP2P/6P1/3P4/P1P1K3/q5b1 b - - 1 23"
    )
  )
  expect_equal(
    pgn(
      game(
        headers = list("White" = "Anderssen", "Black" = "Kieseritzky"),
        fen = "r1bk3r/p2pBpNp/n4n2/1p1NP2P/6P1/3P4/P1P1K3/q5b1 b - - 1 23"
      )
    ),
    "[White \"Anderssen\"]\n[Black \"Kieseritzky\"]\n[FEN \"r1bk3r/p2pBpNp/n4n2/1p1NP2P/6P1/3P4/P1P1K3/q5b1 b - - 1 23\"]\n[SetUp \"1\"]\n\n*"
  )
})

test_that("basic moves can be made", {

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
      "Qxb2", "Bd6", "Bxg1", "e5", "Qxa1+", "Ke2", "Na6", "Nxg7+", "Kd8", "Qf6+",
      "Nxf6", "Be7#"
    )

  # Standard moves
  expect_snapshot(standard)

  # Other ways to make the moves
  expect_equal(
    game() %>%
      move("e4", "e5", "f4", "exf4", "Bc4", "Qh4+", "Kf1", "b5", "Bxb5", "Nf6", "Nf3") %>%
      move("Qh6", "d3", "Nh5", "Nh4", "Qg5", "Nf5", "c6", "g4", "Nf6", "Rg1", "cxb5") %>%
      move("h4", "Qg6", "h5", "Qg5", "Qf3", "Ng8", "Bxf4", "Qf6", "Nc3", "Bc5", "Nd5") %>%
      move("Qxb2", "Bd6", "Bxg1", "e5", "Qxa1+", "Ke2", "Na6", "Nxg7+", "Kd8", "Qf6+") %>%
      move("Nxf6", "Be7#") %>%
      pgn(),
    pgn(standard)
  )

  # Break moves
  expect_equal(
    game() %>%
      move("e4", "e5", "f4", "exf4", "Bc4", "Qh4+", "Kf1", "b5", "Bxb5", "Nf6", "Nf3") %>%
      move("Qh6", "d3", "Nh5", "Nh4", "Qg5", "Nf5", "c6", "g4", "Nf6", "Rg1", "cxb5") %>%
      move("h4", "Qg6", "h5", "Qg5", "Qf3", "Ng8", "Bxf4", "Qf6", "Nc3", "Bc5", "Nd5") %>%
      move("Qxb2", "Bd6", "Bxg1", "e5", "Qxa1+", "Ke2", "Na6", "Nxg7+", "Kd8", "Qf6+") %>%
      move("Nxf6", "Be7#") %>%
      pgn(),
    pgn(standard)
  )

  # Remove checkmate
  expect_equal(
    game() %>%
      move("e4", "e5", "f4", "exf4", "Bc4", "Qh4+", "Kf1", "b5", "Bxb5", "Nf6", "Nf3") %>%
      move("Qh6", "d3", "Nh5", "Nh4", "Qg5", "Nf5", "c6", "g4", "Nf6", "Rg1", "cxb5") %>%
      move("h4", "Qg6", "h5", "Qg5", "Qf3", "Ng8", "Bxf4", "Qf6", "Nc3", "Bc5", "Nd5") %>%
      move("Qxb2", "Bd6", "Bxg1", "e5", "Qxa1+", "Ke2", "Na6", "Nxg7+", "Kd8", "Qf6+") %>%
      move("Nxf6", "Be7") %>%
      pgn(),
    pgn(standard)
  )
})

test_that("navigation works", {

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
      "Qxb2", "Bd6", "Bxg1", "e5", "Qxa1+", "Ke2", "Na6", "Nxg7+", "Kd8", "Qf6+",
      "Nxf6", "Be7#"
    )

  # Root
  expect_snapshot(root(standard))

  # Back and forward
  expect_snapshot(back(standard, 5))
  expect_snapshot(forward(root(standard), 5))
})

test_that("branching works", {

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
      "Qxb2", "Bd6", "Bxg1", list("Qxa1+", "Ke2", list("Kg2"), "Qb2", "Kd2", "Bxg1"),
      "e5", "Qxa1+", "Ke2", "Na6", "Nxg7+", "Kd8", "Qf6+", "Nxf6", "Be7#"
    )

  # Forward
  expect_snapshot(
    standard %>%
      root() %>%
      forward(36)
  )

  # Back
  expect_snapshot(
    standard %>%
      back(10)
  )

  # Variations
  expect_snapshot(
    standard %>%
      root() %>%
      forward(35) %>%
      variations()
  )

  # Variation
  expect_snapshot(
    standard %>%
      root() %>%
      forward(35) %>%
      variation(2)
  )

  # Variations nested
  expect_snapshot(
    standard %>%
      root() %>%
      forward(35) %>%
      variation(2) %>%
      variations()
  )

  # Variation nested
  expect_snapshot(
    standard %>%
      root() %>%
      forward(35) %>%
      variation(2) %>%
      variation(2)
  )

  # Back to root
  expect_snapshot(
    standard %>%
      root() %>%
      forward(35) %>%
      variation(2) %>%
      variation(2) %>%
      root()
  )
})
