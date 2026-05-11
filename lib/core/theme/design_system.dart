import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.backgroundBase,
    required this.backgroundSecondary,
    required this.surfaceGlass,
    required this.surfaceElevated,
    required this.primary,
    required this.primarySoft,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
    required this.glassBorder,
    required this.glassShadow,
    required this.overlaySoft,
    required this.overlayStrong,
    required this.success,
    required this.error,
    required this.warning,
    required this.heroGradient,
    required this.backgroundGradient,
    required this.primaryGradient,
    required this.glassGradient,
  });

  final Color backgroundBase;
  final Color backgroundSecondary;
  final Color surfaceGlass;
  final Color surfaceElevated;
  final Color primary;
  final Color primarySoft;
  final Color accent;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color border;
  final Color glassBorder;
  final Color glassShadow;
  final Color overlaySoft;
  final Color overlayStrong;
  final Color success;
  final Color error;
  final Color warning;
  final LinearGradient heroGradient;
  final LinearGradient backgroundGradient;
  final LinearGradient primaryGradient;
  final LinearGradient glassGradient;

  @override
  AppPalette copyWith({
    Color? backgroundBase,
    Color? backgroundSecondary,
    Color? surfaceGlass,
    Color? surfaceElevated,
    Color? primary,
    Color? primarySoft,
    Color? accent,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? border,
    Color? glassBorder,
    Color? glassShadow,
    Color? overlaySoft,
    Color? overlayStrong,
    Color? success,
    Color? error,
    Color? warning,
    LinearGradient? heroGradient,
    LinearGradient? backgroundGradient,
    LinearGradient? primaryGradient,
    LinearGradient? glassGradient,
  }) {
    return AppPalette(
      backgroundBase: backgroundBase ?? this.backgroundBase,
      backgroundSecondary: backgroundSecondary ?? this.backgroundSecondary,
      surfaceGlass: surfaceGlass ?? this.surfaceGlass,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      primary: primary ?? this.primary,
      primarySoft: primarySoft ?? this.primarySoft,
      accent: accent ?? this.accent,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      border: border ?? this.border,
      glassBorder: glassBorder ?? this.glassBorder,
      glassShadow: glassShadow ?? this.glassShadow,
      overlaySoft: overlaySoft ?? this.overlaySoft,
      overlayStrong: overlayStrong ?? this.overlayStrong,
      success: success ?? this.success,
      error: error ?? this.error,
      warning: warning ?? this.warning,
      heroGradient: heroGradient ?? this.heroGradient,
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      primaryGradient: primaryGradient ?? this.primaryGradient,
      glassGradient: glassGradient ?? this.glassGradient,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      backgroundBase: Color.lerp(backgroundBase, other.backgroundBase, t)!,
      backgroundSecondary:
          Color.lerp(backgroundSecondary, other.backgroundSecondary, t)!,
      surfaceGlass: Color.lerp(surfaceGlass, other.surfaceGlass, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primarySoft: Color.lerp(primarySoft, other.primarySoft, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      border: Color.lerp(border, other.border, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      glassShadow: Color.lerp(glassShadow, other.glassShadow, t)!,
      overlaySoft: Color.lerp(overlaySoft, other.overlaySoft, t)!,
      overlayStrong: Color.lerp(overlayStrong, other.overlayStrong, t)!,
      success: Color.lerp(success, other.success, t)!,
      error: Color.lerp(error, other.error, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      heroGradient: t < 0.5 ? heroGradient : other.heroGradient,
      backgroundGradient: t < 0.5 ? backgroundGradient : other.backgroundGradient,
      primaryGradient: t < 0.5 ? primaryGradient : other.primaryGradient,
      glassGradient: t < 0.5 ? glassGradient : other.glassGradient,
    );
  }
}

class DesignSystem {
  // Legacy light palette
  static const Color primaryIndigo = Color(0xFF6C4CF1);
  static const Color primaryLight = Color(0xFF8B7CF8);
  static const Color primaryDark = Color(0xFF4D3BC7);
  static const Color backgroundLavender = Color(0xFFDADBFA);
  static const Color backgroundLight = Color(0xFFEFF0FF);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF0C0E68);
  static const Color textSecondary = Color(0xFF5A5A7A);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textLight = Color(0xFF8A8AA3);
  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFED6C02);
  static const Color info = Color(0xFF0288D1);
  static const Color borderLight = Color(0xFFE0E0F0);
  static const Color borderFocus = primaryIndigo;
  static const Color shadowColor = Color(0xFF0C0E68);
  static const Color overlayLight = Color(0x1A0C0E68);
  static const Color overlayMedium = Color(0x330C0E68);
  static const Color backgroundBase = Color(0xFFF6F4FF);
  static const Color backgroundSecondary = Color(0xFFE8E4FF);
  static const Color surfaceGlass = Color(0xD9FFFFFF);
  static const Color surfaceElevated = Color(0xFFFFFFFF);
  static const Color accentLime = Color(0xFF7E61FF);
  static const Color glassBorder = Color(0x88FFFFFF);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryIndigo, primaryLight],
  );

  static const LinearGradient lavenderGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundLavender, backgroundLight],
  );

  static const AppPalette lightPalette = AppPalette(
    backgroundBase: Color(0xFFF6F4FF),
    backgroundSecondary: Color(0xFFE8E4FF),
    surfaceGlass: Color(0xD9FFFFFF),
    surfaceElevated: Color(0xFFFFFFFF),
    primary: Color(0xFF6C4CF1),
    primarySoft: Color(0xFFA79AFF),
    accent: Color(0xFF7E61FF),
    textPrimary: Color(0xFF16113A),
    textSecondary: Color(0xFF5F5B86),
    textMuted: Color(0xFF928DB5),
    border: Color(0xFFE1DAFF),
    glassBorder: Color(0x88FFFFFF),
    glassShadow: Color(0x220C0E68),
    overlaySoft: Color(0x146C4CF1),
    overlayStrong: Color(0x286C4CF1),
    success: Color(0xFF2E7D32),
    error: Color(0xFFD32F2F),
    warning: Color(0xFFED6C02),
    heroGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFEAE5FF), Color(0xFFD8D1FF), Color(0xFFC6BBFF)],
    ),
    backgroundGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFF8F7FF), Color(0xFFEAE6FF)],
    ),
    primaryGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF6C4CF1), Color(0xFF8C76FF)],
    ),
    glassGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xE6FFFFFF), Color(0xCCF4F0FF)],
    ),
  );

  static const AppPalette darkPalette = AppPalette(
    backgroundBase: Color(0xFF0F122B),
    backgroundSecondary: Color(0xFF171A3D),
    surfaceGlass: Color(0x661B1F4A),
    surfaceElevated: Color(0xFF202655),
    primary: Color(0xFF9F8CFF),
    primarySoft: Color(0xFFC5BCFF),
    accent: Color(0xFFEBE8FF),
    textPrimary: Color(0xFFF6F3FF),
    textSecondary: Color(0xFFC2BCF1),
    textMuted: Color(0xFF938DBF),
    border: Color(0xFF313A74),
    glassBorder: Color(0x666E7FD6),
    glassShadow: Color(0x66060816),
    overlaySoft: Color(0x149F8CFF),
    overlayStrong: Color(0x2A9F8CFF),
    success: Color(0xFF57D08B),
    error: Color(0xFFFF7B8E),
    warning: Color(0xFFFFC26B),
    heroGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF1A1F55), Color(0xFF14173B), Color(0xFF0F122B)],
    ),
    backgroundGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF14173B), Color(0xFF0F122B)],
    ),
    primaryGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFA796FF), Color(0xFFD5CCFF)],
    ),
    glassGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0x3AFFFFFF), Color(0x121B1F4A)],
    ),
  );

  static AppPalette paletteOf(BuildContext context) =>
      Theme.of(context).extension<AppPalette>() ?? lightPalette;

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  // Typography
  static const double fontSizeDisplay1 = 34;
  static const double fontSizeDisplay2 = 28;
  static const double fontSizeH1 = 32;
  static const double fontSizeH2 = 28;
  static const double fontSizeH3 = 24;
  static const double fontSizeH4 = 20;
  static const double fontSizeH5 = 18;
  static const double fontSizeH6 = 16;
  static const double fontSizeBodyLarge = 16;
  static const double fontSizeBodyMedium = 14;
  static const double fontSizeBodySmall = 12;
  static const double fontSizeCaption = 12;
  static const double fontSizeButton = 16;
  static const double fontSizeOverline = 10;
  static const double fontSizeStat = 24;

  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;

  static const double letterSpacingTight = -0.4;
  static const double letterSpacingWide = 0.35;
  static const double lineHeightTight = 1.15;
  static const double lineHeightNormal = 1.45;

  static TextStyle get displayLarge => GoogleFonts.inter(
        fontSize: fontSizeDisplay1,
        fontWeight: fontWeightBold,
        letterSpacing: letterSpacingTight,
        height: lineHeightTight,
      );
  static TextStyle get displayMedium => GoogleFonts.inter(
        fontSize: fontSizeDisplay2,
        fontWeight: fontWeightBold,
        letterSpacing: letterSpacingTight,
        height: lineHeightTight,
      );
  static TextStyle get headline1 => GoogleFonts.inter(
        fontSize: fontSizeH1,
        fontWeight: fontWeightBold,
        height: lineHeightTight,
      );
  static TextStyle get headline2 => GoogleFonts.inter(
        fontSize: fontSizeH2,
        fontWeight: fontWeightSemiBold,
        height: lineHeightTight,
      );
  static TextStyle get headline3 => GoogleFonts.inter(
        fontSize: fontSizeH3,
        fontWeight: fontWeightSemiBold,
        height: lineHeightTight,
      );
  static TextStyle get headline4 => GoogleFonts.inter(
        fontSize: fontSizeH4,
        fontWeight: fontWeightSemiBold,
        height: lineHeightTight,
      );
  static TextStyle get headline5 => GoogleFonts.inter(
        fontSize: fontSizeH5,
        fontWeight: fontWeightSemiBold,
        height: lineHeightTight,
      );
  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: fontSizeBodyLarge,
        fontWeight: fontWeightRegular,
        height: lineHeightNormal,
        color: textPrimary,
      );
  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: fontSizeBodyMedium,
        fontWeight: fontWeightRegular,
        height: lineHeightNormal,
        color: textSecondary,
      );
  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: fontSizeBodySmall,
        fontWeight: fontWeightRegular,
        height: lineHeightNormal,
        color: textLight,
      );
  static TextStyle get button => GoogleFonts.inter(
        fontSize: fontSizeButton,
        fontWeight: fontWeightSemiBold,
        letterSpacing: letterSpacingWide,
        height: lineHeightTight,
      );
  static TextStyle get caption => GoogleFonts.inter(
        fontSize: fontSizeCaption,
        fontWeight: fontWeightMedium,
        height: lineHeightNormal,
      );
  static TextStyle get overline => GoogleFonts.inter(
        fontSize: fontSizeOverline,
        fontWeight: fontWeightBold,
        letterSpacing: 1.3,
      );
  static TextStyle get statValue => GoogleFonts.inter(
        fontSize: fontSizeStat,
        fontWeight: fontWeightBold,
      );

  // Spacing
  static const double spacing2 = 2;
  static const double spacing4 = 4;
  static const double spacing6 = 6;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing32 = 32;
  static const double spacing40 = 40;
  static const double spacing48 = 48;
  static const double spacing56 = 56;
  static const double spacing64 = 64;
  static const double spacing80 = 80;
  static const double spacing96 = 96;

  static const EdgeInsets paddingAll4 = EdgeInsets.all(spacing4);
  static const EdgeInsets paddingAll8 = EdgeInsets.all(spacing8);
  static const EdgeInsets paddingAll12 = EdgeInsets.all(spacing12);
  static const EdgeInsets paddingAll16 = EdgeInsets.all(spacing16);
  static const EdgeInsets paddingAll20 = EdgeInsets.all(spacing20);
  static const EdgeInsets paddingAll24 = EdgeInsets.all(spacing24);
  static const EdgeInsets paddingAll32 = EdgeInsets.all(spacing32);
  static const EdgeInsets paddingHorizontal16 =
      EdgeInsets.symmetric(horizontal: spacing16);
  static const EdgeInsets paddingHorizontal20 =
      EdgeInsets.symmetric(horizontal: spacing20);
  static const EdgeInsets paddingHorizontal24 =
      EdgeInsets.symmetric(horizontal: spacing24);
  static const EdgeInsets paddingVertical8 =
      EdgeInsets.symmetric(vertical: spacing8);
  static const EdgeInsets paddingVertical16 =
      EdgeInsets.symmetric(vertical: spacing16);
  static const EdgeInsets paddingVertical24 =
      EdgeInsets.symmetric(vertical: spacing24);
  static const EdgeInsets marginAll16 = EdgeInsets.all(spacing16);
  static const EdgeInsets marginBottom12 = EdgeInsets.only(bottom: spacing12);
  static const EdgeInsets marginBottom16 = EdgeInsets.only(bottom: spacing16);
  static const EdgeInsets marginBottom24 = EdgeInsets.only(bottom: spacing24);

  static const SizedBox gap4 = SizedBox(height: spacing4, width: spacing4);
  static const SizedBox gap8 = SizedBox(height: spacing8, width: spacing8);
  static const SizedBox gap12 = SizedBox(height: spacing12, width: spacing12);
  static const SizedBox gap16 = SizedBox(height: spacing16, width: spacing16);
  static const SizedBox gap24 = SizedBox(height: spacing24, width: spacing24);
  static const SizedBox gap32 = SizedBox(height: spacing32, width: spacing32);
  static const SizedBox gap40 = SizedBox(height: spacing40, width: spacing40);
  static const SizedBox gap48 = SizedBox(height: spacing48, width: spacing48);
  static const SizedBox gap56 = SizedBox(height: spacing56, width: spacing56);
  static const SizedBox gap64 = SizedBox(height: spacing64, width: spacing64);
  static const SizedBox gap80 = SizedBox(height: spacing80, width: spacing80);
  static const SizedBox gap96 = SizedBox(height: spacing96, width: spacing96);

  // Radius
  static const double radiusSmall = 12;
  static const double radiusMedium = 18;
  static const double radiusLarge = 22;
  static const double radiusXLarge = 28;
  static const double radiusRound = 999;

  static BorderRadius get borderRadiusSmall => BorderRadius.circular(radiusSmall);
  static BorderRadius get borderRadiusMedium => BorderRadius.circular(radiusMedium);
  static BorderRadius get borderRadiusLarge => BorderRadius.circular(radiusLarge);
  static BorderRadius get borderRadiusXLarge => BorderRadius.circular(radiusXLarge);
  static BorderRadius get borderRadiusRound => BorderRadius.circular(radiusRound);

  static const RoundedRectangleBorder cardShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(radiusXLarge)),
  );
  static const RoundedRectangleBorder buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(radiusLarge)),
  );
  static const RoundedRectangleBorder inputShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(radiusLarge)),
  );

  static Border borderLightBorder = Border.all(color: borderLight, width: 1);
  static Border borderFocusBorder = Border.all(color: borderFocus, width: 1.4);
  static Border borderErrorBorder = Border.all(color: error, width: 1.2);

  static const double elevation0 = 0;
  static const double elevation1 = 1;
  static const double elevation2 = 2;
  static const double elevation4 = 4;
  static const double elevation8 = 8;

  static const double iconSmall = 16;
  static const double iconMedium = 24;
  static const double iconLarge = 32;
  static const double iconXLarge = 48;

  static const Duration animationFast = Duration(milliseconds: 180);
  static const Duration animationNormal = Duration(milliseconds: 320);
  static const Duration animationSlow = Duration(milliseconds: 520);
  static const Duration animationPage = Duration(milliseconds: 420);
  static const Curve curveStandard = Curves.easeOutCubic;
  static const Curve curveEmphasized = Curves.easeInOutCubicEmphasized;

  static List<BoxShadow> shadowSmall = const [
        BoxShadow(
          color: Color(0x220C0E68),
          blurRadius: 18,
          offset: Offset(0, 8),
        ),
      ];

  static List<BoxShadow> shadowMedium = const [
        BoxShadow(
          color: Color(0x220C0E68),
          blurRadius: 28,
          offset: Offset(0, 14),
        ),
      ];

  static List<BoxShadow> shadowSmallFor(BuildContext context) => [
        BoxShadow(
          color: paletteOf(context).glassShadow,
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> shadowMediumFor(BuildContext context) => [
        BoxShadow(
          color: paletteOf(context).glassShadow,
          blurRadius: 28,
          offset: const Offset(0, 14),
        ),
      ];

  static List<BoxShadow> glowShadowFor(BuildContext context) => [
        BoxShadow(
          color: paletteOf(context).primary.withValues(alpha: 0.28),
          blurRadius: 22,
          offset: const Offset(0, 8),
        ),
      ];

  static BoxDecoration glassDecoration(
    BuildContext context, {
    BorderRadius? radius,
  }) {
    final palette = paletteOf(context);
    return BoxDecoration(
      borderRadius: radius ?? borderRadiusXLarge,
      gradient: palette.glassGradient,
      border: Border.all(color: palette.glassBorder),
      boxShadow: shadowMediumFor(context),
    );
  }

  static BoxDecoration elevatedDecoration(
    BuildContext context, {
    BorderRadius? radius,
  }) {
    final palette = paletteOf(context);
    return BoxDecoration(
      color: palette.surfaceElevated,
      borderRadius: radius ?? borderRadiusLarge,
      border: Border.all(color: palette.border),
      boxShadow: shadowSmallFor(context),
    );
  }

  static ThemeData get theme => lightTheme;

  static ThemeData get lightTheme => _buildTheme(
        brightness: Brightness.light,
        palette: lightPalette,
      );

  static ThemeData get darkTheme => _buildTheme(
        brightness: Brightness.dark,
        palette: darkPalette,
      );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required AppPalette palette,
  }) {
    final base = brightness == Brightness.dark
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);

    final textTheme = GoogleFonts.interTextTheme(base.textTheme).copyWith(
      displayLarge: displayLarge.copyWith(color: palette.textPrimary),
      displayMedium: displayMedium.copyWith(color: palette.textPrimary),
      headlineLarge: headline1.copyWith(color: palette.textPrimary),
      headlineMedium: headline2.copyWith(color: palette.textPrimary),
      headlineSmall: headline3.copyWith(color: palette.textPrimary),
      titleLarge: headline4.copyWith(color: palette.textPrimary),
      titleMedium: headline5.copyWith(color: palette.textPrimary),
      bodyLarge: bodyLarge.copyWith(color: palette.textPrimary),
      bodyMedium: bodyMedium.copyWith(color: palette.textSecondary),
      bodySmall: bodySmall.copyWith(color: palette.textMuted),
      labelLarge: button.copyWith(
        color: brightness == Brightness.dark
            ? palette.backgroundBase
            : palette.textWhite,
      ),
      labelSmall: caption.copyWith(color: palette.textMuted),
    );

    return base.copyWith(
      extensions: <ThemeExtension<dynamic>>[palette],
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: palette.primary,
        onPrimary: brightness == Brightness.dark
            ? palette.backgroundBase
            : palette.textWhite,
        secondary: palette.primarySoft,
        onSecondary: palette.textPrimary,
        error: palette.error,
        onError: palette.textWhite,
        surface: palette.surfaceElevated,
        onSurface: palette.textPrimary,
      ),
      scaffoldBackgroundColor: palette.backgroundBase,
      primaryColor: palette.primary,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: palette.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: headline4.copyWith(color: palette.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: palette.surfaceElevated,
        shadowColor: palette.glassShadow,
        elevation: 0,
        shape: cardShape,
        margin: marginAll16,
      ),
      dividerTheme: DividerThemeData(
        color: palette.border,
        thickness: 1,
        space: spacing24,
      ),
      iconTheme: IconThemeData(
        color: palette.textPrimary,
        size: 22,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: palette.primary,
        linearTrackColor: palette.backgroundSecondary,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: palette.surfaceElevated,
        contentTextStyle: bodyMedium.copyWith(color: palette.textPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: borderRadiusLarge),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacing20,
          vertical: spacing18,
        ),
        hintStyle: bodyMedium.copyWith(color: palette.textMuted),
        labelStyle: bodyMedium.copyWith(color: palette.textSecondary),
        prefixIconColor: palette.textSecondary,
        suffixIconColor: palette.textSecondary,
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadiusLarge,
          borderSide: BorderSide(color: palette.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadiusLarge,
          borderSide: BorderSide(color: palette.primary, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadiusLarge,
          borderSide: BorderSide(color: palette.error, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: borderRadiusLarge,
          borderSide: BorderSide(color: palette.error, width: 1.4),
        ),
        border: OutlineInputBorder(
          borderRadius: borderRadiusLarge,
          borderSide: BorderSide(color: palette.border),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: brightness == Brightness.dark
              ? palette.backgroundBase
              : palette.textWhite,
          minimumSize: const Size(double.infinity, spacing56),
          shape: buttonShape,
          padding: paddingHorizontal24,
          textStyle: button,
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.textPrimary,
          minimumSize: const Size(double.infinity, spacing56),
          shape: buttonShape,
          side: BorderSide(color: palette.glassBorder),
          textStyle: bodyMedium.copyWith(
            color: palette.textPrimary,
            fontWeight: fontWeightSemiBold,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.primary,
          textStyle: bodyMedium.copyWith(
            color: palette.primary,
            fontWeight: fontWeightSemiBold,
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: palette.primary,
        unselectedItemColor: palette.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return palette.primary;
          return Colors.transparent;
        }),
        side: BorderSide(color: palette.glassBorder),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.primary,
        foregroundColor: brightness == Brightness.dark
            ? palette.backgroundBase
            : palette.textWhite,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: palette.textPrimary,
        textColor: palette.textPrimary,
        tileColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: borderRadiusLarge),
      ),
    );
  }
}

extension OldAppTheme on DesignSystem {
  static Color get purplePrimary => DesignSystem.primaryIndigo;
  static Color get purpleBackground => DesignSystem.backgroundLavender;
  static Color get purpleLight => DesignSystem.backgroundLight;
  static Color get purpleSecondary => DesignSystem.primaryIndigo;
}

extension DesignSystemExtension on BuildContext {
  AppPalette get palette => DesignSystem.paletteOf(this);
  double get spacing8 => DesignSystem.spacing8;
  double get spacing16 => DesignSystem.spacing16;
  double get spacing24 => DesignSystem.spacing24;
  EdgeInsets get paddingAll16 => DesignSystem.paddingAll16;
  EdgeInsets get paddingHorizontal16 => DesignSystem.paddingHorizontal16;
  SizedBox get gap8 => DesignSystem.gap8;
  SizedBox get gap16 => DesignSystem.gap16;
  BorderRadius get radiusLarge => DesignSystem.borderRadiusLarge;
  BorderRadius get radiusXLarge => DesignSystem.borderRadiusXLarge;
}
