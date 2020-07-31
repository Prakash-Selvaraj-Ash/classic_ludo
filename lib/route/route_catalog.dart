import 'package:flutter/material.dart';
import 'package:ludo/UI/Game/game.dart';
import 'package:ludo/UI/Home/home.dart';

class RouteCatalog {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/game':
        return MaterialPageRoute(builder: (_) => Game(data: arguments));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No Route Found'),
                  ),
                ));
    }
  }
}
