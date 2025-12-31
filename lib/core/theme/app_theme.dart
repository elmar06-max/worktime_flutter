import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  const primary = Color(0xFF2563EB);
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: primary),
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.grey[50],
    appBarTheme: const AppBarTheme(
      centerTitle: true,
    ),
  );
}
