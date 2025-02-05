

import 'package:flutter/material.dart';

import '../views/MainMenu Screen/MainMenu.dart';
import '../views/splash Screen/SplashScreen.dart';

class Router {
  static MaterialPageRoute onRouteGenerator(settings) {
    switch (settings.name) {

      case MenuScreen.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>  MenuScreen(),
        );


      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const Material(
            child: Center(
              child: Text("404 page not founded"),
            ),
          ),
        );
    }
  }
}
