import 'package:flutter/material.dart';
import 'package:ludo/model/root.dart';

enum NumberPlayerEnum { Two, Four }
enum NumberCoinsEnum { Four, Six }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NumberPlayerEnum _noOfPlayersEnum = NumberPlayerEnum.Two;
  NumberCoinsEnum _coinsEnum = NumberCoinsEnum.Six;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(alignment: Alignment.center, child: Text('No of Players')),
          ListTile(
            title: const Text('Two'),
            leading: Radio(
              value: NumberPlayerEnum.Two,
              groupValue: _noOfPlayersEnum,
              onChanged: (NumberPlayerEnum value) {
                setState(() {
                  _noOfPlayersEnum = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Four'),
            leading: Radio(
              value: NumberPlayerEnum.Four,
              groupValue: _noOfPlayersEnum,
              onChanged: (NumberPlayerEnum value) {
                setState(() {
                  _noOfPlayersEnum = value;
                });
              },
            ),
          ),
          Container(alignment: Alignment.center, child: Text('No of Coins')),
          ListTile(
            title: const Text('Four'),
            leading: Radio(
              value: NumberCoinsEnum.Four,
              groupValue: _coinsEnum,
              onChanged: (NumberCoinsEnum value) {
                setState(() {
                  _coinsEnum = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Six'),
            leading: Radio(
              value: NumberCoinsEnum.Six,
              groupValue: _coinsEnum,
              onChanged: (NumberCoinsEnum value) {
                setState(() {
                  _coinsEnum = value;
                });
              },
            ),
          ),
          RaisedButton(
            child: Text('Start Game'),
            onPressed: () => Navigator.of(context).pushNamed(
              '/game',
              arguments: Root(_noOfPlayersEnum == NumberPlayerEnum.Two ? 2 : 4,
                  _coinsEnum == NumberCoinsEnum.Four ? 4 : 6),
            ),
          )
        ],
      ),
    );
  }
}
