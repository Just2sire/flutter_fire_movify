# 🎬 Movify — Application de Découverte & Gestion de Films

**Movify** est une application mobile et tablette d'exception développée avec **Flutter**, axée sur une expérience utilisateur fluide, un design moderne et une architecture solide (**Clean Architecture**). Elle permet de parcourir un vaste catalogue de films, d'examiner en détail leurs caractéristiques (synopsis, note, durée, genres, casting, bandes-annonces), et d'organiser ses listes personnelles (favoris, films à voir / *Watchlist*), le tout soutenu par une réactivité responsive adaptative (Mobile & Tablette) et un mode Sombre / Clair dynamique.

---

## 📱 Captures d'écran & Aperçu Visuel

| 🏠 Écran d'Accueil (`HomePage`) | 🍿 Catalogue Complexe (`MoviesPage`) |
| :---: | :---: |
| ![Accueil Movify](assets/images/home_page.png) | ![Catalogue de Films](assets/images/movies_page.png) |

---

## ✨ Fonctionnalités Clés

- 🎬 **Exploration de Films** : Bandes-annonces, films à l'affiche, nouveautés et recommandations populaires.
- 📐 **Adaptabilité Responsive (Mobile & Tablette)** : Adaptation parfaite des grilles, cartes et mises en page sur smartphone, tablette et bureau grâce aux extensions de contexte (`context.isMobile`, `context.isTablet`, `context.isDesktop`).
- 🔍 **Recherche & Filtrage Avancé** : Recherche textuelle instantanée et modal de filtres multicritères (genres, année de sortie, note minimale, tri).
- ❤️ **Gestion des Favoris** : Sauvegarde instantanée des films coups de cœur avec persistance locale (`shared_preferences`).
- 📌 **Watchlist Personnalisée** : Suivi des films à regarder et statut de visionnage.
- 🌗 **Thème Sombre & Clair** : Toggle dynamique du thème global respectant la charte graphique de l'application.
- 📱 **Navigation Immersive** : Shell Bottom Navigation Bar fluide et routage propre avec `go_router`.

---

## 📐 Responsive Design & Extensions de Contexte (`BuildContextExtensions`)

L'un des points forts de Movify est son adaptabilité poussée aux différentes tailles d'écran. Grâce à l'extension [build_context_extensions.dart](file:///C:/Users/Desire/Documents/FORMATION/FlutterFire/FLUTTER/movify/lib/core/extensions/build_context_extensions.dart) sur `BuildContext`, les widgets adaptent automatiquement leur affichage en fonction du type d'appareil et de son orientation.

### 🔌 Accès Direct & Propriétés Responsive

```dart
// Exemples d'utilisation dans les widgets :
if (context.isMobile) {
  // Disposition sous forme de liste verticale pour mobile (< 600px)
} else if (context.isTablet) {
  // Disposition sous forme de grille 3 colonnes pour tablette (600px - 1200px)
} else if (context.isDesktop) {
  // Disposition élargie multi-panneaux pour bureau (>= 1200px)
}
```

### 🛠️ Résumé des Helpers `BuildContext`

| Propriété / Méthode | Type de retour | Description & Rôle |
| :--- | :--- | :--- |
| `context.isMobile` | `bool` | Détecte si la largeur de l'écran est `< 600px` (Smartphones). |
| `context.isTablet` | `bool` | Détecte si la largeur est comprise entre `600px` et `1200px` (Tablettes). |
| `context.isDesktop` | `bool` | Détecte si la largeur est `>= 1200px` (Grands écrans / Desktop). |
| `context.isPortrait` / `isLandscape` | `bool` | Détecte l'orientation de l'appareil (Portrait ou Paysage). |
| `context.screenWidth` / `screenHeight` | `double` | Accès rapide aux dimensions globales du viewport. |
| `context.theme` / `colorScheme` | `ThemeData` | Accès direct au thème actif et à la palette de couleurs sans lourdeur syntaxique. |
| `context.showSnackBar()` / `showError()` | `void` | Affichage simplifié de notifications et messages de confirmation. |

