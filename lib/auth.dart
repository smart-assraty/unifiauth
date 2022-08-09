import 'package:flutter/material.dart';
import 'admin.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  static String routeName = "/auth";

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
        body: Column(
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
        ));
  }
}

List<String> getFormArguments() {
  List<String> args = [];
  for (int i = 0; i < forms.length; i++) {
    args.add((forms[i] as CustomTextFormField).controller.text);
  }
  return args;
}
