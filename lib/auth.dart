import 'package:flutter/material.dart';
import 'admin.dart';
import 'dart:io';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  static String routeName = "/guest/s/default";

  @override
  State<AuthPage> createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("TechoGym Guest"),
        ),
        body: FutureBuilder(
          future: listen(),
          builder: (context, AsyncSnapshot<Map<String, String>> snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(itemBuilder: (context, index) {
                return Text(snapshot.data!.entries.elementAt(index).toString());
              });
            } else {
              return const CircularProgressIndicator();
            }
          },
        )

        /*Column(
          children: [
            ListView(
              shrinkWrap: true,
              children: forms,
            ),
            SizedBox(
              height: 50,
              width: double.maxFinite,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/connection");
                  },
                  child: const Text("Submit")),
            ),
          ],
        )*/
        );
  }
}

List<String> getFormArguments() {
  List<String> args = [];
  for (int i = 0; i < forms.length; i++) {
    args.add((forms[i] as CustomTextFormField).controller.text);
  }
  return args;
}

Future<Map<String, String>> listen() async {
  final server = await HttpServer.bind(InternetAddress.anyIPv4, 80);
  Map<String, String> requestParameters = {};
  await for (HttpRequest request in server) {
    requestParameters = request.uri.queryParameters;
  }
  return requestParameters;
}
