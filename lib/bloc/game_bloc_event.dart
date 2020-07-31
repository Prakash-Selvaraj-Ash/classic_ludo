part of 'game_bloc_bloc.dart';

@immutable
abstract class GameBlocEvent {}

class GamePlayerChangedEvent extends GameBlocEvent {
  final Player player;
  GamePlayerChangedEvent(this.player);
}

class GameNumberAddedEvent extends GameBlocEvent {
  final int number;
  GameNumberAddedEvent(this.number);
}

class GameNumberRemovedEvent extends GameBlocEvent {
  final int number;
  GameNumberRemovedEvent(this.number);
}

class GameCoinMovedEvent extends GameBlocEvent {
  final Player player;
  final int numberOfMoves;
  final int startIndex;
  GameCoinMovedEvent(this.player, this.numberOfMoves, this.startIndex);
}

class DhayamEvent extends GameBlocEvent {
  final int number;
  DhayamEvent(this.number);
}

class NumberChoosedEvent extends GameBlocEvent {
  final Player player;
  final int selectedNumber;
  final List<TileModel> tilesToUpdate;
  NumberChoosedEvent(this.player, this.selectedNumber, this.tilesToUpdate);
}

class FruitEvent extends GameBlocEvent {
  final Player player;
  FruitEvent(this.player);
}

class TileUpdateRequestEvent extends GameBlocEvent {
  final Player player;
  final int selectedNumber;
  final int startIndex;

  TileUpdateRequestEvent(this.player, this.selectedNumber, this.startIndex);
}
