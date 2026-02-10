# ggsegJHU 2.0.0

## Breaking changes

* `jhu` is now a `ggseg_atlas` object (from ggseg.formats) containing
  both 2D and 3D data. The separate `jhu_3d` object has been removed.

* Use `ggplot() + ggseg::geom_brain(atlas = jhu)` for 2D plots and
  `ggseg3d::ggseg3d(atlas = jhu)` for 3D plots -- both from the same
  object.

* `ggseg.formats` is now a hard dependency (in Depends).

* Package URLs updated from `LCBC-UiO` to `ggseg` GitHub organisation.

* 2D labels harmonised with 3D labels: `fmajor`/`fminor` renamed to
  `fmaj`/`fmin`, `lh_ifof`/`rh_ifof` to `lh_fof`/`rh_fof`,
  `lh_unc`/`rh_unc` to `lh_cnf`/`rh_unf`.

# ggsegJHU 1.0.01

* adapted atlases to ggseg <= 1.6.0
* Added a `NEWS.md` file to track changes to the package.
