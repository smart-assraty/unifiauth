import 'package:url_strategy/url_strategy.dart' show setPathUrlStrategy;
import 'package:routemaster/routemaster.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; //TEST

import 'admin.dart';
import 'auth.dart';

// TEST
String theJson = json.encode({
  "settings": {
    "login": "string",
    "langs": ["rus"],
    "count_langs": 1,
    "count_fields": 2,
    "api_url": "string",
  },
  "fields": [
    {
      "type": "textfield",
      "api_name": "string",
      "title": [
        {
          "lang": "rus",
          "text": "string",
        },
      ],
      "description": [
        {
          "lang": "rus",
          "text": "string",
        },
      ],
      "brand_icon": null,
    },
    {
      "type": "front",
      "api_name": "string",
      "title": [
        {
          "lang": "rus",
          "text": "string",
        },
      ],
      "description": [
        {
          "lang": "rus",
          "text": "string",
        },
      ],
      "brand_icon": null,
    },
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
