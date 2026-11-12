#!/bin/sh
# Remove knitr/tikzDevice intermediates without touching tikz-template.tex.
set -eu
cd "$(dirname "$0")"
rm -f tikz[0-9a-f]*.dvi \
      tikz[0-9a-f]*.tex \
      tikz[0-9a-f]*.log \
      tikz[0-9a-f]*.aux \
      tikz[0-9a-f]*.fls \
      tikz[0-9a-f]*.fdb_latexmk \
      tikz[0-9a-f]*.md5 \
      tikz[0-9a-f]*.synctex.gz 2>/dev/null || true
# Intermediate DVI next to SVG figures (including freeze cache copies)
find . -type f \( \
  -path '*_files/figure-*/*.dvi' \
  -o -path '*/figure-revealjs/*.dvi' \
\) -delete 2>/dev/null || true
