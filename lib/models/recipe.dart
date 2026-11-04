class PhotoCredit {
  const PhotoCredit({
    required this.author,
    required this.license,
    required this.sourceUrl,
  });

  final String author;
  final String license;
  final String sourceUrl;

  factory PhotoCredit.fromJson(Map<String, dynamic> json) => PhotoCredit(
        author: (json['author'] as String?) ?? 'Wikimedia Commons contributor',
        license: (json['license'] as String?) ?? 'Open license',
        sourceUrl: (json['sourceUrl'] as String?) ?? '',
      );
}

class Recipe {
  const Recipe({
    required this.id,
    required this.name,
    required this.origin,
    required this.region,
    required this.diet,
    required this.category,
    required this.ingredients,
    required this.method,
    required this.prepTime,
    required this.cookTime,
    required this.totalMinutes,
    required this.difficulty,
    required this.steps,
    this.calories,
    this.imagePath,
    this.imageAlt,
    this.photoCredit,
    this.isPersonal = false,
  });

  final String id;
  final String name;
  final String origin;
  final String region;
  final String diet;
  final String category;
  final List<String> ingredients;
  final String method;
  final String prepTime;
  final String cookTime;
  final int totalMinutes;
  final String difficulty;
  final List<String> steps;
  final int? calories;
  final String? imagePath;
  final String? imageAlt;
  final PhotoCredit? photoCredit;
  final bool isPersonal;

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final rawCredit = json['photoCredit'];
    return Recipe(
      id: json['id']?.toString() ?? '',
      name: (json['name'] as String?) ?? 'Untitled recipe',
      origin: (json['origin'] as String?) ?? '',
      region: (json['region'] as String?) ?? '',
      diet: (json['diet'] as String?) ?? 'Vegetarian',
      category: (json['category'] as String?) ?? 'Main Course',
      ingredients: _stringList(json['ingredients']),
      method: (json['method'] as String?) ?? '',
      prepTime: (json['prepTime'] as String?) ?? '0 min',
      cookTime: (json['cookTime'] as String?) ?? '0 min',
      totalMinutes: _asInt(json['totalMinutes']),
      difficulty: (json['difficulty'] as String?) ?? 'Easy',
      steps: _stringList(json['steps']),
      calories: json['calories'] == null ? null : _asInt(json['calories']),
      imagePath: json['imagePath'] as String?,
      imageAlt: json['imageAlt'] as String?,
      photoCredit: rawCredit is Map<String, dynamic>
          ? PhotoCredit.fromJson(rawCredit)
          : null,
      isPersonal: json['isPersonal'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'origin': origin,
        'region': region,
        'diet': diet,
        'category': category,
        'ingredients': ingredients,
        'method': method,
        'prepTime': prepTime,
        'cookTime': cookTime,
        'totalMinutes': totalMinutes,
        'difficulty': difficulty,
        'steps': steps,
        'calories': calories,
        'imagePath': imagePath,
        'imageAlt': imageAlt,
        'photoCredit': photoCredit == null
            ? null
            : {
                'author': photoCredit!.author,
                'license': photoCredit!.license,
                'sourceUrl': photoCredit!.sourceUrl,
              },
        'isPersonal': isPersonal,
      };

  static List<String> _stringList(dynamic value) {
    if (value is! List) return const [];
    return value.map((item) => item.toString()).toList(growable: false);
  }

  static int _asInt(dynamic value) =>
      value is int ? value : int.tryParse(value?.toString() ?? '') ?? 0;
}
