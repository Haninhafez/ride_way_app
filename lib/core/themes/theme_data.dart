import 'package:flutter/material.dart';

const kColorPrimaryAction = Color(
  0xFF181818,
); 
const kColorBackground = Color(0xFFF6F6F6);
const kColorBackgroundnew = Color(0xff181818);
const kColorSubtitle = Color.fromARGB(255, 193, 193, 201);
const kColorSubtitleold = Color(0xFF8E8E93);
const kColorRedBrawon = Color(0xFF3A3A3C);

const kColorAccentGold = Color(0xFFD1A546);
const KColorDarkGold = Color(0xff5B4C2B); 
const kColorFieldFill = Color(0xFFFFFFFF); 
const kColorBorder = Color(0xFFE5E5EA); 
const kColorSuccess = Color(0xFF34C759); 
const KColorDarkGrey = Color(0xff262626);

ThemeData darkTheme = ThemeData(
  useMaterial3: false,
  scaffoldBackgroundColor: kColorBackgroundnew,
  primaryColor: kColorPrimaryAction,
  colorScheme: ColorScheme.dark(
    primaryContainer: Colors.grey.withAlpha(15),
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
