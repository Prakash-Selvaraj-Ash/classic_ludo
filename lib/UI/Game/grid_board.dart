import 'package:flutter/material.dart';

import 'UI_State/bloc_tile.dart';

class GridBoard extends StatelessWidget {
  const GridBoard({
    Key key,
    @required this.runtimeType,
  }) : super(key: key);

  final Type runtimeType;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return Container(
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: (itemWidth / itemHeight),
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
        ),
        itemCount: 49,
        itemBuilder: (context, index) {
          return BlocTile(index);
        },
      ),
    );
  }
}
