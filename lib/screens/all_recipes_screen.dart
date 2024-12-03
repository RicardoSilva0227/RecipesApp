import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import 'recipe_detail_screen.dart';
import 'dart:async';  // Import for the Timer

class AllRecipesScreen extends StatefulWidget {
  @override
  _AllRecipesScreenState createState() => _AllRecipesScreenState();
}

class _AllRecipesScreenState extends State<AllRecipesScreen> {
  final RecipeService _recipeService = RecipeService();
  List<Recipe> _recipes = [];
  int _currentPage = 1;
  bool _isLoading = false;
  String _searchQuery = '';  // Store search query
  TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;  // Timer for debouncing

  @override
  void initState() {
    super.initState();
    _loadRecipes();  // Load recipes initially without a search query
  }

  // Load recipes based on the current page and the search query
  Future<void> _loadRecipes() async {
    setState(() => _isLoading = true); // Start loading indicator
    try {
      final recipes = await _recipeService.fetchRecipes(_currentPage, _searchQuery);
      if (mounted) {  // Check if widget is still mounted before calling setState
        setState(() {
          _recipes = recipes;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {  // Ensure widget is mounted before updating UI
        setState(() => _isLoading = false);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading recipes: $e')),
      );
    }
  }

  // Build the search bar for filtering recipes
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,  // Use the controller to manage the text field
        decoration: InputDecoration(
          labelText: 'Search for a recipe...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          prefixIcon: const Icon(Icons.search),
        ),
        onChanged: (query) {
          // Cancel the previous debouncing timer if it's still active
          if (_debounceTimer != null) {
            _debounceTimer!.cancel();
          }

          // Set a new debounce timer
          _debounceTimer = Timer(const Duration(milliseconds: 1000), () {
            setState(() {
              _searchQuery = query;  // Update the search query
            });
            _loadRecipes();  // Reload the recipes based on the search query
          });
        },
      ),
    );
  }

  // Pagination controls (next and previous buttons)
  Widget _buildPaginationControls() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: _currentPage > 1
                ? () {
                    setState(() => _currentPage--);
                    _loadRecipes();  // Reload recipes for the previous page
                  }
                : null,
            child: const Text('Previous'),
          ),
          Text('Page $_currentPage'),
          ElevatedButton(
            onPressed: () {
              setState(() => _currentPage++);
              _loadRecipes();  // Reload recipes for the next page
            },
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the timer when the widget is disposed
    if (_debounceTimer != null) {
      _debounceTimer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildSearchBar(),  // Add search bar on top
                Expanded(
                  child: ListView.builder(
                    itemCount: _recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = _recipes[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Image.network(
                            recipe.image,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.error, size: 60),
                          ),
                          title: Text(recipe.title),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeDetailScreen(recipeId: recipe.id),  // Navigate to details
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                _buildPaginationControls(),  // Add pagination controls
              ],
            ),
    );
  }
}