---

## 📂 Arborescence Complète du Projet

Voici l'organisation détaillée du code source du projet Movify :

```text
movify/
├── assets/
│   ├── data/
│   │   └── movies.json                    # Base de données locale de films (JSON)
│   ├── fonts/
│   │   ├── Lexend-Regular.ttf             # Police de caractères secondaire
│   │   └── Outfit-Regular.ttf             # Police de caractères principale
│   └── images/
│       ├── home_page.png                  # Capture d'écran de l'accueil
│       └── movies_page.png                # Capture d'écran du catalogue
├── lib/
│   ├── main.dart                          # Point d'entrée de l'application & initialisation
│   ├── core/                              # Socle technique et configurations globales
│   │   ├── constants/
│   │   │   ├── app_assets.dart            # Raccourcis des chemins d'assets
│   │   │   └── app_keys.dart              # Clés globales de configuration
│   │   ├── extensions/
│   │   │   ├── build_context_extensions.dart # Extensions UI, thème, navigation & responsive (isMobile, isTablet)
│   │   │   ├── color_extension.dart       # Utilitaires de manipulation de couleurs
│   │   │   ├── int_extensions.dart        # Formateurs de durées (minutes -> heures/minutes)
│   │   │   ├── navigation_extensions.dart # Extensions de navigation déclarative
│   │   │   ├── responsive_extensions.dart # Adaptabilité multi-écrans (Breakpoint helpers)
│   │   │   └── string_extensions.dart     # Formatage et capitalisation de texte
│   │   ├── helpers/
│   │   │   └── utils.dart                 # Fonctions utilitaires générales
│   │   ├── routing/
│   │   │   ├── app_routes.dart            # Constantes des noms de routes
│   │   │   └── router.dart                # Configuration de GoRouter (ShellRoute, sub-routes)
│   │   └── theme/
│   │       ├── app_colors.dart            # Palette de couleurs (Light & Dark tokens)
│   │       ├── app_spacing.dart           # Échelle d'espacement et marges standardisées
│   │       ├── app_text_styles.dart       # Styles typographiques prédéfinis
│   │       └── app_theme.dart             # Définitions ThemeData (Light Mode & Dark Mode)
│   ├── data/                              # Couche Données (Implémentations & Modèles)
│   │   ├── datasources/
│   │   │   └── local_json_datasource.dart # Lecture et parsing du JSON d'assets
│   │   ├── models/
│   │   │   ├── favourite_movie_model.dart # DTO Favoris avec sérilation JSON
│   │   │   ├── movie_model.dart           # DTO Film principal
│   │   │   ├── user_model.dart            # DTO Profil utilisateur
│   │   │   └── watchlist_movie_model.dart # DTO Watchlist
│   │   ├── repositories/
│   │   │   ├── favourite_movie_repository_impl.dart # Implémentation du dépôt Favoris
│   │   │   ├── movie_repository_impl.dart           # Implémentation du dépôt Films
│   │   │   ├── theme_repository_impl.dart           # Implémentation de la persistance du Thème
│   │   │   ├── user_repository_impl.dart            # Implémentation du dépôt Utilisateur
│   │   │   └── watchlist_movie_repository_impl.dart # Implémentation du dépôt Watchlist
│   │   └── services/
│   │       └── local_storage_service.dart # Service SharedPreferences pour le stockage local
│   ├── domain/                            # Couche Domaine (Métier & Abstractions)
│   │   ├── entities/
│   │   │   ├── favourite_movie.dart       # Entité métier Film Favori
│   │   │   ├── movie.dart                 # Entité métier Film
│   │   │   ├── movie_filter.dart          # Modèle de filtres de recherche
│   │   │   ├── movie_rating.dart          # Système de notation et avis
│   │   │   ├── user.dart                  # Entité Profil Utilisateur
│   │   │   └── watchlist_movie.dart       # Entité Film à voir
│   │   └── repositories/
│   │       ├── favourite_movie_repository.dart # Interface du dépôt Favoris
│   │       ├── movie_repository.dart           # Interface du dépôt Films
│   │       ├── theme_repository.dart           # Interface du dépôt Thème
│   │       ├── user_repository.dart            # Interface du dépôt Utilisateur
│   │       └── watchlist_movie_repository.dart # Interface du dépôt Watchlist
│   └── presentation/                      # Couche Présentation (UI & State)
│       ├── pages/                         # Vues et Écrans de l'application
│       │   ├── app_shell.dart             # Structure principale avec BottomNavigationBar
│       │   ├── edit_profile_page.dart     # Écran d'édition du profil utilisateur
│       │   ├── error_page.dart            # Écran d'erreur et route non trouvée
│       │   ├── favorites_page.dart        # Écran de gestion des films favoris
│       │   ├── home_page.dart             # Écran d'accueil principal (Dashboard)
│       │   ├── movie_detail_page.dart     # Fiche détaillée d'un film
│       │   ├── movies_page.dart           # Catalogue et recherche de films
│       │   ├── profile_page.dart          # Écran de profil et paramètres
│       │   ├── watchlist_page.dart        # Écran de la liste de lecture (Watchlist)
│       │   └── welcome_page.dart          # Écran de bienvenue / Onboarding
│       ├── providers/
│       │   └── app_dependencies.dart      # Injection de dépendances via InheritedWidget
│       └── widgets/                       # Composants UI personnalisés et réutilisables
│           ├── app_divider.dart           # Séparateur visuel réutilisable
│           ├── app_elevated_button.dart   # Bouton principal surélevé avec état de chargement
│           ├── app_icon_container.dart    # Conteneur stylisé pour icônes
│           ├── app_icon_switcher.dart     # Animation de transition entre icônes
│           ├── app_outlined_button.dart   # Bouton secondaire avec contour
│           ├── app_progress_indicator.dart # Indicateur de chargement circulaire et linéaire
│           ├── app_scaffold.dart          # Layout de base d'écran avec gestion Safe Area & TopBar
│           ├── app_step_indicator.dart    # Indicateur d'étape (onboarding/wizard)
│           ├── app_switcher_transitions.dart # Transitions animées personnalisées
│           ├── app_text_form_field.dart   # Champ de saisie réutilisable avec validations
│           ├── app_topbar.dart            # Barre supérieure d'application (AppBar personnalisée)
│           └── filters_bottom_sheet.dart  # Sheet modale de filtres pour le catalogue
├── pubspec.yaml                           # Déclaration des dépendances et assets
└── README.md                              # Document explicatif du projet
```

