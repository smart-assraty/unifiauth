import 'package:url_strategy/url_strategy.dart' show setPathUrlStrategy;
import 'package:routemaster/routemaster.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; //TEST

import 'admin.dart';
import 'auth.dart';

// TEST
String theJson = json.encode({
  "langs": ["rus", "eng", "kaz"],
  "count_langs": 3,
  "count_fields": 9,
  "fields": [
    {
      "type": "textfield",
      "title": "Name",
      "description": "Write your name",
    },
    {
      "type": "email",
      "title": "Email",
    },
    {
      "type": "email",
      "title": "Email",
    },
    {
      "type": "number",
      "title": "number",
    },
    {
      "type": "number",
      "title": "number",
    },
    {
      "type": "number",
      "title": "number",
    },
    {
      "type": "checkbox",
      "title": "confirm",
    },
    {
      "type": "brand",
      "title": "theHub.su",
    },
    {
      "type": "front",
      "title": "Welcome!",
      "description": "Please register",
    }
  ],
  "bg_img":
      "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.technogym.com%2Fwpress%2Fwp-content%2Fuploads%2F2019%2F07%2Fog_img_fb.jpg&f=1&nofb=1",
  "logo_img":
      "https://thehubstmarys.co.uk/wp-content/uploads/2019/08/STM-LetterSize.png",
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
