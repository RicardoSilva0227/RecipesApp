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
}
