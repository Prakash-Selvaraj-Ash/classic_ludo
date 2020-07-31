import 'dart:convert';

import 'package:flutter/foundation.dart';

class Player {
  final int startIndex;

  int availableCoins;
  int fruitCoins;
  int colorIndex;
  bool isStarted;
  bool isKilled;
  List<int> presentIndices = [];
  List<int> routes = [];
  Player({
    this.startIndex,
    this.availableCoins,
    this.fruitCoins,
    this.colorIndex,
    this.isStarted = false,
    this.isKilled = false,
    this.presentIndices,
    this.routes,
  });

  Player copyWith({
    int startIndex,
    int availableCoins,
    int fruitCoins,
    int colorIndex,
    bool isStarted,
    bool isKilled,
    List<int> presentIndices,
    List<int> routes,
  }) {
    return Player(
      startIndex: startIndex ?? this.startIndex,
      availableCoins: availableCoins ?? this.availableCoins,
      fruitCoins: fruitCoins ?? this.fruitCoins,
      colorIndex: colorIndex ?? this.colorIndex,
      isStarted: isStarted ?? this.isStarted,
      isKilled: isKilled ?? this.isKilled,
      presentIndices: presentIndices ?? this.presentIndices,
      routes: routes ?? this.routes,
    );
  }

  @override
  String toString() {
    return 'Player(startIndex: $startIndex, availableCoins: $availableCoins, colorIndex: $colorIndex, isStarted: $isStarted, isKilled: $isKilled, presentIndices: $presentIndices, routes: $routes)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Player &&
        o.startIndex == startIndex &&
        o.availableCoins == availableCoins &&
        o.colorIndex == colorIndex &&
        o.isStarted == isStarted &&
        o.isKilled == isKilled &&
        listEquals(o.presentIndices, presentIndices) &&
        listEquals(o.routes, routes);
  }

  @override
  int get hashCode {
    return startIndex.hashCode ^
        availableCoins.hashCode ^
        colorIndex.hashCode ^
        isStarted.hashCode ^
        isKilled.hashCode ^
        presentIndices.hashCode ^
        routes.hashCode;
  }
}
