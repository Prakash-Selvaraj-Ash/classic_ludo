import 'package:ludo/model/player.dart';

class GameRepository {
  final int numberOfPlayers;
  final int numberOfCoins;
  final List<int> colorIndices = new List<int>();
  final List<int> mountainIndexCollection = new List<int>();
  final Map<int, List<int>> playerRouteIndices = new Map<int, List<int>>();
  final List<Player> players = new List<Player>();
  final List<int> bigIndices = [1, 5, 6, 0, 12];
  final List<int> winners = [];

  GameRepository(this.numberOfPlayers, this.numberOfCoins) {
    colorIndices.addAll(Iterable.generate(numberOfPlayers));
    playerRouteIndices.addAll({
      0: _getNorthRoutes(),
      1: _getWestRoutes(),
      2: _getSouthRoutes(),
      3: _getEastRoutes()
    });
    decidePlayers();

    mountainIndexCollection.addAll([3, 8, 12, 21, 27, 36, 40, 45, 24]);
  }
  List<int> _getWestRoutes() {
    return [
      21,
      28,
      35,
      42,
      43,
      44,
      45,
      46,
      47,
      48,
      41,
      34,
      27,
      20,
      13,
      6,
      5,
      4,
      3,
      2,
      1,
      0,
      7,
      14,
      8,
      9,
      10,
      11,
      12,
      19,
      26,
      33,
      40,
      39,
      38,
      37,
      36,
      29,
      22,
      15,
      16,
      17,
      18,
      25,
      32,
      31,
      30,
      23,
      24
    ];
  }

  List<int> _getEastRoutes() {
    return [
      27,
      20,
      13,
      6,
      5,
      4,
      3,
      2,
      1,
      0,
      7,
      14,
      21,
      28,
      35,
      42,
      43,
      44,
      45,
      46,
      47,
      48,
      41,
      34,
      40,
      39,
      38,
      37,
      36,
      29,
      22,
      15,
      8,
      9,
      10,
      11,
      12,
      19,
      26,
      33,
      32,
      31,
      30,
      23,
      16,
      17,
      18,
      25,
      24
    ];
  }

  List<int> _getNorthRoutes() {
    return [
      3,
      2,
      1,
      0,
      7,
      14,
      21,
      28,
      35,
      42,
      43,
      44,
      45,
      46,
      47,
      48,
      41,
      34,
      27,
      20,
      13,
      6,
      5,
      4,
      12,
      19,
      26,
      33,
      40,
      39,
      38,
      37,
      36,
      29,
      22,
      15,
      8,
      9,
      10,
      11,
      18,
      25,
      32,
      31,
      30,
      23,
      16,
      17,
      24
    ];
  }

  List<int> _getSouthRoutes() {
    return [
      45,
      46,
      47,
      48,
      41,
      34,
      27,
      20,
      13,
      6,
      5,
      4,
      3,
      2,
      1,
      0,
      7,
      14,
      21,
      28,
      35,
      42,
      43,
      44,
      36,
      29,
      22,
      15,
      8,
      9,
      10,
      11,
      12,
      19,
      26,
      33,
      40,
      39,
      38,
      37,
      30,
      23,
      16,
      17,
      18,
      25,
      32,
      31,
      24
    ];
  }

  void decidePlayers() {
    var indices = Iterable.generate(numberOfPlayers);
    if (numberOfPlayers == 2) {
      players.addAll(indices
          .map((index) => Player(
              startIndex: index == 0 ? 3 : 45,
              availableCoins: numberOfCoins,
              colorIndex: index,
              routes: index == 0 ? _getNorthRoutes() : _getSouthRoutes()))
          .toList());
      return;
    }

    players.addAll(indices
        .map((index) => Player(
            startIndex: getStartIndex(index),
            colorIndex: index,
            availableCoins: numberOfCoins,
            routes: playerRouteIndices[index]))
        .toList());
  }

  List<int> getOuterIndex() {
    var generated = Iterable.generate(7, (item) => item);
    return [
      ...generated,
      ...generated.map((e) => e * 7),
      ...generated.map((e) => e + 42),
      ...generated.map((e) => (e * 7) + 6)
    ].toSet().toList();
  }

  int getStartIndex(int index) {
    switch (index) {
      case 0:
        return 3;
      case 1:
        return 21;
      case 2:
        return 45;
      case 3:
        return 27;
      default:
        return 3;
    }
  }

  Player getPlayer(int index) {
    return players.elementAt(index);
  }
}
