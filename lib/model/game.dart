import 'dart:convert';

import 'package:collection/collection.dart';

import 'current_numbers.dart';
import 'player.dart';

class Game {
  int selectedNumber = 100;
  Player player;
  List<CurrentNumber> currentNumbers = [];
  bool isKilled = false;
  Game({
    this.selectedNumber,
    this.player,
    this.currentNumbers,
    this.isKilled,
  });

  Game copyWith({
    int selectedNumber,
    Player player,
    List<CurrentNumber> currentNumbers,
    bool isKilled,
  }) {
    return Game(
      selectedNumber: selectedNumber ?? this.selectedNumber,
      player: player ?? this.player,
      currentNumbers: currentNumbers ?? this.currentNumbers,
      isKilled: isKilled ?? this.isKilled ?? false,
    );
  }

  @override
  String toString() {
    return 'Game(selectedNumber: $selectedNumber, player: $player, currentNumbers: $currentNumbers, isKilled: $isKilled)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return o is Game &&
        o.selectedNumber == selectedNumber &&
        o.player == player &&
        listEquals(o.currentNumbers, currentNumbers) &&
        o.isKilled == isKilled;
  }

  @override
  int get hashCode {
    return selectedNumber.hashCode ^
        player.hashCode ^
        currentNumbers.hashCode ^
        isKilled.hashCode;
  }
}
