class PosProduct {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final bool outOfStock;
  final String category;

  const PosProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.outOfStock = false,
    this.category = 'General',
  });
}
