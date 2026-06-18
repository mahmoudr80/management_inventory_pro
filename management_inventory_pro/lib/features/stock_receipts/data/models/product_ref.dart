/// Lightweight reference to a product — just enough to display and
/// select one in a dropdown. Swap in your real product model's fields
/// here once a catalog endpoint exists.
class ProductRef {
  final String id;
  final String name;
  final String? sku;

  const ProductRef({
    required this.id,
    required this.name,
    this.sku,
  });
}
