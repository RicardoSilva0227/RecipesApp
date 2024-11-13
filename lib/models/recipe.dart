class Recipe {
  final String id;
  final String title;
  final String image;
  final String imageType;

  Recipe({required this.title, required this.image, required this.id, required this.imageType});

  // Convert JSON data into Recipe objects
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      title: json['title'],
      image: json['image'],
      imageType: json['imageType'],
      id: json['id'].toString(),
    );
  }
}
