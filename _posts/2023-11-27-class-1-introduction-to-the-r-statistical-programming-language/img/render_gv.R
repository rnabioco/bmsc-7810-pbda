library(DiagrammeR)
library(DiagrammeRsvg)
library(rsvg)
library(here)
library(tiff)
wd <- "_posts/2023-11-27-class-1-introduction-to-the-r-statistical-programming-language/img"
gv_fn <- here(file.path(wd, "reco.gv"))

inch_to_px <- function(x, dpi = 300) { x * dpi}
h_inch <- 5
asp_ratio <- 2.0
h <- inch_to_px(h_inch)
w <- inch_to_px(h_inch * asp_ratio)
grViz(gv_fn, width = w, height = h) %>%
  export_svg %>%
  charToRaw %>%
  rsvg_pdf(file.path(wd, "r-ecosystem.pdf"))

grViz(gv_fn, width = w, height = h) %>%
  export_svg %>%
  charToRaw %>%
  rsvg_png(file.path(wd, "r-ecosystem.png"),
           width = w, height = h)
