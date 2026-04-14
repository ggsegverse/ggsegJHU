atlas_names <- c(
  "jhu_tracts", "jhu_wm", "icbm"
)

for (nm in atlas_names) {
  atlas <- do.call(nm, list())

  describe(paste(nm, "atlas"), {
    it("is a ggseg_atlas", {
      expect_s3_class(atlas, "ggseg_atlas")
      expect_s3_class(atlas, "subcortical_atlas")
    })

    it("is valid", {
      expect_true(ggseg.formats::is_ggseg_atlas(atlas))
    })

    it("renders with ggseg3d", {
      skip_if_not_installed("ggseg3d")
      skip_if_not_installed("ggseg.meshes")
      p <- ggseg3d::ggseg3d(atlas = atlas)
      expect_s3_class(
        p, c("plotly", "htmlwidget")
      )
    })
  })
}
