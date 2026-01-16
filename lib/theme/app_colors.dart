import 'package:flutter/material.dart';

class AppColors {
  // Se é dark mode ou não
  static bool isDark = true;

  static Color get yellow =>
      isDark ? const Color(0xFFF1DB4B) : const Color.fromARGB(255, 0, 0, 0);

  static Color get yellowTrue => const Color(0xFFF1DB4B);
  static Color get darkTrue => const Color(0xFF2D2D2D);

  // Aqui mudamos o valor dinamicamente sem alterar o nome
  static Color get dark => isDark
      ? const Color(0xFF2D2D2D)
      : const Color.fromARGB(255, 248, 242, 180);
  static Color get white => isDark ? Colors.white : Colors.black;
  static Color get gray => Colors.grey;
  static Color get lightInput => isDark
      ? const Color.fromARGB(255, 0, 0, 0)
      : const Color.fromARGB(255, 0, 0, 0);
  static Color get purple => const Color(0xFF4E148C);
}
