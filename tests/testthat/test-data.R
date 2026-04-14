atlas_funs <- list(
  jhu_tracts = jhu_tracts,
  jhu_wm = jhu_wm,
  icbm = icbm
)

for (nm in names(atlas_funs)) {
  atlas <- atlas_funs[[nm]]()

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