---

## 🖥️ Description Détaillée des Écrans (`presentation/pages/`)

### 1. 🏠 `WelcomePage` (`welcome_page.dart`)
- **Rôle** : Écran d'accueil / onboarding présentant l'application Movify.
- **Caractéristiques** : Visuel immersif, message d'introduction et bouton d'action principal redirigeant vers le dashboard de l'application.

### 2. 📱 `AppShell` (`app_shell.dart`)
- **Rôle** : Squelette de l'application (*Shell Navigation*) gérant la barre de navigation inférieure (*BottomNavigationBar*).
- **Caractéristiques** : Maintient le statut de la navigation et permet de basculer instantanément entre les 5 onglets principaux (`Accueil`, `Catalogue`, `Favoris`, `Watchlist`, `Profil`).

### 3. 🎬 `HomePage` (`home_page.dart`)
- **Rôle** : Tableau de bord de découverte cinématique.
- **Caractéristiques** :
  - **Hero Banner Carousel** mis en valeur.
  - Section **Tendances du moment** (*Trending Now*).
  - Section **Prochainement en salle** (*Coming Soon*).
  - Barre de recherche rapide et puces de genres interactives.

### 4. 🍿 `MoviesPage` (`movies_page.dart`)
- **Rôle** : Catalogue complet de films avec outils d'exploration.
- **Caractéristiques** :
  - Champ de recherche textuel réactif.
  - Bouton d'ouverture du modal de filtres `FiltersBottomSheet`.
  - Grille/Liste dynamique réactive aux breakpoints (`context.isMobile` / `context.isTablet`) affichant le poster, le titre, la note, la durée et les genres.

