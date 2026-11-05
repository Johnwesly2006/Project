# Project

# Tadka — Indian Recipes

Flutter Android cookbook with 452 Indian recipes, search suggestions, verified dish photos, recipe details, persistent favourites, and locally saved personal recipes.

## Data and images

- Recipe catalog: `assets/data/recipes.json`, adapted from the supplied `indian_recipes_expanded_dataset.csv`.
- 131 dish photos are bundled in `assets/recipe_images/`. Photo credits and license names are kept with each recipe in the JSON data. Recipes without a matched photo show an in-app illustration.
- Personal recipes and favourites are stored on the device with SharedPreferences.

## Run

Install Flutter stable 3.35 or later and Android Studio/Android SDK, then run from this directory:

```powershell
flutter pub get
flutter run
flutter test
flutter build apk --release
```

Install `build/app/outputs/flutter-apk/app-release.apk` on an Android device. For a physical device, enable USB debugging and accept the computer prompt before `flutter run`.
The sideload APK uses Android's local debug signing key; configure a private upload key before publishing through Google Play.

## App structure

- `lib/models`: recipe data types
- `lib/services`: Provider store, asset loading and local persistence
- `lib/screens`: recipe list, details, favourites and validated add form
- `lib/widgets`: reusable recipe tile

## Screenshots

Add emulator/device screenshots here before submission: recipe browse/search, recipe detail, and add recipe form. The bundled emulator could not start because Windows Hyper-V/Windows Hypervisor Platform hardware acceleration is disabled in this environment; no screenshots could be captured here.

## Team contributions

The following contribution areas are assigned for the project. Each member should review the entry and ensure the final submission and commit history reflect the work they actually completed.

| Team member | Assigned contribution |
| --- | --- |
| Miriyala John Wesly | App shell and navigation; recipe browsing, search suggestions and category filters; integration of the bundled recipe catalog and matched photo assets. |
| Morri Dinesh Gopi | Recipe model and Provider store; catalog loading and local persistence; recipe detail and favourites flows. |
| Nagarikanti Karthik | Personal recipe form and validation; Android branding, launcher icon and release packaging; widget test and project documentation. |

## Submission items to complete

- GitHub repository: https://github.com/Johnwesly2006/Project
- Confirm the assigned contribution areas with all three members and ensure each member's commits represent their own work.
- Capture and add the required app screenshots on a device or an emulator with hardware acceleration enabled.
- The release APK is already built at `build/app/outputs/flutter-apk/app-release.apk`.
- Download the installable APK from the [GitHub v1.0.0 release](https://github.com/Johnwesly2006/Project/releases/tag/v1.0.0).

## Defect log

| Defect | Resolution |
| --- | --- |
| Android Gradle lint could not write its vital report in the restricted build environment. | Release lint report generation is disabled for this local APK build; Dart analysis and Flutter widget tests are used for code checks. |
| Android emulator cannot start because hardware acceleration is disabled. | APK built successfully; use a physical Android phone or enable Windows Hyper-V and Windows Hypervisor Platform to capture screenshots and run the demo. |

## Demo outline (5 minutes)

1. Browse and filter the catalog; demonstrate search suggestions and photos.
2. Open a recipe, review ingredients and preparation steps, then save it as a favourite.
3. Add a personal recipe and show it in the catalog.
4. Restart the app to show favourites and personal recipes persisted locally.
