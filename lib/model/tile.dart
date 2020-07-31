import 'package:flutter/foundation.dart';

import '../game_repository.dart';

class TileModel {
  final GameRepository gameRepository;
  final int index;
  List<int> players = [];
  bool isMountain;
  TileModel(
    this.gameRepository,
    this.index, {
    this.players,
    this.isMountain,
  }) {
    isMountain = gameRepository.mountainIndexCollection.contains(index);
  }

  TileModel copyWith({
    GameRepository gameRepository,
    int index,
    List<int> players,
    bool isMountain,
  }) {
    return TileModel(
      this.gameRepository,
      this.index,
      players: players ?? this.players,
      isMountain: isMountain ?? this.isMountain,
    );
  }

  @override
  String toString() {
    return 'TileModel(gameRepository: $gameRepository, index: $index, players: $players, isMountain: $isMountain)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is TileModel &&
        o.gameRepository == gameRepository &&
        o.index == index &&
        listEquals(o.players, players) &&
        o.isMountain == isMountain;
  }

  @override
  int get hashCode {
    return gameRepository.hashCode ^
        index.hashCode ^
        players.hashCode ^
        isMountain.hashCode;
  }
}