### 5. 🔍 `MovieDetailPage` (`movie_detail_page.dart`)
- **Rôle** : Fiche technique et artistique complète d'un film sélectionné.
- **Caractéristiques** :
  - Image de fond (*Backdrop*) haute résolution avec dégradé d'ombres.
  - Synopsis complet et avis/notes (*Rating*).
  - Distribution (*Cast*) et réalisateurs.
  - Boutons d'action pour ajouter/retirer des **Favoris** ou de la **Watchlist**.
  - Intégration de `url_launcher` pour ouvrir la **bande-annonce** externe.

### 6. ❤️ `FavoritesPage` (`favorites_page.dart`)
- **Rôle** : Gestion de la collection de films favoris de l'utilisateur.
- **Caractéristiques** :
  - Liste interactive des films marqués comme favoris.
  - Suppression rapide ou accès direct aux détails.
  - État vide (*Empty State*) illustré lorsque aucun film n'est enregistré.

### 7. 📌 `WatchlistPage` (`watchlist_page.dart`)
- **Rôle** : Suivi des films à regarder ultérieurement.
- **Caractéristiques** :
  - Organisation par statut (*À regarder* / *Déjà vu*).
  - Compteur de progression et mise à jour dynamique.

### 8. 👤 `ProfilePage` (`profile_page.dart`) & ✏️ `EditProfilePage` (`edit_profile_page.dart`)
- **Rôle** : Gestion du compte utilisateur et préférences.
- **Caractéristiques** :
  - Statistiques personnelles (Nombre de favoris, heures de visionnage).
  - Commutateur de thème (**Mode Sombre / Mode Clair**).
  - Formulaire de modification d'identité via `EditProfilePage`.

### 9. ⚠️ `ErrorPage` (`error_page.dart`)
- **Rôle** : Page de secours en cas d'erreur de routage ou de ressource introuvable.

---

## 🧱 Composants UI & Widgets Personnalisés (`presentation/widgets/`)

L'application intègre un **Design System** propriétaire composé de widgets hautement configurables :

| Widget | Fichier | Rôle & Description |
| :--- | :--- | :--- |
| **`AppScaffold`** | `app_scaffold.dart` | Conteneur standard pour toutes les pages, gérant la Safe Area, le fond adaptatif et l'intégration de la TopBar. |
| **`AppTopBar`** | `app_topbar.dart` | Barre de navigation supérieure personnalisée incluant le titre, le bouton de retour et les actions contextuelles. |
| **`FiltersBottomSheet`** | `filters_bottom_sheet.dart` | Panneau coulissant modale permettant de filtrer les films par genre, année, note minimale et critère de tri. |
| **`AppElevatedButton`** | `app_elevated_button.dart` | Bouton principal stylisé avec support du mode chargement (*loading spinner*) et icône optionnelle. |
| **`AppOutlinedButton`** | `app_outlined_button.dart` | Bouton secondaire à contour avec gestion dynamique des états de pression. |
| **`AppTextFormField`** | `app_text_form_field.dart` | Champ de texte personnalisé supportant la validation, les icônes de préfixe/suffixe et l'affichage de mot de passe. |
| **`AppProgressIndicator`** | `app_progress_indicator.dart` | Widgets d'attente (indicateurs circulaires et barres de progression) respectant la palette de couleurs active. |
| **`AppStepIndicator`** | `app_step_indicator.dart` | Composant d'étape visuel idéal pour l'onboarding et la navigation guidée. |
| **`AppIconContainer`** | `app_icon_container.dart` | Wrapper graphique donnant un arrière-plan et des bordures arrondies aux icônes. |
| **`AppIconSwitcher`** | `app_icon_switcher.dart` | Widget d'animation basculant de façon fluide entre deux icônes (ex: cœur plein / cœur vide). |
| **`AppDivider`** | `app_divider.dart` | Séparateur de contenu avec option de texte central ou espacement personnalisé. |
| **`AppSwitcherTransitions`** | `app_switcher_transitions.dart` | Utilitaires d'animations de transition réutilisables pour le basculement d'éléments UI. |

