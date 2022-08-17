import 'package:url_strategy/url_strategy.dart' show setPathUrlStrategy;
import 'package:routemaster/routemaster.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'admin.dart';
import 'auth.dart';
import 'custom_text_form_field.dart';

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

class Main extends StatelessWidget {
  const Main({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        CustomForm(),
      ]),
    );
  }
}

Future<String> getMap() async {
  var response = await http.get(Uri.parse(
      "http://192.168.1.60/admin/admin.php/?cmd=find&fieldName=Name"));
  return response.body;
}

class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
