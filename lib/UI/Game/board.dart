import 'package:flutter/material.dart';
import 'package:ludo/UI/Game/UI_State/bloc_tile.dart';
import 'package:ludo/bloc/game_bloc_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Board extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var tiles = context.bloc<GameBlocBloc>().tiles.map((tile) => tile);
    return Container(
      color: Colors.grey,
      child: Wrap(
        direction: Axis.horizontal,
        children: [
          ...tiles.map((tile) {
            var index = tile.index;
            return BlocTile(index);
          }).toList()
        ],
      ),
    );
  }
}
