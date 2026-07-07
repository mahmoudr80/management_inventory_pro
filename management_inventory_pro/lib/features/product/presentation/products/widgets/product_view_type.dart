/// The available layout modes for the Product Catalog.
///
/// Lives at the cubit level (not inside a widget file) because it is part
/// of the feature's state contract, not presentation detail — both the
/// state class and any future consumer (e.g. persisted user preference)
/// need it independent of any specific widget.
enum ProductViewType {
  list,
  grid,
}
