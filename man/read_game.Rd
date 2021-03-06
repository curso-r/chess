% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pgn.R
\name{read_game}
\alias{read_game}
\title{Read a game from a PGN}
\usage{
read_game(file, n_max = Inf)
}
\arguments{
\item{file}{File or connection to read from}

\item{n_max}{Maximum number of games to read}
}
\value{
A game node or list of game nodes
}
\description{
Read a \code{.pgn} file with one or more annotated games; if there is more than 1
game in the file, a list is returned (which you can access with [\code{[[}()]).
Some sample \code{.pgn} files are included in the package. See \code{vignette("games")}
for more information.
}
