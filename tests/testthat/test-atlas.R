describe("jhu atlas", {
  it("is a ggseg_atlas", {
    expect_s3_class(jhu(), "ggseg_atlas")
  })

  it("is valid", {
    expect_true(ggseg.formats::is_ggseg_atlas(jhu()))
  })

  it("is subcortical type", {
    expect_equal(jhu()$type, "subcortical")
  })

  it("has expected regions", {
    regions <- ggseg.formats::atlas_regions(jhu())
    expect_equal(length(regions), 11)
    expect_true("Anterior thalamic radiation" %in% regions)
    expect_true("Corticospinal tract" %in% regions)
  })

  it("has a palette", {
    expect_false(is.null(jhu()$palette))
    expect_gt(length(jhu()$palette), 0)
  })

  it("has meshes for 3D rendering", {
    expect_false(is.null(jhu()$data$meshes))
    expect_equal(nrow(jhu()$data$meshes), 20)
  })
})
