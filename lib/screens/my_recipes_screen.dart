import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import 'recipe_detail_screen.dart';
import 'add_recipe_screen.dart';

class MyRecipesScreen extends StatefulWidget {
  @override
  _MyRecipesScreenState createState() => _MyRecipesScreenState();
}

class _MyRecipesScreenState extends State<MyRecipesScreen> {
  final RecipeService _recipeService = RecipeService();
  List<Recipe> _myRecipes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMyRecipes();
  }

  // Fetch the user's recipes
  Future<void> _loadMyRecipes() async {
    setState(() => _isLoading = true);
    try {
      final recipes = await _recipeService.fetchMyRecipes();
      if (mounted) {
        setState(() => _myRecipes = recipes);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading your recipes: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Delete a recipe
  Future<void> _deleteRecipe(String recipeId) async {
    try {
      // await _recipeService.deleteRecipe(recipeId);
      setState(() {
        _myRecipes.removeWhere((recipe) => recipe.id == recipeId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recipe deleted successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting recipe: $e')),
      );
    }
  }

  // Navigate to AddRecipeScreen
  void _navigateToAddRecipe() async {
    final addedRecipe = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddRecipeScreen()),
    );

    if (addedRecipe != null) {
      setState(() => _myRecipes.add(addedRecipe));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _myRecipes.isEmpty
              ? const Center(child: Text('No recipes found. Add some!'))
              : ListView.builder(
                  itemCount: _myRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = _myRecipes[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Image.network(
                          recipe.image,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.error, size: 60),
                        ),
                        title: Text(recipe.title),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteRecipe(recipe.id),
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailScreen(recipeId: recipe.id),
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddRecipe,
        child: const Icon(Icons.add),
      ),
    );
  }
}
