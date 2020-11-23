test_that("meta functions work", {

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

  # General
  expect_equal(fen(standard), "r1bk3r/p2pBpNp/n4n2/1p1NP2P/6P1/3P4/P1P1K3/q5b1 b - - 1 23")
  expect_false(turn(standard))
  expect_equal(move_number(standard), 23)
  expect_equal(ply_number(standard), 45)
  expect_equal(halfmove_clock(standard), 1)
  expect_equal(result(standard), "1-0")
  expect_equal(moves(root(standard)), c(
    "Nh3", "Nf3", "Nc3", "Na3", "h3", "g3", "f3", "e3", "d3", "c3", "b3", "a3",
    "h4", "g4", "f4", "e4", "d4", "c4", "b4", "a4"
  ))

  # Is
  expect_true(is_checkmate(standard))
  expect_true(is_check(standard))
  expect_true(is_game_over(standard))
  expect_false(is_stalemate(standard))
  expect_false(is_insufficient_material(standard))
  expect_false(is_seventyfive_moves(standard))
  expect_false(is_fivefold_repetition(standard))
  expect_false(is_repetition(standard))
  expect_false(can_claim_draw(standard))
  expect_false(can_claim_fifty_moves(standard))
  expect_false(can_claim_threefold_repetition(standard))
  expect_false(has_en_passant(standard))

  # Move
  expect_false(gives_check(game(), "e4"))
  expect_false(is_en_passant(game(), "e4"))
  expect_false(is_capture(game(), "e4"))
  expect_true(is_zeroing(game(), "e4"))
  expect_true(is_irreversible(game(), "e4"))
  expect_false(is_castling(game(), "e4"))
  expect_false(is_kingside_castling(game(), "e4"))
  expect_false(is_queenside_castling(game(), "e4"))

  # Color
  expect_false(has_insufficient_material(standard, FALSE))
  expect_false(has_castling_rights(standard, FALSE))
  expect_false(has_kingside_castling_rights(standard, FALSE))
  expect_false(has_queenside_castling_rights(standard, FALSE))
})
