import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff934b00),
      surfaceTint: Color(0xff934b00),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xfff98513),
      onPrimaryContainer: Color(0xff5d2d00),
      secondary: Color(0xff865229),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xfffdb886),
      onSecondaryContainer: Color(0xff78461f),
      tertiary: Color(0xff5c6300),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffa0ac00),
      onTertiaryContainer: Color(0xff383d00),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffff8f5),
      onSurface: Color(0xff241912),
      onSurfaceVariant: Color(0xff564335),
      outline: Color(0xff8a7263),
      outlineVariant: Color(0xffddc1af),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff3a2e26),
      inversePrimary: Color(0xffffb783),
      primaryFixed: Color(0xffffdcc5),
      onPrimaryFixed: Color(0xff301400),
      primaryFixedDim: Color(0xffffb783),
      onPrimaryFixedVariant: Color(0xff703700),
      secondaryFixed: Color(0xffffdcc5),
      onSecondaryFixed: Color(0xff301400),
      secondaryFixedDim: Color(0xfffdb886),
      onSecondaryFixedVariant: Color(0xff6a3b14),
      tertiaryFixed: Color(0xffdfec4f),
      onTertiaryFixed: Color(0xff1b1d00),
      tertiaryFixedDim: Color(0xffc3d034),
      onTertiaryFixedVariant: Color(0xff454b00),
      surfaceDim: Color(0xffebd6ca),
      surfaceBright: Color(0xfffff8f5),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff1e9),
      surfaceContainer: Color(0xffffeadd),
      surfaceContainerHigh: Color(0xfff9e4d8),
      surfaceContainerHighest: Color(0xfff3dfd2),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff572a00),
      surfaceTint: Color(0xff934b00),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffa95700),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff562b05),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff976036),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff353900),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff6a7300),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f5),
      onSurface: Color(0xff190f08),
      onSurfaceVariant: Color(0xff443226),
      outline: Color(0xff634e40),
      outlineVariant: Color(0xff7f695a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff3a2e26),
      inversePrimary: Color(0xffffb783),
      primaryFixed: Color(0xffa95700),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff854300),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff976036),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff7b4921),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff6a7300),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff535900),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd6c3b7),
      surfaceBright: Color(0xfffff8f5),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff1e9),
      surfaceContainer: Color(0xfff9e4d8),
      surfaceContainerHigh: Color(0xffedd9cd),
      surfaceContainerHighest: Color(0xffe2cec2),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff492200),
      surfaceTint: Color(0xff934b00),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff743900),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff492200),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff6d3d16),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff2b2f00),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff474d00),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f5),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff3a281c),
      outlineVariant: Color(0xff594538),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff3a2e26),
      inversePrimary: Color(0xffffb783),
      primaryFixed: Color(0xff743900),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff522700),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff6d3d16),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff512802),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff474d00),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff313600),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc8b5aa),
      surfaceBright: Color(0xfffff8f5),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffffede3),
      surfaceContainer: Color(0xfff3dfd2),
      surfaceContainerHigh: Color(0xffe5d1c5),
      surfaceContainerHighest: Color(0xffd6c3b7),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffb783),
      surfaceTint: Color(0xffffb783),
      onPrimary: Color(0xff4f2500),
      primaryContainer: Color(0xfff98513),
      onPrimaryContainer: Color(0xff5d2d00),
      secondary: Color(0xfffdb886),
      onSecondary: Color(0xff4f2501),
      secondaryContainer: Color(0xff6a3b14),
      onSecondaryContainer: Color(0xffe9a776),
      tertiary: Color(0xffc3d034),
      onTertiary: Color(0xff2f3300),
      tertiaryContainer: Color(0xffa0ac00),
      onTertiaryContainer: Color(0xff383d00),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff1b110a),
      onSurface: Color(0xfff3dfd2),
      onSurfaceVariant: Color(0xffddc1af),
      outline: Color(0xffa58c7c),
      outlineVariant: Color(0xff564335),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff3dfd2),
      inversePrimary: Color(0xff934b00),
      primaryFixed: Color(0xffffdcc5),
      onPrimaryFixed: Color(0xff301400),
      primaryFixedDim: Color(0xffffb783),
      onPrimaryFixedVariant: Color(0xff703700),
      secondaryFixed: Color(0xffffdcc5),
      onSecondaryFixed: Color(0xff301400),
      secondaryFixedDim: Color(0xfffdb886),
      onSecondaryFixedVariant: Color(0xff6a3b14),
      tertiaryFixed: Color(0xffdfec4f),
      onTertiaryFixed: Color(0xff1b1d00),
      tertiaryFixedDim: Color(0xffc3d034),
      onTertiaryFixedVariant: Color(0xff454b00),
      surfaceDim: Color(0xff1b110a),
      surfaceBright: Color(0xff43372e),
      surfaceContainerLowest: Color(0xff150c06),
      surfaceContainerLow: Color(0xff241912),
      surfaceContainer: Color(0xff281d16),
      surfaceContainerHigh: Color(0xff332820),
      surfaceContainerHighest: Color(0xff3f322a),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffd4b7),
      surfaceTint: Color(0xffffb783),
      onPrimary: Color(0xff3f1c00),
      primaryContainer: Color(0xfff98513),
      onPrimaryContainer: Color(0xff2c1200),
      secondary: Color(0xffffd4b7),
      onSecondary: Color(0xff3f1c00),
      secondaryContainer: Color(0xffc08356),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffd9e649),
      onTertiary: Color(0xff242800),
      tertiaryContainer: Color(0xffa0ac00),
      onTertiaryContainer: Color(0xff181a00),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff1b110a),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfff4d7c4),
      outline: Color(0xffc8ad9b),
      outlineVariant: Color(0xffa48b7b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff3dfd2),
      inversePrimary: Color(0xff723800),
      primaryFixed: Color(0xffffdcc5),
      onPrimaryFixed: Color(0xff200c00),
      primaryFixedDim: Color(0xffffb783),
      onPrimaryFixedVariant: Color(0xff572a00),
      secondaryFixed: Color(0xffffdcc5),
      onSecondaryFixed: Color(0xff200c00),
      secondaryFixedDim: Color(0xfffdb886),
      onSecondaryFixedVariant: Color(0xff562b05),
      tertiaryFixed: Color(0xffdfec4f),
      onTertiaryFixed: Color(0xff101300),
      tertiaryFixedDim: Color(0xffc3d034),
      onTertiaryFixedVariant: Color(0xff353900),
      surfaceDim: Color(0xff1b110a),
      surfaceBright: Color(0xff4f4239),
      surfaceContainerLowest: Color(0xff0e0602),
      surfaceContainerLow: Color(0xff261b14),
      surfaceContainer: Color(0xff31261e),
      surfaceContainerHigh: Color(0xff3c3028),
      surfaceContainerHighest: Color(0xff483b33),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffece2),
      surfaceTint: Color(0xffffb783),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffffb178),
      onPrimaryContainer: Color(0xff170700),
      secondary: Color(0xffffece2),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xfff8b483),
      onSecondaryContainer: Color(0xff170700),
      tertiary: Color(0xffecfa5b),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffbfcc2f),
      onTertiaryContainer: Color(0xff0b0c00),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff1b110a),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffffece2),
      outlineVariant: Color(0xffd9bdab),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff3dfd2),
      inversePrimary: Color(0xff723800),
      primaryFixed: Color(0xffffdcc5),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffffb783),
      onPrimaryFixedVariant: Color(0xff200c00),
      secondaryFixed: Color(0xffffdcc5),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xfffdb886),
      onSecondaryFixedVariant: Color(0xff200c00),
      tertiaryFixed: Color(0xffdfec4f),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffc3d034),
      onTertiaryFixedVariant: Color(0xff101300),
      surfaceDim: Color(0xff1b110a),
      surfaceBright: Color(0xff5b4d44),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff281d16),
      surfaceContainer: Color(0xff3a2e26),
      surfaceContainerHigh: Color(0xff463930),
      surfaceContainerHighest: Color(0xff52443b),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        // scaffoldBackgroundColor: colorScheme.background,
        // canvasColor: colorScheme.surface,
        cardTheme: CardTheme(
          elevation: 20,
          // color: colorScheme.surface,
          shadowColor: colorScheme.shadow.withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          fillColor: colorScheme.surface,
          filled: true,
          // floatingLabelBehavior: FloatingLabelBehavior.always,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorScheme.outline),
            borderRadius: BorderRadius.circular(4.0),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: colorScheme.outline),
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
