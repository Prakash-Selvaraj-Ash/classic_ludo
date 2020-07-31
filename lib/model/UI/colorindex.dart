import 'package:flutter/material.dart';

class ColorIndex {
  List<Color> _colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow];
  List<String> _colorName = ['RED', 'BLUE', 'GREEN', 'YELLOW'];
  getColor(int index) {
    return _colors[index];
  }

  getName(int index) {
    return _colorName[index];
  }
}
