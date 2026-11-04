import 'package:flutter_test/flutter_test.dart';
import 'package:cooking_recipes_android/app.dart';

void main() {
  testWidgets('Tadka starts with the recipe collection loading', (tester) async {
    await tester.pumpWidget(const TadkaApp());
    expect(find.text('Tadka'), findsOneWidget);
    expect(find.text('Recipes'), findsOneWidget);
    expect(find.text('Favourites'), findsOneWidget);
  });
}
