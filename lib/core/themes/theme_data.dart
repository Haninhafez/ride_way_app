import 'package:flutter/material.dart';

// ─── Brand Palette ─────────────────────────────────────────────────────────
const kColorPrimaryAction = Color(
  0xFF181818,
); // Charcoal Black – buttons/headers
const kColorBackground = Color(0xFFF6F6F6);
const kColorBackgroundnew = Color(0xff181818);
// Off-white – scaffold background
const kColorSubtitle = Color.fromARGB(255, 193, 193, 201);
const kColorSubtitleold = Color(0xFF8E8E93);
const kColorRedBrawon = Color(0xFF3A3A3C);

/// Muted Grey – secondary text
const kColorAccentGold = Color(0xFFD1A546);
const KColorDarkGold = Color(0xff5B4C2B); // Gold – hyperlinks
const kColorFieldFill = Color(0xFFFFFFFF); // White – input fill
const kColorBorder = Color(0xFFE5E5EA); // Light border
const kColorSuccess = Color(0xFF34C759); // Green – strong password / checks
const KColorDarkGrey = Color(0xff262626);

ThemeData darkTheme = ThemeData(
  useMaterial3: false,
  scaffoldBackgroundColor: const Color(0xFF0F131A),
  primaryColor: kColorPrimaryAction,
  colorScheme: const ColorScheme.dark(
    primaryContainer: Color(0xFF1C1C1E),
    primary: kColorPrimaryAction,
    surface: Color(0xFF2C2C2E),
    onSurface: Color(0xFFAEAEB2),
    secondary: Color(0xFF1C1C1E),
    onSecondary: Color(0xFFE5E5EA),
    tertiary: kColorAccentGold,
  ),
);

ThemeData lightTheme = ThemeData(
  useMaterial3: false,
  scaffoldBackgroundColor: kColorBackground,
  primaryColor: kColorPrimaryAction,
  colorScheme: const ColorScheme.light(
    primaryContainer: kColorFieldFill,
    primary: kColorPrimaryAction,
    surface: kColorFieldFill,
    onSurface: Color(0xFF3A3A3C),
    secondary: kColorBackground,
    onSecondary: kColorPrimaryAction,
    tertiary: kColorAccentGold,
  ),
);
