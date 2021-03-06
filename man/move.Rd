% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/move.R
\name{move}
\alias{move}
\title{Make moves and create variations}
\usage{
move(game, ..., notation = c("san", "uci", "xboard"))
}
\arguments{
\item{game}{A game node}

\item{...}{Sequence of moves (lists are converted to a variation the same
way parentheses work in PGN)}

\item{notation}{Notation used for \code{moves} (san, uci, or xboard)}
}
\value{
A game node
}
\description{
Adding moves to a game works roughly in the same way as PGN.
Strings are added as single moves, and lists are added as variations
(siblings) to the last move made. After adding moves, the game node returned
corresponds to the last move of the mainline. See \code{vignette("chess")} for
more information.
}
