import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  TextEditingController controllerType = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TechoGym Guest"),
      ),
      body: Column(
        children: [
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
