import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth_forms.dart';
import 'main.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

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
          FutureBuilder(
            future: getLines(),
            builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                List<DropdownMenuItem<String>> languagelist = [
                  const DropdownMenuItem(
                    value: "rus",
                    child: Text("rus"),
                  ),
                  const DropdownMenuItem(
                    value: "eng",
                    child: Text("eng"),
                  ),
                  const DropdownMenuItem(
                    value: "kaz",
                    child: Text("kaz"),
                  ),
                ];
                return Center(
                  child: Column(
                    children: [
                      DropdownButton<String>(
                          hint: Text(currentLang),
                          items: languagelist,
                          onChanged: (value) => setState(() {
                                currentLang = value!;
                              })),
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Colors.black,
                            width: 4,
                          )),
                          width: 250,
                          height: 650,
                          child: Column(
                            children: [
                              ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return AuthForm(
                                      type: snapshot.data!["type"],
                                      data: snapshot.data!);
                                },
                              ),
                            ],
                          )),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () async {
              await http.get(
                Uri.parse(
                    "http://192.168.1.103/connecting/connecting.php/?${Uri.base.query}"),
                headers: {
                  "Charset": "utf-8",
                },
              );
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  List<Widget> twoStrings(List<String> list) {
    List<Widget> widgets = [];
    for (int i = 0; i < list.length - 1; i++) {
      widgets.add(Container(
        color: Colors.grey,
        width: 50,
        child: Text(list.elementAt(i)),
      ));
    }
    return widgets;
  }
}

Future<Map<String, dynamic>> getLines() async {
  var response = await http
      .get(Uri.parse("http://192.168.43.87/admin/admin.php/?cmd=find"));
  return json.decode(response.body);
}
