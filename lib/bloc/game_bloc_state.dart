part of 'game_bloc_bloc.dart';

@immutable
abstract class GameBlocState {
  final Game gameModel;
  GameBlocState(this.gameModel);
}

class GameBlocNoTranistion extends GameBlocState {
  final Game gameModel;
  GameBlocNoTranistion(this.gameModel) : super(gameModel);
}

class GameBlocInitial extends GameBlocState {
  GameBlocInitial(Player player)
      : super(Game(player: player, currentNumbers: []));
}

class GameBlocPlayerChanged extends GameBlocState {
  final Game gameModel;
  GameBlocPlayerChanged(this.gameModel) : super(gameModel);
}

class GameBlocNumberAdded extends GameBlocState {
  final Game gameModel;
  GameBlocNumberAdded(this.gameModel) : super(gameModel);
}

class GameBlocNumberRemoved extends GameBlocState {
  final Game gameModel;
  GameBlocNumberRemoved(this.gameModel) : super(gameModel);
}

class GameBlocCoinRemoved extends GameBlocState {
  final Game gameModel;
  GameBlocCoinRemoved(this.gameModel) : super(gameModel);
}

class GameBlocCoinAdded extends GameBlocState {
  final Game gameModel;
  GameBlocCoinAdded(this.gameModel) : super(gameModel);
}

class TileUpdated extends GameBlocState {
  final Game gameModel;
  final List<TileModel> tileModelsToUpdate;
  TileUpdated(this.gameModel, this.tileModelsToUpdate) : super(gameModel);
}

class Dhayam extends GameBlocState {
  final Game gameModel;
  final TileModel tileModel;
  Dhayam(this.gameModel, this.tileModel) : super(gameModel);
}

class NumberChoosed extends GameBlocState {
  final Game gameModel;
  final List<TileModel> tileModels;
  NumberChoosed(this.gameModel, this.tileModels) : super(gameModel);
}

class CoinRippened extends GameBlocState {
  final Game gameModel;
  final Player player;
  CoinRippened(this.gameModel, this.player) : super(gameModel);
}

class GameOver extends GameBlocState {
  final Game gameModel;
  GameOver(this.gameModel) : super(gameModel);
}