---

## 🏛️ Architecture & Injection de Dépendances

L'application suit scrupuleusement la **Clean Architecture** découpée en 3 couches principales :

```text
┌─────────────────────────────────────────────────────────┐
│                   PRESENTATION LAYER                    │
│   (Pages, Widgets, AppDependencies InheritedWidget)     │
└────────────────────────────┬────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────┐
│                      DOMAIN LAYER                       │
│    (Entities: Movie, User / Repository Interfaces)      │
└────────────────────────────▲────────────────────────────┘
                             │
                             │ Implémente
┌────────────────────────────┴────────────────────────────┐
│                       DATA LAYER                        │
│ (Models, Datasources: JSON & SharedPrefs, Repos Impl)   │
└─────────────────────────────────────────────────────────┘
```

### Injection de Dépendances (`AppDependencies`)
L'injection de dépendances est gérée de manière légère et performante via `AppDependencies` (`InheritedWidget`), qui fournit les répertoires métier à l'ensemble du tree Flutter :
- `MovieRepository` : Chargement et filtrage du catalogue de films.
- `FavouriteMovieRepository` : Sauvegarde et lecture des favoris.
- `WatchlistMovieRepository` : Gestion de la liste à voir.
- `UserRepository` : Données du profil utilisateur.
- `ThemeRepository` & `themeModeNotifier` : Gestion réactive du mode Clair / Sombre.

---

## 🎨 Charte Graphique & Thème (`core/theme/`)

- **Polices de caractères** :
  - **Outfit** : Utilisation pour les titres principaux, les en-têtes et les éléments à fort impact visuel.
  - **Lexend** : Utilisation pour les corps de texte, descriptions et fiches techniques pour une lisibilité maximale.
- **Thèmes (Light & Dark)** :
  - Gérés dans `app_theme.dart` avec des tokens de couleurs définis dans `app_colors.dart`.
  - Adaptation automatique des couleurs de fond, cartes, textes, bordures et icônes.

---

## 🛠️ Stack Technique & Bibliothèques

- **[Flutter](https://flutter.dev)** (`>=3.14.0`)
- **[go_router](https://pub.dev/packages/go_router)** : Routage déclaratif et navigation par URL.
- **[shared_preferences](https://pub.dev/packages/shared_preferences)** : Persistance locale des données utilisateur.
- **[lucide_icons_flutter](https://pub.dev/packages/lucide_icons_flutter)** : Icônes vectorielles modernes et cohérentes.
- **[url_launcher](https://pub.dev/packages/url_launcher)** : Lancement des URLs externes (bandes-annonces YouTube).

---

## 🚀 Guide d'Installation & Exécution

### 1. Prérequis
- **Flutter SDK** : `>= 3.14.0`
- **Dart SDK** : `>= 3.0.0`
- Android Studio / VS Code configuré avec l'extension Flutter.

### 2. Récupération du Projet
```bash
git clone https://github.com/votre-username/movify.git
cd movify
```

### 3. Installation des Dépendances
```bash
flutter pub get
```

### 4. Lancement
- **Sur Émulateur Android / Simulateur iOS** :
  ```bash
  flutter run
  ```
- **Sur le Web** :
  ```bash
  flutter run -d chrome
  ```

---

## 📝 Licence

Projet développé avec passion pour la communauté Flutter. Libre d'utilisation et d'adaptation.
