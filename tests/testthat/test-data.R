atlas_specs <- list(
  jhu_tracts = list(fun = jhu_tracts, class = "tract_atlas"),
  jhu_wm = list(fun = jhu_wm, class = "subcortical_atlas")
)

for (nm in names(atlas_specs)) {
  spec <- atlas_specs[[nm]]
  atlas <- spec$fun()

  describe(paste(nm, "atlas"), {
    it("is a ggseg_atlas", {
      expect_s3_class(atlas, "ggseg_atlas")
      expect_s3_class(atlas, spec$class)
    })

    it("is valid", {
      expect_true(ggseg.formats::is_ggseg_atlas(atlas))
    })

    it("gives every region a colour", {
      palette <- ggseg.formats::atlas_palette(atlas)
      expect_setequal(names(palette), ggseg.formats::atlas_labels(atlas))
      expect_false(anyNA(palette))
    })

    it("draws every region in at least one view", {
      geom <- ggseg.formats::atlas_polygons(atlas)
      expect_true(all(ggseg.formats::atlas_labels(atlas) %in% geom$label))
    })

    it("renders with ggseg3d", {
      skip_if_not_installed("ggseg3d")
      skip_if_not_installed("ggseg.meshes")
      p <- ggseg3d::ggseg3d(atlas = atlas)
      expect_s3_class(
        p,
        c("plotly", "htmlwidget")
      )
    })
  })
}

describe("jhu_tracts anatomy", {
  # FSL orders the uncinate fasciculus before the temporal part of the SLF;
  # reading the metadata in the opposite order silently swaps two real tracts,
  # which no structural check would catch. Pin them to the anatomy: the
  # uncinate hooks around the limen insulae, well anterior and inferior to the
  # posterior-temporal SLF.
  centerlines <- ggseg.formats::atlas_centerlines(jhu_tracts())

  centroid <- function(label) {
    colMeans(centerlines$points[[match(label, centerlines$label)]])
  }

  it("places the uncinate anterior to the temporal SLF", {
    for (hemi in c("lh", "rh")) {
      expect_gt(
        centroid(paste0(hemi, "_uncf"))[2],
        centroid(paste0(hemi, "_sltf"))[2]
      )
    }
  })

  it("places the uncinate inferior to the temporal SLF", {
    for (hemi in c("lh", "rh")) {
      expect_lt(
        centroid(paste0(hemi, "_uncf"))[3],
        centroid(paste0(hemi, "_sltf"))[3]
      )
    }
  })
})
