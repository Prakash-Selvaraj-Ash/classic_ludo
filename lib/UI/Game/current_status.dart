import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ludo/bloc/game_bloc_bloc.dart';
import 'package:ludo/model/UI/colorindex.dart';
import 'package:ludo/model/tile.dart';

class CurrentStatus extends StatelessWidget {
  const CurrentStatus({
    Key key,
    @required ColorIndex colorIndex,
    @required this.tiles,
  })  : _colorIndex = colorIndex,
        super(key: key);

  final ColorIndex _colorIndex;
  final List<TileModel> tiles;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBlocBloc, GameBlocState>(
      builder: (ctx, state) => Column(
        children: [
          RichText(
            text: TextSpan(children: [
              TextSpan(text: 'Current Player: Player'),
              TextSpan(
                  text: _colorIndex.getName(state.gameModel.player.colorIndex),
                  style: TextStyle(
                      color: _colorIndex
                          .getColor(state.gameModel.player.colorIndex))),
              TextSpan(
                  text:
                      'available coins ${state.gameModel.player.availableCoins}')
            ]),
          ),
          Wrap(
            alignment: WrapAlignment.start,
            direction: Axis.horizontal,
            children: [
              ...(state.gameModel.currentNumbers.map(
                (i) => GestureDetector(
                    onTap: () {
                      if (state.gameModel.selectedNumber != null &&
                          state.gameModel.selectedNumber != 100) {
                        return;
                      }
                      var tilesToUpdate = tiles
                          .where((element) => element.players
                              .contains(state.gameModel.player.colorIndex))
                          .toList();
                      ctx.bloc<GameBlocBloc>().add(NumberChoosedEvent(
                          state.gameModel.player,
                          i.currentNumber,
                          tilesToUpdate));
                    },
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Container(
                          padding: EdgeInsets.all(10),
                          color: i.isSelected
                              ? Colors.grey
                              : _colorIndex
                                  .getColor(state.gameModel.player.colorIndex),
                          child: Text(
                            '${i.currentNumber.toString()}',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    )),
              ))
            ],
          )
        ],
      ),
    );
  }
}
