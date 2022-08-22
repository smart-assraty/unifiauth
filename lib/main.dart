import 'package:url_strategy/url_strategy.dart' show setPathUrlStrategy;
import 'package:routemaster/routemaster.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'admin.dart';
import 'auth.dart';

int i = 0;
/*String currentLogo = "";
String currentBG = "";*/
String server = "http://185.125.88.30";
String currentLang = "rus";
List<String> languagelist = ["rus", "eng", "kaz"];
List<DropdownMenuItem<String>> languages = [
  const DropdownMenuItem(value: "rus", child: Text("rus")),
  const DropdownMenuItem(value: "eng", child: Text("eng")),
  const DropdownMenuItem(value: "kaz", child: Text("kaz")),
  const DropdownMenuItem(value: "ita", child: Text("ita")),
  const DropdownMenuItem(value: "tur", child: Text("tur")),
  const DropdownMenuItem(value: "uzb", child: Text("uzb")),
];

void main() {
  setPathUrlStrategy();
  HttpOverrides.global = DevHttpOverrides();

  runApp(MaterialApp.router(
    routerDelegate: RoutemasterDelegate(routesBuilder: (_) => routes),
    routeInformationParser: const RoutemasterParser(),
  ));
}

final routes = RouteMap(routes: {
  "/": (_) => const MaterialPage(child: AdminPage()),
  "/guest/s/default": (_) => const MaterialPage(child: AuthPage()),
  "/admin": (_) => const MaterialPage(child: AdminPage()),
  "/logged": (_) => const MaterialPage(
          child: Center(
        child: Text("Logged"),
      )),
});

class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
