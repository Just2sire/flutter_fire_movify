# Movify - Application Flutter Multi-Ecrans (Catalogue de Films)

Movify est une application mobile et tablette developpee avec Flutter, axee sur une experience utilisateur fluide, un design moderne et une architecture en couches (Clean Architecture: core, data, domain, presentation). Elle permet de parcourir un catalogue de films, d'examiner leurs caracteristiques et de les filtrer, de gerer une liste de favoris et de watchlist avec persistance locale, le tout avec adaptabilite responsive (Mobile & Tablette) et gestion dynamique du theme clair / sombre.

---

## Suite de Tests Automatises (100% de reussite - 7 fichiers, 16 tests)

Le projet contient 7 fichiers de tests automatisés situés directement dans le dossier `test/`, couvrant la couche domaine, la couche data, la persistance locale du thème et les widgets réutilisables UI :

- `test/duration_formatter_test.dart` : Tests unitaires du formateur de durée (`int.toFormattedDuration()`).
- `test/movie_model_test.dart` : Tests unitaires du modèle `MovieModel` (`fromMap`, `toEntity`, `toMap`).
- `test/theme_repository_test.dart` : Tests unitaires de la persistance locale du Thème Clair/Sombre (`ThemeRepositoryImpl` & `SharedPreferences`).
- `test/app_buttons_test.dart` : Tests de widgets pour `AppElevatedButton` et `AppOutlinedButton`.
- `test/app_text_form_field_test.dart` : Tests de widgets pour `AppTextFormField` (saisie et validation `isRequired`).
- `test/edit_profile_page_test.dart` : Test d'intégration de `EditProfilePage` (validation des 3 champs de formulaire).
- `test/widget_test.dart` : Test de composant pour `AppTopbar`.

### Exécution des tests
```bash
flutter test
```

---

## Captures d'ecran & Apercu Visuel

| Ecran d'Accueil (HomePage) | Catalogue (MoviesPage) |
| :---: | :---: |
| ![Accueil Movify](assets/images/home_page.png) | ![Catalogue de Films](assets/images/movies_page.png) |

---

## Fonctionnalites Cles

- **Gestion du Theme Clair / Sombre** : Basculement dynamique du thème via `SwitchListTile` dans `ProfilePage` et via l'icône dans la TopBar de `HomePage`. Le choix est sauvegardé localement avec `SharedPreferences` (`ThemeRepositoryImpl`).
- **Formulaire avec Validation (3 champs)** : Formulaire dynamique d'édition de profil dans `EditProfilePage` et `ProfilePage` comportant 3 champs obligatoires avec validation interactive (*Nom complet* [min 3 lettres], *Adresse e-mail* [regex RFC], *Téléphone* [regex min 8 chiffres]).
- **Widgets Réutilisables** : Le dossier `lib/widgets/` et `lib/presentation/widgets/` contient plus de 12 widgets réutilisables (`AppScaffold`, `AppTopbar`, `AppElevatedButton`, `AppOutlinedButton`, `AppTextFormField`, `FiltersBottomSheet`, `AppDivider`, `AppIconContainer`, `AppIconSwitcher`, `AppProgressIndicator`, etc.).
- **Adaptabilite Responsive (Mobile & Tablette)** : Adaptation des mises en page (NavigationRail sur Tablette vs BottomNavigationBar sur Mobile, grilles adaptatives 2 vs 3 colonnes) via `BuildContextExtensions` (`context.isMobile`, `context.isTablet`).
- **Exploration & Filtrage de Films** : Recherche textuelle instantanée et panneau de filtrage multicritères (genres, année, note min, tri).
- **Favoris & Watchlist** : Persistance locale via `SharedPreferences`.
- **Navigation** : Routage propre et déclaratif avec `go_router`.
- **Intégration CI/CD** : Pipeline d'intégration continue automatisée via GitHub Actions (`.github/workflows/flutter.yml`).

---

## Responsive Design & Extensions de Contexte (`BuildContextExtensions`)

L'adaptabilité aux différentes tailles d'écran est gérée dans `lib/core/extensions/build_context_extensions.dart` et `lib/core/extensions/responsive_extensions.dart`.

