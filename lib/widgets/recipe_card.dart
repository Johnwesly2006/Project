import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({super.key, required this.recipe, required this.favorite, required this.onTap, required this.onFavorite});
  final Recipe recipe; final bool favorite; final VoidCallback onTap; final VoidCallback onFavorite;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(clipBehavior: Clip.antiAlias, child: InkWell(onTap: onTap, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Stack(children: [SizedBox(height: 156, width: double.infinity, child: recipe.imagePath != null ? Image.asset(recipe.imagePath!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _fallback(colors)) : _fallback(colors)),
        Positioned(right: 8, top: 8, child: Material(color: colors.surface.withValues(alpha: .92), shape: const CircleBorder(), child: IconButton(tooltip: favorite ? 'Remove favourite' : 'Add to favourites', onPressed: onFavorite, icon: Icon(favorite ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: favorite ? colors.error : colors.primary))))]),
      Padding(padding: const EdgeInsets.fromLTRB(13, 10, 13, 13), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(recipe.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)), const SizedBox(height: 4), Text('${recipe.region.isEmpty ? recipe.origin : recipe.region} · ${recipe.totalMinutes} min', maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant))]))
    ])));
  }
  Widget _fallback(ColorScheme c) => ColoredBox(color: c.primaryContainer, child: Center(child: Icon(Icons.rice_bowl_rounded, size: 58, color: c.onPrimaryContainer)));
}
