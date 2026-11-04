import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart'; import '../services/recipe_store.dart'; import '../widgets/recipe_card.dart';
class FavoritesScreen extends StatelessWidget {
 const FavoritesScreen({super.key, required this.onOpenRecipe}); final ValueChanged<Recipe> onOpenRecipe;
 @override Widget build(BuildContext context) { final store=context.watch<RecipeStore>(); final recipes=store.favoriteRecipes; if(recipes.isEmpty) return Center(child: Padding(padding: const EdgeInsets.all(30), child: Column(mainAxisSize: MainAxisSize.min, children:[Icon(Icons.favorite_border, size:56, color:Theme.of(context).colorScheme.primary), const SizedBox(height:12), Text('Your favourites will live here', style:Theme.of(context).textTheme.titleLarge), const SizedBox(height:6), const Text('Tap the heart on a recipe to save it.', textAlign:TextAlign.center)]))); return GridView.builder(padding: const EdgeInsets.all(14), gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent:260, mainAxisExtent:244, crossAxisSpacing:12, mainAxisSpacing:12), itemCount:recipes.length, itemBuilder:(_,i){final r=recipes[i]; return RecipeCard(recipe:r, favorite:true, onTap:()=>onOpenRecipe(r), onFavorite:()=>store.toggleFavorite(r.id));}); }
}
