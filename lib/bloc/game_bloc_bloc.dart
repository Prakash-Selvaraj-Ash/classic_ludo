import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ludo/game_repository.dart';

import 'package:ludo/model/current_numbers.dart';
import 'package:ludo/model/game.dart';
import 'package:ludo/model/player.dart';
import 'package:ludo/model/tile.dart';
import 'package:meta/meta.dart';

part 'game_bloc_event.dart';
part 'game_bloc_state.dart';

class GameBlocBloc extends Bloc<GameBlocEvent, GameBlocState> {
  final GameRepository gameRepository;
  List<TileModel> tiles;
  GameBlocBloc(this.gameRepository)
      : super(GameBlocInitial(gameRepository.players.first)) {
    tiles = Iterable.generate(49)
        .map((index) => TileModel(gameRepository, index, players: []))
        .toList();
  }

  Player getNextPlayerIndex() {
    int playerIndex = 0;
    if (gameRepository.numberOfPlayers == 2) {
      playerIndex = state.gameModel.player.colorIndex ^ 1;
    }

    if (gameRepository.numberOfPlayers == 4) {
      var players = gameRepository.players
          .where((element) =>
              (element.fruitCoins ?? 0) < gameRepository.numberOfCoins)
          .toList();

      return state.gameModel.player.colorIndex == players.last.colorIndex
          ? players.first
          : players.firstWhere((element) =>
              element.colorIndex > state.gameModel.player.colorIndex);
    }
    return gameRepository.players.elementAt(playerIndex);
  }

  @override
  Stream<GameBlocState> mapEventToState(
    GameBlocEvent event,
  ) async* {
    var type = (event.runtimeType);
    switch (type) {
      case GamePlayerChangedEvent:
        yield _playerChanged(event as GamePlayerChangedEvent);
        break;

      case GameNumberAddedEvent:
        var addedEvent = event as GameNumberAddedEvent;

        yield _numberAdded(addedEvent);
        _considerForDhayams(addedEvent);
        break;

      case TileUpdateRequestEvent:
        TileUpdateRequestEvent requestEvent = event as TileUpdateRequestEvent;
        bool canUpdateTile = _canUpdateTile(requestEvent);
        if (canUpdateTile) {
          yield _updateTile(requestEvent);
          state.gameModel.selectedNumber = 100;
          _considerToChangePlayer();
        }
        break;

      case DhayamEvent:
        yield _dhayam(event as DhayamEvent);
        state.gameModel.selectedNumber = 100;
        break;

      case NumberChoosedEvent:
        var numberChoosedEvent = event as NumberChoosedEvent;
        yield _numberChoosed(numberChoosedEvent);
        _considerForDhayam(numberChoosedEvent.selectedNumber);
        break;
      case FruitEvent:
        var fruitEvent = event as FruitEvent;
        yield _fruitRippened(fruitEvent);
    }
  }

  GameBlocState _playerChanged(GamePlayerChangedEvent event) {
    var gameModel = state.gameModel;
    return GameBlocPlayerChanged(gameModel.copyWith(
        player: event.player, currentNumbers: [], selectedNumber: 100));
  }

  GameBlocState _dhayam(DhayamEvent event) {
    state.gameModel.currentNumbers
        .firstWhere((element) =>
            !element.isSelected && element.currentNumber == event.number)
        .isSelected = true;
    var coins = state.gameModel.player.availableCoins - 1;
    state.gameModel.player.availableCoins = coins;
    var presentIndices = state.gameModel.player.presentIndices ?? [];
    var tile = tiles.elementAt(state.gameModel.player.startIndex);
    tile.players = [...tile.players, state.gameModel.player.colorIndex];
    state.gameModel.player.presentIndices = [
      ...presentIndices,
      state.gameModel.player.startIndex
    ];
    return Dhayam(
        state.gameModel.copyWith(
            currentNumbers: [...state.gameModel.currentNumbers],
            selectedNumber: event.number),
        tile);
  }

  GameBlocState _numberAdded(GameNumberAddedEvent event) {
    if (event.number == 1) {
      if (!state.gameModel.player.isStarted) {
        state.gameModel.player.isStarted = true;
      }
      return GameBlocPlayerChanged(state.gameModel.copyWith(currentNumbers: [
        CurrentNumber(currentNumber: event.number, isSelected: false),
        ...state.gameModel.currentNumbers
      ]));
    }
    if (state.gameModel.player.isStarted) {
      return GameBlocPlayerChanged(state.gameModel.copyWith(currentNumbers: [
        CurrentNumber(currentNumber: event.number, isSelected: false),
        ...state.gameModel.currentNumbers
      ]));
    }
    return GameBlocPlayerChanged(state.gameModel
        .copyWith(player: getNextPlayerIndex(), currentNumbers: []));
  }

