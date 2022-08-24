import 'package:url_strategy/url_strategy.dart' show setPathUrlStrategy;
import 'package:routemaster/routemaster.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; //TEST

import 'admin.dart';
import 'auth.dart';

// TEST
String theJson = json.encode({
  "login": "string",
  "settings": {
    "langs": ["rus"],
    "count_langs": 1,
    "logo_img": "string",
    "bg_img": "string",
    "count_fields": 4,
    "api_url": "string"
  },
  "fields": [
    {
      "number": 0,
      "field_type": "textfield",
      "api_name": "string",
      "field_title": "Name",
      "description": "Write your name",
    },
    {
      "number": 1,
      "field_type": "email",
      "api_name": "string",
      "field_title": "Email",
    },
    {
      "number": 2,
      "field_type": "number",
      "api_name": "string",
      "field_title": "Number",
    },
    {
      "number": 3,
      "field_type": "front",
      "api_name": "string",
      "field_title": "Welcome",
      "description": "How are ya?",
    }
  ]
});
// END TEST

String server = "http://185.125.88.30"; // To Config file

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
});
