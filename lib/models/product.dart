class Product {
  final String title;
  final String price;
  final String rating;
  final String image;
  final String link;

  Product({
    required this.title,
    required this.price,
    required this.rating,
    required this.image,
    required this.link,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      title: json["title"] ?? "",
      price: json["price"] ?? "",
      rating: json["rating"] ?? "",
      image: json["image"] ?? "",
      link: json["link"] ?? "",
    );
  }
}
