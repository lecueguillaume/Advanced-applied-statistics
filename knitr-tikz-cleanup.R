# Shared TikZ temp-file cleanup for Quarto slides.
# Used by .Rprofile and by the early-exit knit_exit() recipe in usefull.txt.

cleanup_tikz_temps <- function(dir = ".") {
  patterns <- c(
    "^tikz[0-9a-f]+\\.(dvi|tex|log|aux|fls|fdb_latexmk|synctex\\.gz|md5)$",
    "^tikz[0-9a-f]+-figure\\d+\\.(dvi|tex|log|aux)$"
  )
  junk <- unique(unlist(lapply(patterns, list.files, path = dir, full.names = TRUE)))
  fig_dvi <- list.files(
    dir,
    pattern = "\\.dvi$",
    recursive = TRUE,
    full.names = TRUE
  )
  fig_dvi <- fig_dvi[grepl("_files[/\\\\]figure-", fig_dvi)]
  junk <- unique(c(junk, fig_dvi))
  if (length(junk)) unlink(junk, force = TRUE)
  invisible(length(junk))
}

register_tikz_cleanup_hooks <- function() {
  if (!requireNamespace("knitr", quietly = TRUE)) return(invisible(FALSE))
  if (isTRUE(getOption("aidams.tikz_cleanup_registered"))) return(invisible(TRUE))

  prev_doc_hook <- knitr::knit_hooks$get("document")
  knitr::knit_hooks$set(document = function(x) {
    cleanup_tikz_temps()
    if (is.function(prev_doc_hook)) prev_doc_hook(x) else x
  })

  options(aidams.tikz_cleanup_registered = TRUE)
  invisible(TRUE)
}

register_tikz_cleanup_hooks()
