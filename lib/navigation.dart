import 'package:flutter/material.dart';
import 'package:play_video/screens/play_video_screen.dart';
import 'package:play_video/screens/select_screen.dart';

abstract class AppNavigation {
  String get initialRoute;
  Map<String, Widget Function(BuildContext context)> get routes;
  Route<Object> onGenerateRoute(RouteSettings settings);
}

abstract class NavigationRouteNames {
  static const mainScreen = '/';
  static const secondScreen = '/video';
  //...
}

class NavigationImpl implements AppNavigation {
  @override
  String get initialRoute => NavigationRouteNames.mainScreen;

  @override
  Map<String, Widget Function(BuildContext context)> get routes => {
        NavigationRouteNames.mainScreen: (context) => const SelectScreen(),
      };

  @override
  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case NavigationRouteNames.secondScreen:
        final args =
            settings.arguments is String ? settings.arguments as String : '';
        return MaterialPageRoute(
          builder: (context) => PlayVideoScreen(path: args),
        );

      default:
        const widget = Scaffold(body: Center(child: Text('Error')));
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}

class NavigationActions {
  static const instance = NavigationActions._();
  const NavigationActions._();
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // back to previous or close dialog
  void returnToPreviousPage() {
    navigatorKey.currentState?.pop();
  }

  void onSecondScreen() {
    navigatorKey.currentState?.pushNamed(NavigationRouteNames.secondScreen);
  }

  void pushVideoScreen(String path) {
    navigatorKey.currentState
        ?.pushNamed(NavigationRouteNames.secondScreen, arguments: path);
  }
}
