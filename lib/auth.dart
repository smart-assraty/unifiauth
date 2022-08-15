import 'package:flutter/material.dart';
import 'admin.dart';
import 'unifi.dart';
import 'package:http/http.dart' as http;

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  TextEditingController controllerId = TextEditingController();
  TextEditingController controllerType = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  Unifi unifi = Unifi();
  @override
  Widget build(BuildContext context) {
    //For web zaebal
    //String? query = Uri.base.queryParameters["id"];

    //String query = "dc:72:9b:4b:9e:72";
    return Scaffold(
      appBar: AppBar(
        title: const Text("TechoGym Guest"),
      ),
      body: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("Form ID"),
          ),
          TextField(
            keyboardType: TextInputType.number,
            controller: controllerId,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("Form Type"),
          ),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: controllerType,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("Form Name"),
          ),
          TextFormField(
            keyboardType: TextInputType.name,
            controller: controllerName,
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () async {
              await http.get(
                Uri.parse(
                    "http://192.168.1.60/connecting/connecting.php/?${Uri.base.query}"),
                headers: {
                  "Charset": "utf-8",
                },
              );
            },
            child: const Text("Submit"),
          )
        ],
      ),
    );
  }
}

List<String> getFormArguments(List<Widget> forms) {
  List<String> args = [];
  for (int i = 0; i < forms.length; i++) {
    args.add((forms[i] as CustomTextFormField).controller.text);
  }
  return args;
}
