class Product {
  const Product(
      {required this.id,
      required this.imageUrl,
      required this.title,
      required this.description,
      required this.price,
      required this.availableQuantity,
      this.avgRating = 0,
      this.numRatings = 0,
      required this.categories});

  final String id;
  final String imageUrl;
  final String title;
  final String description;
  final double price;
  final int availableQuantity;
  final double avgRating;
  final int numRatings;
  final List<String> categories;
}
