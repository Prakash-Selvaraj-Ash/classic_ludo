import 'package:flutter/material.dart';

class DiceFace extends StatelessWidget {
  final int diceValue;
  final Color color;
  DiceFace(this.diceValue, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
          color: color,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  ...Iterable.generate(3).map((e) => Padding(
                        padding: EdgeInsets.all(3),
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.transparent,
                        ),
                      ))
                ],
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ...Iterable.generate(diceValue).map((e) => Center(
                        child: Padding(
                            padding: EdgeInsets.all(3),
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 10,
                            ))))
                  ])
            ],
          )),
    );
  }
}
