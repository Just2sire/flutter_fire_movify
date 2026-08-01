import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "app_colors.dart";
import "app_spacing.dart";
import "app_text_styles.dart";

/// Thème global de l'application Movify (Inspiré de Netflix).
class AppTheme {
  const AppTheme._();

  // ─────────────────────────────────────────────
  // FONTS
  // ─────────────────────────────────────────────

  static const String fontFamily = AppTextStyles.fontFamily;

  // ─────────────────────────────────────────────
  // SHAPES
  // ─────────────────────────────────────────────

  static const shapeLarge = RoundedRectangleBorder(
    borderRadius: AppSpacing.roundedXxl,
  );
  static const shapeMedium = RoundedRectangleBorder(
    borderRadius: AppSpacing.roundedLg,
  );
  static const shapeSmall = RoundedRectangleBorder(
    borderRadius: AppSpacing.roundedMd,
  );

  // -----------------------------------------------------------------------
  // COULEURS (ColorScheme)
  // -----------------------------------------------------------------------
  // Light : Fond clair épuré, accent principal Rouge Netflix (#E50914).
  // Dark  : Fond Noir Netflix (#141414), cartes (#1F1F1F),
  //         CTA Rouge Netflix (#E50914).
  // -----------------------------------------------------------------------
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.white,
    secondary: AppColors.secondary,
    onSecondary: AppColors.white,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.white,
    error: AppColors.error,
    onError: AppColors.white,
    surface: AppColors.surface,
    onSurface: AppColors.ink,
    surfaceContainer: AppColors.surfaceContainer,
    onSurfaceVariant: AppColors.ink54,
    outline: AppColors.neutral300,
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primary, // Netflix Red CTA principal
    onPrimary: AppColors.white,
    secondary: AppColors.secondary,
    onSecondary: AppColors.white,
    tertiary: AppColors.accentAmber, // Netflix Gold Top 10
    onTertiary: AppColors.ink,
    error: AppColors.error,
    onError: AppColors.white,
    surface: AppColors.darkBackground, // Noir iconique Netflix (#141414)
    onSurface: AppColors.paleMint, // Blanc pur (#FFFFFF)
    surfaceContainer: AppColors.darkSurface, // Gris sombre Netflix (#1F1F1F)
    onSurfaceVariant: AppColors.paleMint70, // Muted text (#B3B3B3)
    outline: AppColors.neutral700,
  );

  // ─────────────────────────────────────────────
  // LIGHT THEME
  // ─────────────────────────────────────────────

  static final lightTheme = ThemeData(
    fontFamily: fontFamily,
    brightness: Brightness.light,
    colorScheme: lightColorScheme,
    scaffoldBackgroundColor: lightColorScheme.surface,

    // Text theme
    textTheme: AppTextStyles.lightTextTheme.apply(
      fontFamily: fontFamily,
      bodyColor: lightColorScheme.onSurface,
      displayColor: lightColorScheme.onSurface,
    ),

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: lightColorScheme.surface,
      foregroundColor: lightColorScheme.onSurface,
      elevation: AppSpacing.elevationNone,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: lightColorScheme.onSurface,
        letterSpacing: 0.2,
        fontFamily: fontFamily,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightColorScheme.primary,
        foregroundColor: lightColorScheme.onPrimary,
        elevation: AppSpacing.elevationSm,
        shadowColor: lightColorScheme.primary.withValues(alpha: 0.3),
        minimumSize: const Size(0, AppSpacing.buttonHeightLg),
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedMd),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
          fontFamily: fontFamily,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: lightColorScheme.onSurface,
        side: const BorderSide(color: AppColors.neutral300, width: 1.5),
        minimumSize: const Size(0, AppSpacing.buttonHeightLg),
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedMd),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          fontFamily: fontFamily,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: lightColorScheme.primary,
        minimumSize: const Size(0, AppSpacing.buttonHeightLg),
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedMd),
        textStyle: AppTextStyles.buttonText,
      ),
    ),

    // Input Decoration (TextField)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightInput,
      contentPadding: AppSpacing.inputPadding,
      border: const OutlineInputBorder(
        borderRadius: AppSpacing.roundedLg,
        borderSide: BorderSide.none,
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: AppSpacing.roundedLg,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppSpacing.roundedLg,
        borderSide: BorderSide(
          color: lightColorScheme.primary,
          width: AppSpacing.borderWidthThick,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.roundedLg,
        borderSide: BorderSide(
          color: lightColorScheme.error,
          width: AppSpacing.borderWidthMedium,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.roundedLg,
        borderSide: BorderSide(
          color: lightColorScheme.error,
          width: AppSpacing.borderWidthThick,
        ),
      ),
      labelStyle: TextStyle(
        color: lightColorScheme.onSurfaceVariant,
        fontFamily: fontFamily,
      ),
      hintStyle: const TextStyle(
        color: AppColors.neutral500,
        fontFamily: fontFamily,
      ),
    ),

    // Card
    cardTheme: CardThemeData(
      color: lightColorScheme.surfaceContainer,
      elevation: AppSpacing.elevationNone,
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedLg),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shadowColor: Colors.black.withValues(alpha: 0.06),
    ),

    // FloatingActionButton
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: lightColorScheme.primary,
      foregroundColor: lightColorScheme.onPrimary,
      elevation: AppSpacing.elevationMd,
      shape: const CircleBorder(),
    ),

    // Bottom Navigation Bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: lightColorScheme.surfaceContainer,
      elevation: AppSpacing.elevationLg,
      selectedItemColor: lightColorScheme.primary,
      unselectedItemColor: AppColors.neutral500,
      selectedLabelStyle: AppTextStyles.lightTextTheme.labelMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelStyle: AppTextStyles.lightTextTheme.labelSmall,
    ),

    // Dialog
    dialogTheme: DialogThemeData(
      backgroundColor: lightColorScheme.surfaceContainer,
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedLg),
      titleTextStyle: AppTextStyles.lightTextTheme.titleLarge,
      contentTextStyle: AppTextStyles.lightTextTheme.bodyMedium,
    ),

    // SnackBar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.ink,
      contentTextStyle: AppTextStyles.darkTextTheme.bodyMedium,
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedMd),
    ),

    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.neutral100,
      selectedColor: lightColorScheme.primary,
      secondarySelectedColor: lightColorScheme.primary,
      labelStyle: AppTextStyles.lightTextTheme.labelMedium,
      secondaryLabelStyle: AppTextStyles.lightTextTheme.labelMedium?.copyWith(
        color: AppColors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedMd),
      side: BorderSide.none,
    ),

    // Autres composants
    iconTheme: IconThemeData(
      color: lightColorScheme.onSurface,
      size: AppSpacing.iconLg,
    ),

    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: lightColorScheme.primary,
      circularTrackColor: AppColors.neutral200,
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.neutral200,
      thickness: AppSpacing.dividerThickness,
      space: AppSpacing.dividerThickness,
    ),

    // Switch
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return lightColorScheme.primary;
        }
        return AppColors.neutral400;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return lightColorScheme.primary.withValues(alpha: .3);
        }
        return AppColors.neutral200;
      }),
    ),

    // Checkbox
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return lightColorScheme.primary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(AppColors.white),
      side: const BorderSide(color: AppColors.neutral400, width: 1.5),
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedXs),
    ),

    // Radio
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return lightColorScheme.primary;
        }
        return AppColors.neutral400;
      }),
    ),
  );

  // ─────────────────────────────────────────────
  // DARK THEME (Signature Netflix UI)
  // ─────────────────────────────────────────────

  static final darkTheme = ThemeData(
    fontFamily: fontFamily,
    brightness: Brightness.dark,
    colorScheme: darkColorScheme,
    scaffoldBackgroundColor: darkColorScheme.surface,

    // Text theme
    textTheme: AppTextStyles.darkTextTheme.apply(
      fontFamily: fontFamily,
      bodyColor: darkColorScheme.onSurface,
      displayColor: darkColorScheme.onSurface,
    ),

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: darkColorScheme.surface,
      foregroundColor: darkColorScheme.onSurface,
      elevation: AppSpacing.elevationNone,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: darkColorScheme.onSurface,
        letterSpacing: 0.2,
        fontFamily: fontFamily,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkColorScheme.primary, // Netflix Red CTA
        foregroundColor: darkColorScheme.onPrimary,
        elevation: AppSpacing.elevationSm,
        shadowColor: Colors.black.withValues(alpha: 0.5),
        minimumSize: const Size(0, AppSpacing.buttonHeightLg),
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedMd),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
          fontFamily: fontFamily,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: darkColorScheme.onSurface,
        side: const BorderSide(color: AppColors.neutral600, width: 1.5),
        minimumSize: const Size(0, AppSpacing.buttonHeightLg),
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedMd),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          fontFamily: fontFamily,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.white,
        minimumSize: const Size(0, AppSpacing.buttonHeightLg),
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedMd),
        textStyle: AppTextStyles.buttonText,
      ),
    ),

    // Input Decoration (TextField)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkInput,
      contentPadding: AppSpacing.inputPadding,
      border: const OutlineInputBorder(
        borderRadius: AppSpacing.roundedLg,
        borderSide: BorderSide.none,
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: AppSpacing.roundedLg,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppSpacing.roundedLg,
        borderSide: BorderSide(
          color: darkColorScheme.primary,
          width: AppSpacing.borderWidthThick,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.roundedLg,
        borderSide: BorderSide(
          color: darkColorScheme.error,
          width: AppSpacing.borderWidthMedium,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.roundedLg,
        borderSide: BorderSide(
          color: darkColorScheme.error,
          width: AppSpacing.borderWidthThick,
        ),
      ),
      labelStyle: const TextStyle(
        color: AppColors.paleMint70,
        fontFamily: fontFamily,
      ),
      hintStyle: const TextStyle(
        color: AppColors.paleMint38,
        fontFamily: fontFamily,
      ),
    ),

    // Card
    cardTheme: CardThemeData(
      color: darkColorScheme.surfaceContainer,
      elevation: AppSpacing.elevationNone,
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedLg),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shadowColor: Colors.black.withValues(alpha: 0.4),
    ),

    // FloatingActionButton
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: darkColorScheme.primary,
      foregroundColor: darkColorScheme.onPrimary,
      elevation: AppSpacing.elevationMd,
      shape: const CircleBorder(),
    ),

    // Bottom Navigation Bar (Netflix Dark Navigation)
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.netflixBlack,
      elevation: AppSpacing.elevationLg,
      selectedItemColor: darkColorScheme.primary, // Netflix Red
      unselectedItemColor: AppColors.paleMint70,
      selectedLabelStyle: AppTextStyles.darkTextTheme.labelMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelStyle: AppTextStyles.darkTextTheme.labelSmall,
    ),

    // Dialog
    dialogTheme: DialogThemeData(
      backgroundColor: darkColorScheme.surfaceContainer,
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedLg),
      titleTextStyle: AppTextStyles.darkTextTheme.titleLarge,
      contentTextStyle: AppTextStyles.darkTextTheme.bodyMedium,
    ),

    // SnackBar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.netflixMediumGray,
      contentTextStyle: AppTextStyles.darkTextTheme.bodyMedium,
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedMd),
    ),

    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.netflixMediumGray,
      selectedColor: darkColorScheme.primary,
      secondarySelectedColor: darkColorScheme.primary,
      labelStyle: AppTextStyles.darkTextTheme.labelMedium,
      secondaryLabelStyle: AppTextStyles.darkTextTheme.labelMedium?.copyWith(
        color: AppColors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedMd),
      side: BorderSide.none,
    ),

    // Autres composants
    iconTheme: const IconThemeData(
      color: AppColors.paleMint,
      size: AppSpacing.iconLg,
    ),

    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: darkColorScheme.primary,
      circularTrackColor: AppColors.neutral700,
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.neutral800,
      thickness: AppSpacing.dividerThickness,
      space: AppSpacing.dividerThickness,
    ),

    // Switch
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return darkColorScheme.primary;
        }
        return AppColors.neutral500;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return darkColorScheme.primary.withValues(alpha: .4);
        }
        return AppColors.neutral700;
      }),
    ),

    // Checkbox
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return darkColorScheme.primary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(AppColors.white),
      side: const BorderSide(color: AppColors.neutral500, width: 1.5),
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedXs),
    ),

    // Radio
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return darkColorScheme.primary;
        }
        return AppColors.neutral500;
      }),
    ),
  );
}