```dart
if (context.isMobile) {
  // Navigation via BottomNavigationBar, grille 2 colonnes
} else if (context.isTablet) {
  // Navigation via NavigationRail, grille 3 colonnes
}
```

---

## Arborescence du Projet (Clean Architecture / Layer-First)

```text
movify/
├── .github/
│   └── workflows/
│       └── flutter.yml                    # Pipeline CI/CD GitHub Actions
├── assets/
│   ├── data/movies.json                   # Base de données locale JSON
│   └── images/                            # Captures d'écran
├── lib/
│   ├── main.dart                          # Point d'entrée & initialisation du thème
│   ├── core/                              # Socle technique (routing, theme, extensions)
│   ├── data/                              # Modèles, datasources JSON & repositories impl
│   ├── domain/                            # Entités métier & interfaces repositories
│   ├── presentation/                      # Vues (pages) & state management
│   └── widgets/                           # Composants UI réutilisables du Design System
├── test/                                  # Suite de tests unitaires & widget (7 fichiers)
│   ├── app_buttons_test.dart
│   ├── app_text_form_field_test.dart
│   ├── duration_formatter_test.dart
│   ├── edit_profile_page_test.dart
│   ├── movie_model_test.dart
│   ├── theme_repository_test.dart
│   └── widget_test.dart
├── pubspec.yaml
└── README.md
```

---

## Description des Ecrans

1. **WelcomePage** (`welcome_page.dart`) : Écran d'accueil et d'onboarding.
2. **AppShell** (`app_shell.dart`) : Shell avec BottomNavigationBar (Mobile) et NavigationRail (Tablette/Desktop).
3. **HomePage** (`home_page.dart`) : Dashboard principal avec films à l'affiche et toggle de thème.
4. **MoviesPage** (`movies_page.dart`) : Catalogue complet avec champ de recherche et modal de filtres `FiltersBottomSheet`.
5. **MovieDetailPage** (`movie_detail_page.dart`) : Fiche technique d'un film avec synopsis, note, casting et lien IMDb via `url_launcher`.
6. **FavoritesPage** (`favorites_page.dart`) : Liste des films favoris sauvegardés localement.
7. **WatchlistPage** (`watchlist_page.dart`) : Liste des films à regarder.
8. **ProfilePage** (`profile_page.dart`) : Profil utilisateur, formulaire de validation et bascule du thème clair/sombre.
9. **EditProfilePage** (`edit_profile_page.dart`) : Formulaire d'édition de profil avec validation de 3 champs obligatoires.
10. **ErrorPage** (`error_page.dart`) : Écran de gestion des routes introuvables.

---

## Composants UI & Widgets Réutilisables (`lib/widgets/`)

| Widget | Rôle & Description |
| :--- | :--- |
| **`AppScaffold`** | Scaffold personnalisé gérant la Safe Area et le fond adaptatif. |
| **`AppTopbar`** | Barre de navigation supérieure avec titre et actions. |
| **`FiltersBottomSheet`** | Bottom sheet modale pour le filtrage du catalogue. |
| **`AppElevatedButton`** | Bouton principal avec état de chargement et icône. |
| **`AppOutlinedButton`** | Bouton secondaire à contour. |
| **`AppTextFormField`** | Champ de texte réutilisable avec validation automatique. |
| **`AppProgressIndicator`** | Indicateurs d'attente circulaire et linéaire. |
| **`AppStepIndicator`** | Indicateur d'étape pour onboarding. |
| **`AppIconContainer`** | Conteneur stylisé pour icônes. |
| **`AppIconSwitcher`** | Animation de transition entre icônes. |
| **`AppDivider`** | Séparateur visuel réutilisable. |
| **`AppSwitcherTransitions`** | Transitions animées personnalisées. |

---

## Guide d'Installation & Exécution

### 1. Prérequis
- Flutter SDK >= 3.14.0
- Dart SDK >= 3.0.0

### 2. Récupération du Projet
```bash
git clone https://github.com/Just2sire/flutter_fire_movify.git
cd movify
```

### 3. Installation des Dépendances
```bash
flutter pub get
```

### 4. Exécution des Tests
```bash
flutter test
```

### 5. Lancement de l'Application
```bash
flutter run
```

---

## Licence

Projet développé pour le cours Flutter & Dart. Libre d'utilisation et d'adaptation.
