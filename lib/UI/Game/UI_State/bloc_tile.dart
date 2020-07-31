import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/game_bloc_bloc.dart';
import '../tile.dart';

import 'number_choosed.dart';
import 'tile_updated.dart';
import 'dhayam.dart';

class BlocTile extends StatelessWidget {
  final int index;
  const BlocTile(this.index);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBlocBloc, GameBlocState>(
      buildWhen: (oldState, newState) {
        if (newState is Dhayam) {
          bool canBuild =
              newState != null && newState.gameModel.player.startIndex == index;

          return canBuild;
        }

        if (newState is NumberChoosed) {
          bool canBuild =
              newState.tileModels.map((e) => e.index).contains(index);
          return canBuild;
        }

        if (newState is TileUpdated) {
          bool canBuild =
              newState.tileModelsToUpdate.map((e) => e.index).contains(index);
          return canBuild;
        }
        return false;
      },
      builder: (ctx, state) {
        var type = state.runtimeType;
        switch (type) {
          case Dhayam:
            return DhayamUi(state as Dhayam);
          case NumberChoosed:
            return NumberChoosedUi(state as NumberChoosed, index);
          case TileUpdated:
            return TileUpdatedUi(state as TileUpdated, index);
        }

        return Tile(context.bloc<GameBlocBloc>().tiles.elementAt(index));
      },
    );
  }
}
