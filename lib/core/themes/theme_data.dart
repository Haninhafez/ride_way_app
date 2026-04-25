import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: Color(0xff020617),
  primaryColor: Color(0xff0047AB),
  colorScheme: ColorScheme.dark(
    surface: Color(0xff33373E),
    onSurface: Color(0xffC3C6D5),
    secondary: Color(0xff171A1F),
    onSecondary: Color(0xffE2E2E5),
    tertiary: Color(0xff2979FF)
  ),
);

ThemeData lightTheme = ThemeData(scaffoldBackgroundColor: Color(0xffF9F9FC),
primaryColor: Color(0xff00327D),
colorScheme: ColorScheme.light(
  surface: Color(0xffE2E2E5),
  onSurface: Color(0xff434653),
  secondary: Color(0xffF3F3F6),
  onSecondary: Color(0xff1A1C1E),
  tertiary: Color(0xff0047AB)
),

);
