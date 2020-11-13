
#' Create subtree of game with next move
#' @param game A game node
#' @param moves A list or vector of moves (each sublist will be converted to a
#' variation the same way parentheses work for PGN)
#' @param notation Notation used for `moves`
#' @return A game node
#' @export
move <- function(game, moves, notation = c("san", "uci", "xboard")) {

  # Base case
  if (length(moves) == 0) return(game)

  move1 <- moves[[1]]
  moves <- moves[-1]

  # Make first move
  if (is.list(move1)) {

    move11 <- move1[[1]]
    moves1 <- move1[-1]

    game <- back(game)
    sply <- game$ply()
    game <- line(game, move11, notation, TRUE)
    game <- move(game, moves1, notation)
    eply <- game$ply()

    game <- back(game, eply-sply)
    game <- variation(game, 1)

    return(move(game, moves, notation))
  } else {
    game <- play(game, move1, notation)
    return(move(game, moves, notation))
  }
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

    return(game$add_main_variation(moves))

  } else {

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

  if (enter) {
    return(game)
  } else {
    return(back(game, length(moves)+1))
  }
}
