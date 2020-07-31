import 'package:flutter/material.dart';
import 'package:ludo/bloc/game_bloc_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../tile.dart';

class DhayamUi extends StatelessWidget {
  final Dhayam state;
  const DhayamUi(this.state);

  @override
  Widget build(BuildContext context) {
    var tile = context.bloc<GameBlocBloc>().tiles.firstWhere(
        (element) => element.index == state.gameModel.player.startIndex);
    return Tile(tile);
  }
}
