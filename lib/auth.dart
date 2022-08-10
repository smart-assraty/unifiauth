import 'package:flutter/material.dart';
import 'admin.dart';
import 'dart:io';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    var query = Uri.base.queryParameters["id"];
    return Scaffold(
      appBar: AppBar(
        title: const Text("TechoGym Guest"),
      ),
      body: (query != null) ? Text(query) : const Text("Not Found"),
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
                    RouteMaster.of(context).push("/connection");
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
  final server = await HttpServer.bind(InternetAddress.anyIPv4, 43617);
  Map<String, String> requestParameters = {"qwer": "ty"};
  await for (HttpRequest request in server) {
    requestParameters = request.uri.queryParameters;
  }
  return requestParameters;
}
