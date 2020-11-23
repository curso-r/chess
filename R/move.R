
#' Make moves and create variations
#'
#' @description Adding moves to a game works roughly in the same way as PGN.
#' Strings are added as single moves, and lists are added as variations
#' (siblings) to the last move made. After adding moves, the game node returned
#' corresponds to the last move of the mainline. See the examples for more
#' information.
#'
#' @param game A game node
#' @param ... Sequence of moves (lists are converted to a variation the same
#' way parentheses work in PGN)
#' @param notation Notation used for `moves` (san, uci, or xboard)
#'
#' @examples
#' \donttest{
#' game() %>%
#'   move("e4") %>%
#'   move("e5") %>%
#'   move(list("e6")) %>%
#'   move(list("d5", "Bc4", "dxc4")) %>%
#'   back() %>%
#'   str()
#'
#' game() %>%
#'   move("e4") %>%
#'   move("e5") %>%
#'   move(list("e6"), list("d5", "Bc4", "dxc4")) %>%
#'   back() %>%
#'   str()
#'
#' game() %>%
#'   move("e4", "e5", list("e6"), list("d5", "Bc4", "dxc4")) %>%
#'   back() %>%
#'   str()
#' }
#'
#' @return A game node
#' @export
move <- function(game, ..., notation = c("san", "uci", "xboard")) {
  return(move_(game, list(...), notation))
}

#' Make moves and create variations
#' @param game A game node
#' @param moves List of moves
#' @param notation Notation used for moves
#' @return A game node
move_ <- function(game, moves, notation = c("san", "uci", "xboard")) {

  # Base case
  if (length(moves) == 0) {
    return(game)
  }

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
    game <- line(game, move11, notation)
    game <- move_(game, moves1, notation)
    eply <- game$ply()

    # Go back to root of variation
    game <- back(game, eply - sply + 1)
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

  # Extract comment
  comment <- sub("\\}.*", "", sub(".*\\{", "", moves, perl = TRUE), perl = TRUE)
  comment <- if (comment == moves) "" else sub(" *$", "", sub("^ *", "", comment, perl = TRUE), perl = TRUE)
  moves <- sub("\\{.+\\}", "", moves)
  moves <- sub(" *$", "", sub("^ *", "", moves, perl = TRUE), perl = TRUE)

  # Extract NAG
  nag <- glyph_to_nag(substring(moves, regexpr(nag_regex, moves, perl = TRUE)))
  nag <- if (is.null(nag)) list() else list(nag)
  moves <- sub(nag_regex, "", moves, perl = TRUE)

  # Parse move in context
  moves <- parse_move(game, moves, notation)

  # Add move to mainline
  return(game$add_main_variation(moves, comment = comment, nags = nag))
}

#' Branch game with next move
#' @param game A game node
#' @param moves Vector of one or more description of moves
#' @param notation Notation used for `moves`
#' @return A game node
line <- function(game, moves, notation = c("san", "uci", "xboard")) {

  # Get notation
  notation <- match.arg(notation)

  # Must add variation to last move
  game <- back(game)

  # Handle first move
  move1 <- moves[1]
  moves <- moves[-1]

  # Extract comment
  comment <- sub("\\}.*", "", sub(".*\\{", "", move1, perl = TRUE), perl = TRUE)
  comment <- if (comment == move1) "" else sub(" *$", "", sub("^ *", "", comment, perl = TRUE), perl = TRUE)
  move1 <- sub("\\{.+\\}", "", move1)
  move1 <- sub(" *$", "", sub("^ *", "", move1, perl = TRUE), perl = TRUE)

  # Extract NAG
  nag <- glyph_to_nag(substring(move1, regexpr(nag_regex, move1, perl = TRUE)))
  nag <- if (is.null(nag)) list() else list(nag)
  move1 <- sub(nag_regex, "", move1)

  # Parse move in context
  move1 <- parse_move(game, move1, notation)

  # Add branch
  game <- game$add_variation(move1, comment = comment, nags = nag)

  return(game)
}

#' Parse move in context
#' @param game A game node
#' @param moves A move string
#' @param notation Notation used for `move`
#' @return A move object
parse_move <- function(game, moves, notation = c("san", "uci", "xboard")) {
  notation <- match.arg(notation)
  if (notation == "san") {
    moves <- game$board()$parse_san(moves)
  } else if (notation == "uci") {
    moves <- game$board()$parse_uci(moves)
  } else if (notation == "xboard") {
    moves <- game$board()$parse_xboard(moves)
  }
}
