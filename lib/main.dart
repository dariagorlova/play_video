import 'package:flutter/material.dart';
import 'package:play_video/navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationActions.navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: NavigationImpl().initialRoute,
      routes: NavigationImpl().routes,
      onGenerateRoute: NavigationImpl().onGenerateRoute,
    );
  }
}
