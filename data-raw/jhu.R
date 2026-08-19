# Historical build script for the pre-2.0 `jhu_3d` data object.
#
# Kept as a record of how the original fsaverage5 tract meshes were assembled.
# It cannot be run as-is: `data-raw/mesh3d/` is no longer distributed with the
# repository, `as_ggseg3d_atlas()` and the `jhu_3d` object were both removed in
# 2.0.0, and it depends on ggtern and geomorph, neither of which the package
# lists. The current atlases are built by `make_atlas.R`, `create-tract-atlas.R`
# and `build-tract-cores.R`.

library(tidyverse)
library(ggseg)

nn <- here::here()
folder <- "/data-raw/mesh3d/JHU_tracts_vis.fsaverage5/"

ff <- read_csv2(paste0(nn, folder, "annot2filename.csv")) |>
  rename(files = `filename (*.ply)`, area2 = JHU) |>
  select(2:6, annot) |>
  mutate(
    colour = ggtern::rgb2hex(R, G, B),
    area = gsub(" L$| R$", "", area2)
  ) |>
  select(-R, -G, -B) |>
  mutate(hemi = "subcort", surf = "LCBC", atlas = "jhu_3d") |>
  separate(files, into = c(NA, "roi"), sep = "_") |>
  mutate(
    colour = ifelse(area == lead(area), lead(colour), colour),
    colour = ifelse(is.na(colour), lag(colour), colour),
    label = annot,
    annot = gsub("rh_|lh_", "", annot)
  ) |>
  select(-area2)

mesh <- lapply(
  list.files(paste0(nn, folder), pattern = "ply", full.names = TRUE),
  geomorph::read.ply,
  ShowSpecimen = FALSE
)

ff$mesh <- list(vb = 1)
for (i in seq_along(mesh)) {
  ff$mesh[[i]] <- list(vb = mesh[[i]]$vb, it = mesh[[i]]$it)
}

jhu_3d <- ff |>
  group_by(atlas, surf, hemi) |>
  nest() |>
  as_ggseg3d_atlas()

ggseg3d(atlas = jhu_3d, glassbrain = .6, glassbrain_hemisphere = "left")

usethis::use_data(jhu_3d, overwrite = TRUE, internal = FALSE, compress = "xz")
