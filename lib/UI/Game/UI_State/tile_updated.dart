import 'package:flutter/material.dart';
import 'package:ludo/bloc/game_bloc_bloc.dart';
import '../tile.dart';

class TileUpdatedUi extends StatelessWidget {
  final TileUpdated state;
  final int index;

  const TileUpdatedUi(this.state, this.index);

  @override
  Widget build(BuildContext context) {
    var tile = state.tileModelsToUpdate
        .firstWhere((element) => element.index == index);
    return Tile(tile);
  }
}