  GameBlocState _updateTile(TileUpdateRequestEvent event) {
    var tileToRemove =
        tiles.firstWhere((element) => element.index == event.startIndex);
    tileToRemove.players.remove(event.player.colorIndex);
    var removedPlayerTile =
        tileToRemove.copyWith(players: [...tileToRemove.players]);
    state.gameModel.isKilled ??= false;
    var routes = event.player.routes;
    var endIndex = routes.indexOf(event.startIndex) + event.selectedNumber;
    var tileToUpdate = tiles
        .firstWhere((element) => element.index == routes.elementAt(endIndex));

    if (tileToUpdate.isMountain) {
      if (tileToUpdate.index == 24) {
        this.add(FruitEvent(state.gameModel.player));
      }
      tileToUpdate.players = [...tileToUpdate.players, event.player.colorIndex];
    } else {
      if (tileToUpdate.players.length > 0) {
        var playerIndex = tileToUpdate.players.first;

        var existingPlayer = gameRepository.getPlayer(playerIndex);
        existingPlayer.availableCoins = existingPlayer.availableCoins + 1;

        var currentPlayer = gameRepository.getPlayer(event.player.colorIndex);
        currentPlayer.isKilled = true;
        state.gameModel.isKilled = true;
      }

      tileToUpdate.players = [event.player.colorIndex];
    }

    return TileUpdated(state.gameModel, [removedPlayerTile, tileToUpdate]);
  }

  GameBlocState _numberChoosed(NumberChoosedEvent event) {
    state.gameModel.currentNumbers
        .firstWhere((element) =>
            element.currentNumber == event.selectedNumber &&
            element.isSelected == false)
        .isSelected = true;

    return NumberChoosed(
        state.gameModel.copyWith(
            player: state.gameModel.player,
            currentNumbers: [...state.gameModel.currentNumbers],
            selectedNumber: event.selectedNumber),
        event.tilesToUpdate);
  }

  bool _canUpdateTile(TileUpdateRequestEvent event) {
    if (!_canUpdateForSamePlayer(event)) {
      return false;
    }

    if (!_canEnterInnerIndex(event)) {
      return false;
    }
    return true;
  }

  bool _canEnterInnerIndex(TileUpdateRequestEvent event) {
    return _checkForInnerIndex(
        event.player, event.startIndex, event.selectedNumber);
  }

  bool _checkForInnerIndex(Player player, int startIndex, int selectedNumber) {
    var routes = player.routes;
    var endIndex = routes.indexOf(startIndex) + selectedNumber;
    if (endIndex >= routes.length) {
      return false;
    }
    var targetIndex = routes.elementAt(endIndex);
    bool isOuterIndex = gameRepository.getOuterIndex().contains(targetIndex);
    if (isOuterIndex) {
      return true;
    }
    return player.isKilled;
  }

  bool _canUpdateForSamePlayer(TileUpdateRequestEvent event) {
    return _canInnerUpdateForSamePlayer(
        event.player, event.startIndex, event.selectedNumber);
  }

  bool _canInnerUpdateForSamePlayer(
      Player player, int startIndex, int selectedNumber) {
    var routes = player.routes;
    var endIndex = routes.indexOf(startIndex) + selectedNumber;
    if (endIndex >= routes.length) {
      return false;
    }
    var tileToUpdate = tiles
        .firstWhere((element) => element.index == routes.elementAt(endIndex));
    if (tileToUpdate.isMountain) {
      return true;
    }
    return !tileToUpdate.players.contains(player.colorIndex);
  }

