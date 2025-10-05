import 'package:flutter/material.dart';

Color getColorForId(String id) {
  final colors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
  ];
  final hash = id.codeUnits.fold(0, (prev, elem) => prev + elem);
  return colors[hash % colors.length];
}
