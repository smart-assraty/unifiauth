import 'package:flutter/material.dart';
import 'unifi.dart';
import 'dart:io';

void main() {
  HttpOverrides.global = DevHttpOverrides();
  runApp(const Auth());
}

class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthPage(),
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  var controller = Unifi();
  String result = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("TechoGym Guest"),
        ),
        body: Center(
          child: FutureBuilder(
            future: controller.getClients(),
            builder: (context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, i) {
                      return Column(
                        children: [
                          Text(snapshot.data![i]),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    });
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
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