  bool _canContinueGame() {
    var player = state.gameModel.player;
    if (!player.isStarted &&
        !state.gameModel.currentNumbers
            .any((element) => element.currentNumber == 1)) {
      return true;
    }

    var playerIndices = tiles
        .where((tile) =>
            tile.players.any((playerIndex) => playerIndex == player.colorIndex))
        .map((tile) => tile.index)
        .toList();

    var dhayams = state.gameModel.currentNumbers
        .where((number) => number.currentNumber == 1);

    var noOfFives = state.gameModel.currentNumbers
        .where((number) => number.currentNumber == 5);

    int noOfDhayamToPlay = dhayams.length;
    int noOfFiveToPlay = noOfFives.length;
    int dhayamsToAddCoin = 0;

    if (dhayams.length + noOfFives.length >
        state.gameModel.player.availableCoins) {
      if (state.gameModel.player.availableCoins >= dhayams.length) {
        noOfDhayamToPlay =
            state.gameModel.player.availableCoins - dhayams.length;
        noOfFiveToPlay = noOfFives.length;
      } else {
        var fives = state.gameModel.player.availableCoins - dhayams.length;
        noOfFiveToPlay = noOfFives.length - fives;
      }
      dhayamsToAddCoin = state.gameModel.player.availableCoins;
    } else {
      var coins = state.gameModel.player.availableCoins;
      noOfDhayamToPlay = dhayams.length - coins;
      noOfDhayamToPlay = noOfDhayamToPlay >= 0 ? noOfDhayamToPlay : 0;
      noOfFiveToPlay = noOfFiveToPlay - (coins - dhayams.length);
      noOfFiveToPlay = noOfFiveToPlay >= 0 ? noOfFiveToPlay : 0;
      dhayamsToAddCoin = (dhayams.length + noOfFives.length) -
          (noOfDhayamToPlay + noOfFiveToPlay);
    }

    playerIndices = [
      ...playerIndices,
      ...Iterable.generate(dhayamsToAddCoin).map((d) => player.startIndex)
    ].toList();

    var nonDhayamNumbers = state.gameModel.currentNumbers.where(
        (number) => !(number.currentNumber == 1 || number.currentNumber == 5));
    var numbersToMove = [
      ...nonDhayamNumbers.map((e) => NumberMoved(e, false)),
      ...Iterable.generate(noOfDhayamToPlay).map((e) => NumberMoved(
          CurrentNumber(currentNumber: 1, isSelected: false), false)),
      ...Iterable.generate(noOfFiveToPlay).map((e) => NumberMoved(
          CurrentNumber(currentNumber: 5, isSelected: false), false))
    ].toList();

    playerIndices.forEach((index) {
      int currentIndex = index;
      numbersToMove.where((element) => !element.isMoved).forEach((element) {
        bool canMove = _canInnerUpdateForSamePlayer(state.gameModel.player,
            currentIndex, element.currentNumber.currentNumber);
        bool canEnterInnerIndex = _checkForInnerIndex(state.gameModel.player,
            currentIndex, element.currentNumber.currentNumber);
        if (!element.isMoved) {
          element.isMoved = canMove && canEnterInnerIndex;
          var routes = state.gameModel.player.routes;
          var endIndex = routes.indexOf(currentIndex) +
              element.currentNumber.currentNumber;
          if (endIndex < routes.length) {
            currentIndex = routes.elementAt(endIndex);
          }
        }
      });
    });

    return !numbersToMove.any((element) => !element.isMoved);
  }

  void _considerToChangePlayer() {
    bool hasItems = state.gameModel.currentNumbers
        .map((e) => e.isSelected)
        .toSet()
        .contains(false);
    if (!hasItems) {
      if (state.gameModel.isKilled) {
        state.gameModel.isKilled = false;
        this.add(GamePlayerChangedEvent(state.gameModel.player));
        return;
      }
      this.add(GamePlayerChangedEvent(getNextPlayerIndex()));
    }
  }

  void _considerForDhayam(int number) {
    if ((number == 1 || number == 5) &&
        state.gameModel.player.isStarted &&
        state.gameModel.player.availableCoins > 0) {
      this.add(DhayamEvent(number));
    }
  }

  void _considerToChoose(int number) {
    if (state.gameModel.player.isStarted &&
        state.gameModel.currentNumbers.length == 1 &&
        !gameRepository.bigIndices.contains(number)) {
      var tilesToUpdate = tiles
          .where((element) =>
              element.players.contains(state.gameModel.player.colorIndex))
          .toList();

      this.add(
          NumberChoosedEvent(state.gameModel.player, number, tilesToUpdate));
      return;
    }
  }

  void _considerForDhayams(GameNumberAddedEvent addedEvent) {
    if (gameRepository.bigIndices.contains(addedEvent.number)) {
      return;
    }

    if (!_canContinueGame()) {
      this.add(GamePlayerChangedEvent(getNextPlayerIndex()));
      return;
    }

    var dhayams = state.gameModel.currentNumbers
        .where((element) =>
            element.currentNumber == 1 || element.currentNumber == 5)
        .toList();

    if (dhayams.length == 0) {
      return;
    }
    Comparator<CurrentNumber> numberComparator =
        (prev, curr) => prev.currentNumber.compareTo(curr.currentNumber);
    dhayams.sort(numberComparator);
    var dhayamToPlay = dhayams.take(state.gameModel.player.availableCoins);
    dhayamToPlay.toList().forEach((element) {
      _considerForDhayam(element.currentNumber);
      _considerToChoose(element.currentNumber);
    });
  }

  _fruitRippened(FruitEvent fruitEvent) {
    fruitEvent.player.fruitCoins = fruitEvent.player.fruitCoins ??= 0;
    fruitEvent.player.fruitCoins = fruitEvent.player.fruitCoins + 1;
    if (gameRepository.numberOfCoins == fruitEvent.player.fruitCoins) {
      this.gameRepository.winners.add(fruitEvent.player.colorIndex);
      if ((gameRepository.numberOfPlayers - 1) ==
          gameRepository.winners.length) {
        return GameOver(state.gameModel);
      }
    }
    return CoinRippened(state.gameModel, state.gameModel.player);
  }
}

class NumberMoved {
  CurrentNumber currentNumber;
  bool isMoved;
  NumberMoved(this.currentNumber, this.isMoved);
}
