import 'package:url_strategy/url_strategy.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'admin.dart';
import 'auth.dart';
import 'connection.dart';

void main() {
  setPathUrlStrategy();
  HttpOverrides.global = DevHttpOverrides();
  runApp(MaterialApp(
    title: "UnifiAuth",
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    routes: {
      Connection.routeName: (context) => const Connection(),
      AuthPage.routeName: (context) => const AuthPage(),
      AdminPage.routeName: (context) => const AdminPage(),
    },
    home: const Main(),
  ));
}

final router = RouteMap(routes: {
  "/": (_) => const MaterialPage(child: Main()),
  "/guest/s/default": (_) => const MaterialPage(child: AuthPage()),
  "/admin": (_) => const MaterialPage(child: AdminPage()),
  "/connection": (_) => const MaterialPage(child: Connection()),
});

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, "/guest/s/default"),
            child: const Text("Auth")),
        ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, "/connection"),
            child: const Text("Connection")),
        ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, "/admin"),
            child: const Text("Admin")),
      ],
    ));
  }
}

class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
