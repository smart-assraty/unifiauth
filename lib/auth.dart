import 'package:flutter/material.dart';
import 'admin.dart';
import 'unifi.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  Unifi unifi = Unifi();
  @override
  Widget build(BuildContext context) {
    //For web zaebal
    //String? query = Uri.base.queryParameters["id"];
    String query = "dc:72:9b:4b:9e:72";
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
                  onPressed: () async {
                    late String text;
                    text = await unifi.authorize(query);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Card(
                            child: Text(text),
                          );
                        });
                    //For web zaebal
                    /*(query != null)
                        ? {
                            text = await unifi.authorize(query),
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Card(
                                    child: Text(text),
                                  );
                                })
                          }
                        : showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const Card(
                                child: Text("No query data"),
                              );
                            });*/
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
