class Recipe {
  final String id;
  final String title;
  final String image;
  final String imageType;
  final List<String> diets; // Dietary tags (e.g., vegan, gluten-free)
  final int servings; // Number of servings
  final int prepTime; // Prep time in minutes
  final int cookTime; // Cook time in minutes
  final int readyInMinutes; // Total time in minutes
  final List<String> cuisines; // Cuisines (e.g., Italian, Mexican)
  final List<String> dishTypes; // Dish types (e.g., main course, dessert)
  final List<Map<String, dynamic>> extendedIngredients; // Ingredients
  final String? instructions; // Instructions (could be a string or a list)

  Recipe({
    required this.id,
    required this.title,
    required this.image,
    required this.imageType,
    required this.diets,
    required this.servings,
    required this.prepTime,
    required this.cookTime,
    required this.readyInMinutes,
    required this.cuisines,
    required this.dishTypes,
    required this.extendedIngredients,
    this.instructions,
  });

  // Convert JSON data into Recipe objects
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'].toString(),
      title: json['title'],
      image: json['image'],
      imageType: json['imageType'],
      diets: List<String>.from(json['diets'] ?? []),
      servings: json['servings'] ?? 0,
      prepTime: json['prepTime'] ?? 0,
      cookTime: json['cookTime'] ?? 0,
      readyInMinutes: json['readyInMinutes'] ?? 0,
      cuisines: List<String>.from(json['cuisines'] ?? []),
      dishTypes: List<String>.from(json['dishTypes'] ?? []),
      extendedIngredients: List<Map<String, dynamic>>.from(json['extendedIngredients'] ?? []),
      instructions: json['instructions'],
    );
  }
}
