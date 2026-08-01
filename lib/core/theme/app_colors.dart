import "package:flutter/cupertino.dart";

/// Palette de couleurs de l'application Movify.
///
/// Identité visuelle inspirée de la plateforme de streaming **Netflix** :
/// - **Netflix Red** (`#E50914`) → Brand color principal, CTA, badges.
/// - **Netflix Dark Red** (`#B81D24`) → Ombres, dégradés et états survol/activé.
/// - **Netflix Dark Background** (`#141414`) → Noir profond iconique Netflix.
/// - **Netflix Dark Surface** (`#1F1F1F`) → Carte et conteneurs élevés.
/// - **Match Green** (`#46D369`) → Badge d'affinité % (ex: 98% Match).
/// - **Top 10 Gold** (`#E5A00D`) → Badges Premium & Top 10.
/// - **Ultra HD Blue** (`#0071EB`) → Badges 4K, HDR & info.
///
/// Le Light Mode propose un design épuré moderne avec fond neutre `#F5F5F7`
/// et surfaces blanches `#FFFFFF`, tout en conservant le rouge vif Netflix.
class AppColors {
  const AppColors._();

  // ───────────────────────────────────────────────
  // BRAND — Couleurs de marque Netflix
  // ───────────────────────────────────────────────

  /// Rouge Netflix officiel (#E50914) — Couleur d'ancrage et CTA principal.
  static const Color primary = Color(0xFFE50914);

  /// Rouge foncé Netflix (#B81D24) — Secondaire / Dégradés / Survol.
  static const Color secondary = Color(0xFFB81D24);

  /// Or / Ambre Netflix (#E5A00D) — Badges Top 10 & Premium.
  static const Color tertiary = Color(0xFFE5A00D);

  /// Blanc pur.
  static const Color white = Color(0xFFFFFFFF);

  /// Noir pur.
  static const Color black = Color(0xFF000000);

  // Alias explicites Netflix
  static const Color netflixRed = Color(0xFFE50914);
  static const Color netflixDarkRed = Color(0xFFB81D24);
  static const Color netflixBlack = Color(0xFF141414);
  static const Color netflixDarkGray = Color(0xFF1F1F1F);
  static const Color netflixMediumGray = Color(0xFF2B2B2B);
  static const Color netflixLightGray = Color(0xFF757575);

  // ───────────────────────────────────────────────
  // ACCENTS — Catégories, Badges & Streaming Indicators
  // ───────────────────────────────────────────────

  static const Color accentRed = Color(0xFFE50914);
  static const Color accentAmber = Color(0xFFE5A00D);
  static const Color accentGreen = Color(0xFF46D369); // Netflix Match Green
  static const Color accentBlue = Color(0xFF0071EB); // 4K / Ultra HD
  static const Color accentPurple = Color(0xFF8C52FF);

  /// Liste pratique pour assigner une couleur à chaque catégorie/carte.
  static const List<Color> categoryColors = [
    accentRed,
    accentAmber,
    accentGreen,
    accentBlue,
    accentPurple,
  ];

  // ───────────────────────────────────────────────
  // ÉTATS
  // ───────────────────────────────────────────────

  static const Color error = Color(0xFFE50914);
  static const Color warning = Color(0xFFE5A00D);
  static const Color success = Color(0xFF46D369);
  static const Color info = Color(0xFF0071EB);

  // ───────────────────────────────────────────────
  // ENCRE & TEXTES — Light Mode
  // ───────────────────────────────────────────────

  /// Charbon profond Netflix — remplace le noir pur
  /// pour les textes en Light Mode.
  static const Color ink = Color(0xFF141414);
  static const Color ink87 = Color(0xDE141414);
  static const Color ink54 = Color(0x8A141414);
  static const Color ink38 = Color(0x61141414);

  // ───────────────────────────────────────────────
  // BLANC CASSÉ & TEXTES — Dark Mode
  // ───────────────────────────────────────────────

  /// Blanc lumineux Netflix — Texte principal en Dark Mode.
  static const Color paleMint = Color(0xFFFFFFFF);
  static const Color paleMint87 = Color(0xDEFFFFFF);
  static const Color paleMint70 = Color(0xB3FFFFFF); // Muted gray Netflix
  static const Color paleMint54 = Color(0x8AFFFFFF);
  static const Color paleMint38 = Color(0x61FFFFFF);

