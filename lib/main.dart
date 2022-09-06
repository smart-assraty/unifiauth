import 'package:url_strategy/url_strategy.dart' show setPathUrlStrategy;
import 'package:routemaster/routemaster.dart';
import 'package:flutter/material.dart';

import 'admin.dart';
import 'auth.dart';

String server = "https://185.125.88.30"; // To Config file

void main() {
  setPathUrlStrategy();
  runApp(MaterialApp.router(
    routerDelegate: RoutemasterDelegate(routesBuilder: (_) => routes),
    routeInformationParser: const RoutemasterParser(),
  ));
}

final routes = RouteMap(routes: {
  "/": (_) => const MaterialPage(child: AdminPage()),
  "/guest/s/default": (_) => const MaterialPage(child: AuthPage()),
  "/logged": (_) => MaterialPage(
          child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage("$server/img/imageBG.jpg"),
                  fit: BoxFit.fill)),
          child: const Center(
              child: Text("Welcome! Please wait until you are authorized.",
                  style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white))),
        ),
      ))
});
