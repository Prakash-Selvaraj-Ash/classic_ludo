import 'package:flutter/material.dart';
import 'package:ludo/bloc/game_bloc_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../tile.dart';

class NumberChoosedUi extends StatelessWidget {
  final NumberChoosed state;
  final int index;
  const NumberChoosedUi(this.state, this.index);

  @override
  Widget build(BuildContext context) {
    var tile = context
        .bloc<GameBlocBloc>()
        .tiles
        .firstWhere((element) => element.index == index);
    return GestureDetector(
        onTap: () {
          context.bloc<GameBlocBloc>().add(TileUpdateRequestEvent(
              state.gameModel.player,
              state.gameModel.selectedNumber,
              tile.index));
        },
        child: Tile(tile));
  }
}
