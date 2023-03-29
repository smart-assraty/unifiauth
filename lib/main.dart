import 'package:flutter/services.dart';
import 'package:url_strategy/url_strategy.dart' show setPathUrlStrategy;
import 'package:url_launcher/url_launcher.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'dart:ui' as ui;

import 'dart:html';
import 'dart:convert';

import 'admin.dart';
import 'auth.dart';
import 'server_connector.dart';

String uvicorn = "";
String server = "";
String? selectedBrandUrl;
late String? baseQuery;

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
    useInheritedMediaQuery: true,
    routerDelegate: RoutemasterDelegate(routesBuilder: (_) => routes),
    routeInformationParser: const RoutemasterParser(),
    theme: ThemeData(fontFamily: "Arial"),
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
              future: canLaunchUrl(Uri.parse("https://www.technogym.kz/")),
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
                              color: Colors.white)));
                }
              },
            )),
      ))
});

class Opener extends StatefulWidget {
  const Opener({super.key});

  @override
  State<Opener> createState() => OpenerState();
}

class OpenerState extends State<Opener> {
  Future<void> _launchUrl() async {
    if (!await launchUrl(
        Uri.parse(selectedBrandUrl ?? "https://www.technogym.kz/"),
        mode: LaunchMode.inAppWebView)) {
      throw Exception(
          'Could not launch ${selectedBrandUrl ?? "https://www.technogym.kz/"}');
    }

    window.close();
  }

  @override
  void initState() {
    super.initState();

    // _launchUrl();

    window.onPageHide.listen((event) {
      debugPrint("HIDE!!!");
      launchUrl(Uri.parse(selectedBrandUrl ?? "http://ws-group.kz/"));
      AuthHelper.connecting();
    });

    window.onBeforeUnload.listen((event) {
      debugPrint("CLOSE!!!");
      launchUrl(Uri.parse(selectedBrandUrl ?? "http://ws-group.kz/"));
      AuthHelper.connecting();
    });
  }

  @override
  Widget build(BuildContext context) {
    final IFrameElement _iframeElement = IFrameElement();
    return Container(
      child: IframeView(source: selectedBrandUrl ?? "https://instagram.com/"),
    );
  }
}

class IframeView extends StatefulWidget {
  final String source;

  const IframeView({Key? key, required this.source}) : super(key: key);

  @override
  _IframeViewState createState() => _IframeViewState();
}

class _IframeViewState extends State<IframeView> {
  // Widget _iframeWidget;
  final IFrameElement _iframeElement = IFrameElement();

  @override
  void initState() {
    super.initState();
    _iframeElement.src = widget.source;
    _iframeElement.style.border = 'none';

    //ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
      (int viewId) => _iframeElement,
    );
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(
      key: UniqueKey(),
      viewType: 'iframeElement',
    );
  }
}
