import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ludo/bloc/game_bloc_bloc.dart';
import 'package:ludo/UI/Game/dice_face.dart';
import 'package:ludo/model/UI/colorindex.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class Dice extends StatefulWidget {
  @override
  _DiceState createState() => _DiceState();
}

class _DiceState extends State<Dice> {
  StreamController<int> dice1Controller = StreamController<int>();
  StreamController<int> dice2Controller = StreamController<int>();
  ColorIndex _colorIndex = new ColorIndex();
  List<int> _bigIndices = [1, 5, 6, 0, 12];
  Random random = Random();

  int dice1Value = 0;
  int dice2Value = 0;

  int iterationCount = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBlocBloc, GameBlocState>(
        buildWhen: (previous, current) {
      return (current.gameModel.currentNumbers.length == 0) ||
          (previous.gameModel.player.colorIndex !=
              current.gameModel.player.colorIndex) ||
          current.gameModel.currentNumbers
              .any((e) => !_bigIndices.contains(e.currentNumber)) ||
          (current.gameModel.currentNumbers
              .map((e) => e.isSelected)
              .toSet()
              .contains(true));
    }, builder: (context, state) {
      var color = _colorIndex.getColor(state.gameModel.player.colorIndex);
      return Container(
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: color),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Row(
                children: [
                  StreamBuilder<int>(
                      stream: dice1Controller.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          dice1Value = snapshot.data;
                          return DiceFace(dice1Value, color);
                        } else {
                          return DiceFace(0, color);
                        }
                      }),
                  StreamBuilder<int>(
                      stream: dice2Controller.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          dice2Value = snapshot.data;
                          return DiceFace(dice2Value, color);
                        } else {
                          return DiceFace(0, color);
                        }
                      })
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: IconButton(
                icon: Icon(Icons.all_inclusive),
                onPressed: state.gameModel.currentNumbers.any(
                        (number) => !_bigIndices.contains(number.currentNumber))
                    ? null
                    : () {
                        iterationCount = 0;
                        Timer.periodic(Duration(milliseconds: 40), (timer) {
                          int dice1 = random.nextInt(4);
                          int dice2 = random.nextInt(4);
                          dice1Controller.sink.add(dice1);
                          dice2Controller.sink.add(dice2);

                          iterationCount++;
                          if (iterationCount > 5) {
                            int total = dice1 + dice2;
                            context.bloc<GameBlocBloc>().add(
                                new GameNumberAddedEvent(
                                    total == 0 ? 12 : total));
                            timer.cancel();
                          }
                        });
                      },
              ),
            ),
            Container(
              child: Wrap(
                children: [
                  ...Iterable.generate(7).map((index) {
                    var text = index == 0 ? 12 : index;
                    return GestureDetector(
                      onTap: () {
                        context
                            .bloc<GameBlocBloc>()
                            .add(new GameNumberAddedEvent(text));
                      },
                      child: Container(
                        margin: EdgeInsets.all(3),
                        padding: EdgeInsets.all(5),
                        color: color,
                        alignment: Alignment.center,
                        child: Text(text.toString()),
                      ),
                    );
                  })
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    dice1Controller.close();
    dice2Controller.close();
  }
}
