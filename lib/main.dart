import 'package:flutter/services.dart';
import 'package:url_strategy/url_strategy.dart' show setPathUrlStrategy;
import 'package:url_launcher/url_launcher.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter/material.dart';

import 'dart:html';
import 'dart:convert';

import 'admin.dart';
import 'auth.dart';

String uvicorn = "";
String server = "";
String? selectedBrandUrl;

ButtonStyle buttonStyle = ButtonStyle(
    fixedSize: MaterialStateProperty.all<Size>(const Size(150, 20)),
    backgroundColor: MaterialStateProperty.all<Color>(
        const Color.fromARGB(255, 251, 225, 30)));
const TextStyle buttonText = TextStyle(color: Colors.black);
const TextStyle textStyleBig = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  fontFamily: "Arial",
);
const TextStyle textStyleLittle = TextStyle(
  fontSize: 16,
  fontFamily: "Arial",
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    server =
        json.decode(await rootBundle.loadString("assets/config.json"))["url"];
    uvicorn = "$server:8000";
  } catch (e) {
    debugPrint("$e");
  }

  setPathUrlStrategy();
  runApp(MaterialApp.router(
    // useInheritedMediaQuery: true,
    routerDelegate: RoutemasterDelegate(routesBuilder: (_) => routes),
    routeInformationParser: const RoutemasterParser(),
    theme: ThemeData(
        fontFamily: "Roboto",
        fontFamilyFallback: const ['Roboto'],
        useMaterial3: false),
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
            child: FutureBuilder(
              future: canLaunchUrl(
                  Uri.parse(selectedBrandUrl ?? "https://www.technogym.kz/")),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return const Opener();
                } else {
                  return const Center(
                    child: Text(
                      "Welcome! Please wait until you are authorized.",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      )
});

class Opener extends StatefulWidget {
  const Opener({super.key});

  @override
  State<Opener> createState() => OpenerState();
}

class OpenerState extends State<Opener> {
  @override
  void initState() {
    super.initState();
    window.open(selectedBrandUrl ?? "https://www.technogym.kz/", "_self");
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
