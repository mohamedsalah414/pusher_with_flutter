//palette.dart
import 'package:flutter/material.dart';
class Palette {
  static const MaterialColor kPink = const MaterialColor(
    0xffFF7FBD, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    const <int, Color>{
      50: const Color(0xffe672aa ),//10%
      100: const Color(0xffcc6697),//20%
      200: const Color(0xffb35984),//30%
      300: const Color(0xff994c71),//40%
      400: const Color(0xff80405f),//50%
      500: const Color(0xff66334c),//60%
      600: const Color(0xff4c2639),//70%
      700: const Color(0xff331926),//80%
      800: const Color(0xff190d13),//90%
      900: const Color(0xff000000),//100%
    },
  );
}