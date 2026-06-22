# ggsegJHU 2.0.1

- Atlas 2D geometry migrated to the sf-optional `brain_polygons` format
  (`ggseg.formats` 0.0.3). The atlases now render without `sf` and its
  GDAL/GEOS/PROJ system libraries, enabling wasm and air-gapped installs.
  Plots are unchanged.

# ggsegJHU 2.0.0

## Breaking changes
* `jhu` and `jhu_3d` data objects have been removed
* Use `jhu_tracts()` and `jhu_labels()` accessor functions instead
* `ggseg.formats` is now a hard dependency

## Minor changes
* Added `icbm()` atlas (formerly in `ggsegICBM` package)
* Package URLs updated to `ggsegverse` GitHub organisation

# ggsegJHU 1.0.01
* Adapted atlases to ggseg <= 1.6.0
