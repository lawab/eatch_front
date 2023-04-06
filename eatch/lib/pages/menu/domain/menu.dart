class Menu {
  const Menu({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
  });

  final String id;
  final String imageUrl;
  final String title;
  final String description;
  final double price;
}
