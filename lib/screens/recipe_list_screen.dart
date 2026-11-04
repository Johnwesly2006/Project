import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/recipe.dart';
import '../services/recipe_store.dart';
import '../widgets/recipe_card.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key, required this.onOpenRecipe});
  final ValueChanged<Recipe> onOpenRecipe;

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final _search = TextEditingController();
  String _query = '';
  String _category = 'All';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<RecipeStore>();
    final colors = Theme.of(context).colorScheme;
    if (store.isLoading && !store.hasLoaded) {
      return const Center(child: CircularProgressIndicator());
    }
    if (store.errorMessage != null && !store.hasLoaded) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(store.errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: store.load,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ]),
        ),
      );
    }
    final categories = <String>{'All', ...store.allRecipes.map((r) => r.category)}.toList()..sort();
    final matches = store.allRecipes.where((recipe) {
      final searchable = '${recipe.name} ${recipe.region} ${recipe.origin} ${recipe.category} ${recipe.diet}'.toLowerCase();
      return (_query.isEmpty || searchable.contains(_query.toLowerCase())) &&
          (_category == 'All' || recipe.category == _category);
    }).toList();

    return CustomScrollView(slivers: [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        sliver: SliverToBoxAdapter(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Find your next favourite', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 5),
            Text('${store.allRecipes.length} Indian recipes to explore', style: TextStyle(color: colors.onSurfaceVariant)),
            const SizedBox(height: 16),
            TextField(
              controller: _search,
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Search dishes, regions, ingredients…',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty ? null : IconButton(
                  onPressed: () { _search.clear(); setState(() => _query = ''); },
                  icon: const Icon(Icons.close),
                ),
              ),
            ),
            if (_query.isNotEmpty) _suggestions(context, matches),
            const SizedBox(height: 12),
            SizedBox(
              height: 42,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: categories.map((category) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: _category == category,
                    onSelected: (_) => setState(() => _category = category),
                  ),
                )).toList(),
              ),
            ),
          ]),
        ),
      ),
      if (matches.isEmpty)
        const SliverFillRemaining(hasScrollBody: false, child: Center(child: Text('No recipes found. Try another search.')))
      else
        SliverPadding(
          padding: const EdgeInsets.all(14),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 260, mainAxisExtent: 244,
              crossAxisSpacing: 12, mainAxisSpacing: 12,
            ),
            itemCount: matches.length,
            itemBuilder: (_, index) {
              final recipe = matches[index];
              return RecipeCard(
                recipe: recipe,
                favorite: store.isFavorite(recipe.id),
                onTap: () => widget.onOpenRecipe(recipe),
                onFavorite: () => store.toggleFavorite(recipe.id),
              );
            },
          ),
        ),
    ]);
  }

  Widget _suggestions(BuildContext context, List<Recipe> recipes) => ConstrainedBox(
    constraints: const BoxConstraints(maxHeight: 260),
    child: Card(
      child: ListView(
        shrinkWrap: true,
        children: recipes.take(5).map((recipe) => ListTile(
          leading: SizedBox(
            width: 48, height: 48,
            child: recipe.imagePath == null
                ? const Icon(Icons.rice_bowl)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(recipe.imagePath!, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.rice_bowl)),
                  ),
          ),
          title: Text(recipe.name),
          subtitle: Text(recipe.region),
          onTap: () { FocusScope.of(context).unfocus(); widget.onOpenRecipe(recipe); },
        )).toList(),
      ),
    ),
  );
}
