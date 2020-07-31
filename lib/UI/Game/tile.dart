import 'package:flutter/material.dart';
import 'package:ludo/model/UI/colorindex.dart';
import 'package:ludo/model/tile.dart';

class Tile extends StatelessWidget {
  final TileModel tileModel;
  final ColorIndex _colorIndex = ColorIndex();

  Tile(this.tileModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1),
          color: tileModel.index == 24
              ? Colors.red
              : (tileModel.isMountain ? Colors.brown : Colors.transparent)),
      alignment: Alignment.topLeft,
      child: Stack(
        children: [
          Text(tileModel.index.toString()),
          Flex(
            direction: Axis.horizontal,
            children: [
              ...tileModel.players.map(
                (player) => Flexible(
                  child: Center(
                    child: CircleAvatar(
                      maxRadius: 10,
                      backgroundColor: _colorIndex.getColor(player),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