  // ───────────────────────────────────────────────
  // LIGHT MODE — Surfaces
  // ───────────────────────────────────────────────

  /// Fond général (scaffold) light mode.
  static const Color surface = Color(0xFFF5F5F7);

  /// Carte / Surface élevée light mode.
  static const Color surfaceContainer = Color(0xFFFFFFFF);

  /// Champ de saisie light mode.
  static const Color lightInput = Color(0xFFEFEFEF);

  // ───────────────────────────────────────────────
  // DARK MODE — Surfaces (Netflix Signature Dark)
  // ───────────────────────────────────────────────

  /// Fond général (scaffold) : Noir iconique Netflix (#141414).
  static const Color darkBackground = Color(0xFF141414);

  /// Surface élevée (cartes, conteneurs) : Gris sombre Netflix (#1F1F1F).
  static const Color darkSurface = Color(0xFF1F1F1F);

  /// Champ de saisie dark mode (#2B2B2B).
  static const Color darkInput = Color(0xFF2B2B2B);

  // ───────────────────────────────────────────────
  // GRADIENTS — Netflix & Streaming UI
  // ───────────────────────────────────────────────

  /// Dégradé Or Top 10.
  static const goldenGradient = LinearGradient(
    colors: [
      Color(0xFFF5C518),
      Color(0xFFE5A00D),
      Color(0xFFB87B00),
    ],
  );

  static const fullGoldenGradient = LinearGradient(
    colors: [
      Color(0xFFFFDF6D),
      Color(0xFFF5C518),
      Color(0xFFE5A00D),
      Color(0xFFB87B00),
    ],
  );

  /// Dégradé Brand Netflix principal (Rouge vif vers Rouge sombre).
  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );

  static const softSurfaceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [surfaceContainer, surface],
  );

  /// Fondu héroïques (Posters / Miniatures films).
  static const heroOverlayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x00000000),
      Color(0x80141414),
      darkBackground,
    ],
  );

  // ───────────────────────────────────────────────
  // PRIMARY LUSH GRADIENTS (Netflix Variations)
  // ───────────────────────────────────────────────

  static const primaryDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF000000),
      Color(0xFF141414),
      primary,
    ],
  );

  static const primaryLush = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkBackground, secondary, primary],
  );

  static const primaryDeepLush = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF000000), darkBackground, secondary],
  );

  static const primaryLightLush = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary, white],
  );

  static const primarySoftLush = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, Color(0xFFFF4D5A), surface],
  );

  // ───────────────────────────────────────────────
  // ACCENT GRADIENTS
  // ───────────────────────────────────────────────

  static const purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentPurple, Color(0xFF6325D3)],
  );

  static const redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentRed, secondary],
  );

  static const amberGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentAmber, Color(0xFFB87B00)],
  );

  static const greenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentGreen, Color(0xFF269447)],
  );

  static const blueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentBlue, Color(0xFF004999)],
  );

  // ───────────────────────────────────────────────
  // SEMANTIC GRADIENTS
  // ───────────────────────────────────────────────

  static const successGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [accentGreen, Color(0xFF269447)],
  );

  static const errorGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [accentRed, secondary],
  );

  static const infoGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [accentBlue, Color(0xFF004999)],
  );

  static const warningGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [accentAmber, Color(0xFFB87B00)],
  );

  // ───────────────────────────────────────────────
  // NEUTRES — Échelle de gris Netflix
  // ───────────────────────────────────────────────

  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF0F0F0);
  static const Color neutral200 = Color(0xFFE0E0E0);
  static const Color neutral300 = Color(0xFFCCCCCC);
  static const Color neutral400 = Color(0xFFA3A3A3);
  static const Color neutral500 = Color(0xFF737373);
  static const Color neutral600 = Color(0xFF525252);
  static const Color neutral700 = Color(0xFF333333);
  static const Color neutral800 = Color(0xFF1F1F1F);
  static const Color neutral900 = Color(0xFF141414);
}
