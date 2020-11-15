test_that("annotations work", {

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

  # NAG
  expect_equal(
    standard %>%
      root() %>%
      forward(36) %>%
      nag(),
    "?"
  )

  # Comment
  expect_equal(
    standard %>%
      root() %>%
      forward(36) %>%
      note(),
    "It is from this move that Black's defeat stems."
  )

  # Variation comment
  expect_equal(
    standard %>%
      root() %>%
      forward(35) %>%
      variation(2) %>%
      note(),
    "Wilhelm Steinitz suggested in 1879..."
  )
})
