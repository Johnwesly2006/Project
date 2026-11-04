import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/add_recipe_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/recipe_detail_screen.dart';
import 'screens/recipe_list_screen.dart';
import 'services/recipe_store.dart';
import 'models/recipe.dart';

class TadkaApp extends StatelessWidget {
  const TadkaApp({super.key, this.store});

  final RecipeStore? store;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RecipeStore>(
      create: (_) => store ?? RecipeStore(),
      child: MaterialApp(
        title: 'Tadka',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF315D68)),
          scaffoldBackgroundColor: ColorScheme.fromSeed(seedColor: const Color(0xFF315D68)).surface,
          appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: ColorScheme.fromSeed(seedColor: const Color(0xFF315D68)).surfaceContainerLowest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: ColorScheme.fromSeed(seedColor: const Color(0xFF315D68)).outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: ColorScheme.fromSeed(seedColor: const Color(0xFF315D68)).primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: ColorScheme.fromSeed(seedColor: const Color(0xFF315D68)).error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: ColorScheme.fromSeed(seedColor: const Color(0xFF315D68)).error, width: 1.5),
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 0,
            color: ColorScheme.fromSeed(seedColor: const Color(0xFF315D68)).surfaceContainerLowest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
              side: BorderSide(color: ColorScheme.fromSeed(seedColor: const Color(0xFF315D68)).outlineVariant),
            ),
          ),
        ),
        home: const MainNavigationScreen(),
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  bool _startedLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_startedLoading) {
      _startedLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.read<RecipeStore>().load();
      });
    }
  }

  Future<void> _openRecipe(Recipe recipe) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => RecipeDetailScreen(recipeId: recipe.id),
      ),
    );
  }

  Future<void> _addRecipe() async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(builder: (_) => const AddRecipeScreen()),
    );
    if (saved == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recipe saved on this device.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      RecipeListScreen(onOpenRecipe: _openRecipe),
      FavoritesScreen(onOpenRecipe: _openRecipe),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(13),
              ),
              child: SizedBox(
                width: 42,
                height: 42,
                child: Icon(
                  Icons.local_dining_rounded,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(width: 11),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tadka', style: Theme.of(context).textTheme.titleLarge),
                Text(
                  'Add a Little Indian Magic',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: pages),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addRecipe,
        icon: const Icon(Icons.add),
        label: const Text('Add recipe'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded),
            label: 'Recipes',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline_rounded),
            selectedIcon: Icon(Icons.favorite_rounded),
            label: 'Favourites',
          ),
        ],
      ),
    );
  }
}
