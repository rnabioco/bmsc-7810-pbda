library(DiagrammeR)
library(DiagrammeRsvg)
library(rsvg)
library(here)
library(tiff)
gv_fn <- here("_posts/2022-10-03-intro-to-r-language/img/reco.gv")

inch_to_px <- function(x, dpi = 300) { x * dpi}
h_inch <- 5
asp_ratio <- 2.0
h <- inch_to_px(h_inch)
w <- inch_to_px(h_inch * asp_ratio)
grViz(gv_fn, width = w, height = h) %>%
  export_svg %>%
  charToRaw %>%
  rsvg_pdf("r-ecosystem.pdf")
