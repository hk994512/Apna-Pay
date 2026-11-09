import 'package:flutter/material.dart';


class Network {
  final String name;
  final String letter;
  final Color brandColor; // for the circle
  final Color bgColor; // for the tile background (soft tint)
  final Color borderColor; // selected border color

  Network({
    required this.name,
    required this.letter,
    required this.brandColor,
    required this.bgColor,
    required this.borderColor,
  });
}

class MobileLoadData {
  MobileLoadData._();

  static const String defaultNumber = '0308 6449464';

  static List<Network> networks = [
    Network(
      name: 'Jazz',
      letter: 'J',
      brandColor: const Color(0xFFD6001C),
      bgColor: const Color(0xFFFCE4E7),
      borderColor: const Color(0xFFD6001C),
    ),
    Network(
      name: 'Telenor',
      letter: 'T',
      brandColor: const Color(0xFF00B5E2),
      bgColor: const Color(0xFFE0F6FB),
      borderColor: const Color(0xFF00B5E2),
    ),
    Network(
      name: 'Zong',
      letter: 'Z',
      brandColor: const Color(0xFF7AB800),
      bgColor: const Color(0xFFEFF7DC),
      borderColor: const Color(0xFF7AB800),
    ),
    Network(
      name: 'Ufone',
      letter: 'U',
      brandColor: const Color(0xFFF47B20),
      bgColor: const Color(0xFFFDEEE0),
      borderColor: const Color(0xFFF47B20),
    ),
  ];

  static const List<int> prepaidAmounts = [100, 200, 300, 500, 1000, 2000];
}
