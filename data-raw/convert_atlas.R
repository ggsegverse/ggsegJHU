library(ggseg.formats)

load(here::here("data/jhu.rda"))
load(here::here("data/jhu_3d.rda"))

label_map <- c(
  "fmajor"  = "fmaj",
  "fminor"  = "fmin",
  "lh_ifof" = "lh_fof",
  "rh_ifof" = "rh_fof",
  "lh_unc"  = "lh_cnf",
  "rh_unc"  = "rh_unf"
)

sf_data <- jhu$data
for (old in names(label_map)) {
  sf_data$label[sf_data$label == old] <- label_map[[old]]
}

dupes <- sf_data$label == "rh_atr" & sf_data$region == "Corticospinal tract"
dupes[is.na(dupes)] <- FALSE
sf_data$label[dupes] <- "rh_cst"

dupes2 <- sf_data$label == "lh_atr" & sf_data$region == "Corticospinal tract"
dupes2[is.na(dupes2)] <- FALSE
sf_data$label[dupes2] <- "lh_cst"

sf_data$label[sf_data$label == "csf" & !is.na(sf_data$label)] <- NA_character_

jhu$data <- sf_data

jhu <- convert_legacy_brain_atlas(
  atlas_2d = jhu,
  atlas_3d = jhu_3d
)

stopifnot(is_ggseg_atlas(jhu))
print(jhu)

save(jhu, file = here::here("data/jhu.rda"), compress = "xz")
file.remove(here::here("data/jhu_3d.rda"))

brain_pals <- list()
brain_pals[[jhu$atlas]] <- jhu$palette
save(brain_pals, file = here::here("R/sysdata.rda"), compress = "xz")
