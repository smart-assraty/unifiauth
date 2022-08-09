import 'package:flutter/material.dart';
import 'connection.dart';
import 'dart:io';
import 'admin.dart';
import 'auth.dart';

void main() {
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

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, "/auth"),
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
