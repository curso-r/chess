exec <- "stockfish"
if(WINDOWS) exec <- paste0(exec, ".exe")
if ( any(file.exists(exec)) ) {
  dest <- file.path(R_PACKAGE_DIR,  paste0('bin', R_ARCH))
  dir.create(dest, recursive = TRUE, showWarnings = FALSE)
  file.copy(exec, dest, overwrite = TRUE)
}
