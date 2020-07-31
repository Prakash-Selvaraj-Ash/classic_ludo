import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ludo/bloc/game_bloc_bloc.dart';
import 'package:ludo/game_repository.dart';
import 'package:ludo/model/UI/colorindex.dart';
import 'package:ludo/model/root.dart';

import '../../board.dart';
import 'current_status.dart';
import 'grid_board.dart';
import 'dice.dart';

class Game extends StatelessWidget {
  final Root data;
  final ColorIndex _colorIndex = ColorIndex();
  Game({@required this.data});

  @override
  Widget build(BuildContext context) {
    var repository = GameRepository(data.noOfPlayers, data.noOfCoins);

    return BlocProvider(
      create: (context) => GameBlocBloc(repository),
      child: Scaffold(
        body: Container(
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(
              flex: 2,
              child: Column(children: [
                Expanded(
                  child: GridBoard(runtimeType: runtimeType),
                  //Board(),
                ),
                Builder(builder: (context) {
                  return CurrentStatus(
                      colorIndex: _colorIndex,
                      tiles: context.bloc<GameBlocBloc>().tiles);
                })
              ]),
            ),
            Dice(),
          ]),
        ),
      ),
    );
  }
}
