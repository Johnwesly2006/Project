import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/recipe.dart';

class RecipeStore extends ChangeNotifier {
  RecipeStore({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;
  static const _recipesKey = 'tadka.personalRecipes.v1';
  static const _favoritesKey = 'tadka.favorites.v1';

  List<Recipe> _catalogRecipes = const [];
  List<Recipe> _personalRecipes = const [];
  Set<String> _favoriteIds = {};
  SharedPreferences? _preferences;
  bool _isLoading = false;
  bool _hasLoaded = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get hasLoaded => _hasLoaded;
  String? get errorMessage => _errorMessage;
  List<Recipe> get allRecipes => List.unmodifiable([
        ..._personalRecipes,
        ..._catalogRecipes,
      ]);
  List<Recipe> get favoriteRecipes =>
      allRecipes.where((recipe) => _favoriteIds.contains(recipe.id)).toList();
  int get favoriteCount => _favoriteIds.length;

  Recipe? findById(String id) {
    for (final recipe in allRecipes) {
      if (recipe.id == id) return recipe;
    }
    return null;
  }

  bool isFavorite(String id) => _favoriteIds.contains(id);

  Future<void> load() async {
    if (_isLoading) return;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final jsonText = await _bundle.loadString('assets/data/recipes.json');
      final decoded = jsonDecode(jsonText) as List<dynamic>;
      final catalog = decoded
          .whereType<Map<String, dynamic>>()
          .map(Recipe.fromJson)
          .toList(growable: false);
      final preferences = await SharedPreferences.getInstance();
      final savedText = preferences.getString(_recipesKey);
      final savedJson = savedText == null ? const [] : jsonDecode(savedText);
      final personal = (savedJson as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map(Recipe.fromJson)
          .toList(growable: false);
      _catalogRecipes = catalog;
      _personalRecipes = personal;
      _favoriteIds = preferences.getStringList(_favoritesKey)?.toSet() ?? {};
      _preferences = preferences;
      _hasLoaded = true;
    } catch (error) {
      _errorMessage =
          'We could not load the recipe collection. Check the app data and try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addRecipe({
    required String name,
    required String origin,
    required String diet,
    required String category,
    required List<String> ingredients,
    required String method,
    required int prepMinutes,
    required int cookMinutes,
    required String difficulty,
    required List<String> steps,
    int? calories,
  }) async {
    final recipe = Recipe(
      id: 'personal-${DateTime.now().microsecondsSinceEpoch}',
      name: name.trim(),
      origin: origin.trim(),
      region: 'My recipes',
      diet: diet,
      category: category,
      ingredients: ingredients,
      method: method.trim(),
      prepTime: '$prepMinutes min',
      cookTime: '$cookMinutes min',
      totalMinutes: prepMinutes + cookMinutes,
      difficulty: difficulty,
      steps: steps,
      calories: calories,
      imagePath: null,
      imageAlt: '${name.trim()} recipe illustration',
      isPersonal: true,
    );
    final updated = [recipe, ..._personalRecipes];
    await _preferences?.setString(
      _recipesKey,
      jsonEncode(updated.map((item) => item.toJson()).toList()),
    );
    _personalRecipes = updated;
    notifyListeners();
  }

  Future<void> toggleFavorite(String recipeId) async {
    final updated = {..._favoriteIds};
    if (!updated.add(recipeId)) updated.remove(recipeId);
    await _preferences?.setStringList(_favoritesKey, updated.toList());
    _favoriteIds = updated;
    notifyListeners();
  }
}
