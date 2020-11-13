
#' Make moves and create variations
#' @param game A game node
#' @param ... Sequence of moves (lists are converted to a variation the same
#' way parentheses work for PGN)
#' @param notation Notation used for moves
#' @return A game node
#' @export
move <- function(game, ..., notation = c("san", "uci", "xboard")) {
  return(move_(game, list(...), notation))
}

#' Make moves and create variations
#' @param game A game node
#' @param moves List of moves (lists are converted to a variation the same
#' way parentheses work for PGN)
#' @param notation Notation used for moves
#' @return A game node
move_ <- function(game, moves, notation = c("san", "uci", "xboard")) {

  # Base case
  if (length(moves) == 0) return(game)

  # Take first element
  move1 <- moves[[1]]
  moves <- moves[-1]

  # Make first move
  if (is.list(move1)) {

    # Decide next step based on next subelement
    move11 <- move1[[1]]
    moves1 <- move1[-1]

    # Branch and move
    sply <- game$ply()
    game <- line(game, move11, notation, TRUE)
    game <- move_(game, moves1, notation)
    eply <- game$ply()

    # Go back to root of variation
    game <- back(game, eply-sply+1)
    game <- variation(game, 1)

  } else {

    # Just play move
    game <- play(game, move1, notation)

  }

  # Recursion
  return(move_(game, moves, notation))
}

#' Move a piece on the board
#' @param game A game node
#' @param moves Vector of one or more description of moves
#' @param notation Notation used for `moves`
#' @return A game node
play <- function(game, moves, notation = c("san", "uci", "xboard")) {

  # Get notation
  notation <- match.arg(notation)

  # Iterate over moves if necessary
  if (length(moves) == 1) {

    # Parse move in context
    if (notation == "san") {
      moves <- game$board()$parse_san(moves)
    } else if (notation == "uci") {
      moves <- game$board()$parse_uci(moves)
    } else if (notation == "xboard") {
      moves <- game$board()$parse_xboard(moves)
    }

    # Add move to mainline
    return(game$add_main_variation(moves))

  } else {

    # Add all moves to mainline
    return(purrr::reduce(moves, move, notation, .init = game))

  }
}

#' Branch game with next move
#' @param game A game node
#' @param moves Vector of one or more description of moves
#' @param notation Notation used for `moves`
#' @param enter Follow new branch to the end? Works like `git checkout`
#' @return A game node
line <- function(game, moves, notation = c("san", "uci", "xboard"),
                 enter = FALSE) {

  # Get notation
  notation <- match.arg(notation)

  # Must add variation to last move
  game <- back(game)

  # Handle first move
  move1 <- moves[1]
  moves <- moves[-1]

  # Parse move in context
  if (notation == "san") {
    move1 <- game$board()$parse_san(move1)
  } else if (notation == "uci") {
    move1 <- game$board()$parse_uci(move1)
  } else if (notation == "xboard") {
    move1 <- game$board()$parse_xboard(move1)
  }

  # Add branch
  game <- game$add_variation(move1)

  # Make other moves
  if (length(moves) > 0) {
    game <- play(game, moves, notation)
  }

  # Go gack to root it enter == TRUE
  if (enter) {
    return(game)
  } else {
    game <- back(game, length(moves)+1)
    return(variation(game, 1))
  }
}
