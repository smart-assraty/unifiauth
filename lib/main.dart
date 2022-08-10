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
  runApp(MaterialApp.router(
    routerDelegate: RoutemasterDelegate(routesBuilder: (_) => routes),
    routeInformationParser: const RoutemasterParser(),
  ));
}

final routes = RouteMap(routes: {
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
            onPressed: () => Routemaster.of(context).push("/guest/s/default"),
            child: const Text("Auth")),
        ElevatedButton(
            onPressed: () => Routemaster.of(context).push("/admin"),
            child: const Text("Connection")),
        ElevatedButton(
            onPressed: () => Routemaster.of(context).push("/connection"),
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
