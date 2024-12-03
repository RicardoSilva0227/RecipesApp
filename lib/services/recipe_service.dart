import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/recipe.dart';
import '../utils/request_manager.dart';
import '../config/config.dart';

class RecipeService {
  final String _baseUrl = 'https://api.spoonacular.com/recipes';

  // Fetch recipes, optionally filter by search query
  Future<List<Recipe>> fetchRecipes(int page, String searchQuery) async {
    try {
      final response = await http.get(Uri.parse(
        '$_baseUrl/complexSearch?query=$searchQuery&apiKey=${AppConfig.apiKey}&number=10&offset=${(page - 1) * 10}',
      ));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final recipes = (data['results'] as List)
            .map((recipeData) => Recipe.fromJson(recipeData))
            .toList();
        return recipes;
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchRecipeDetails(String recipeId) async {
    final canRequest = await RequestManager.canMakeRequest();
    if (!canRequest) {
      throw Exception('Daily request limit reached. Try again tomorrow.');
    }

    final response = await http.get(Uri.parse(
      '$_baseUrl/$recipeId/information?apiKey=${AppConfig.apiKey}',
    ));

    if (response.statusCode == 200) {
      await RequestManager.incrementRequestCount();
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load recipe details');
    }
  }

  Future<List<Recipe>> fetchMyRecipes() async {
  // Mock API call or fetch from a database
 return [
    Recipe(
      id: '1',
      title: 'Test Recipe 1',
      image: '',
      imageType: 'jpg',
      diets: ['Vegan'],
      servings: 2,
      prepTime: 10,
      cookTime: 20,
      readyInMinutes: 30,
      cuisines: ['American'],
      dishTypes: ['Dessert'],
      extendedIngredients: [
        {'name': 'Ingredient 1', 'amount': '100g'},
        {'name': 'Ingredient 2', 'amount': '50ml'},
      ],
      instructions: 'Do something.',
    ),
  ];
}

Future<Recipe> addRecipe({
  required String title,
  required String image,
  required List<Map<String, dynamic>> extendedIngredients,
  required String? instructions,
  int servings = 1,
  int prepTime = 10,
  int cookTime = 20,
  int readyInMinutes = 30,
  String imageType = 'jpg',
  List<String> diets = const [],
  List<String> cuisines = const [],
  List<String> dishTypes = const [],
}) async {
  // Mock API call to save a recipe and return it
  return Recipe(
    id: DateTime.now().toIso8601String(), // Unique ID based on current time
    title: title,
    image: image,
    imageType: imageType,
    diets: diets,
    servings: servings,
    prepTime: prepTime,
    cookTime: cookTime,
    readyInMinutes: readyInMinutes,
    cuisines: cuisines,
    dishTypes: dishTypes,
    extendedIngredients: extendedIngredients,
    instructions: instructions,
  );
}
}

Future<void> deleteRecipe(String recipeId) async {
  // Mock API call to delete a recipe
}