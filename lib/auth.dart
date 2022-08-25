import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'main.dart';
import 'auth_forms.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  List<Map<String, dynamic>> dataToApi = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: localTest(),
    );
  }

  Future<String> getForms() async {
    var response =
        await http.get(Uri.parse("http://185.125.88.30:8000/GetLoginForm/"));
    return response.body;
  }

  Widget localTest() {
    dynamic parsed = json.decode(theJson);
    var languagelist = List.generate(
        parsed["count_langs"],
        (index) => DropdownMenuItem<String>(
              value: parsed["langs"][index],
              child: Text(parsed["langs"][index]),
            ));
    String currentLang = languagelist[0].value!;
    List<AuthForm> forms = [];
    for (int index = 0; index < parsed["count_fields"] - 1; ++index) {
      forms.add(AuthForm.createForm(
        parsed["fields"][index]["type"],
        parsed["fields"][index]["title"],
        parsed["fields"][index]["description"],
      ));
    }
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: NetworkImage(parsed["bg_img"]),
      )),
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
              padding: const EdgeInsets.all(20),
              child: Image(
                image: NetworkImage(parsed["logo_img"]),
                height: 300,
                width: 300,
              )),
          Container(
              width: 400,
              height: 600,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.white),
              child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: DropdownButton(
                            hint: Text(
                              currentLang,
                            ),
                            items: languagelist,
                            onChanged: (value) => setState(() {
                                  currentLang = value.toString();
                                  //get json for language
                                })),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            Text(
                              parsed["fields"][parsed["count_fields"] - 1]
                                  ["title"],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(parsed["fields"][parsed["count_fields"] - 1]
                                ["description"]),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 420,
                        child: ListView(
                          children: forms,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () async {
                            /*await http.get(
                              Uri.parse(
                                  "$server/connecting/connecting.php/?${Uri.base.query}"),
                              headers: {
                                "Charset": "utf-8",
                              },
                            );*/
                            for (int i = 0; i < forms.length; i++) {
                              dataToApi.add(forms.elementAt(i).commit());
                            }
                            debugPrint(dataToApi.toString());
                            showDialog(
                                context: context,
                                builder: (context) {
                                  Map<String, dynamic> mapToServer = {
                                    "fields": dataToApi
                                  };
                                  return ListView.builder(
                                      itemCount: dataToApi.length - 1,
                                      itemBuilder: (context, index) {
                                        return Card(
                                          child: Text(
                                              "${mapToServer.entries.first.value[index]}"),
                                        );
                                      });
                                });
                            /*await http.post(
                              Uri.parse("$server/"),
                              headers: {
                                "Content-type": "application/json",
                              },
                              body: json.encode(dataToApi),
                            );*/
                          },
                          child: const Text("Submit"),
                        ),
                      ),
                    ],
                  ))),
        ],
      )),
    );
  }

  Widget serverTest() {
    return FutureBuilder(
      future: getForms(),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          dynamic parsed = json.decode(theJson);
          var languagelist = List.generate(
              parsed["count_langs"],
              (index) => DropdownMenuItem<String>(
                    value: parsed["langs"][index],
                    child: Text(parsed["langs"][index]),
                  ));
          String currentLang = languagelist[0].value!;
          List<AuthForm> forms = [];
          for (int index = 0; index < parsed["count_fields"] - 1; ++index) {
            forms.add(AuthForm.createForm(
              parsed["fields"][index]["type"],
              parsed["fields"][index]["title"],
              parsed["fields"][index]["description"],
            ));
          }
          return Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: NetworkImage(parsed["bg_img"]),
            )),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                    padding: const EdgeInsets.all(20),
                    child: Image(
                      image: NetworkImage(parsed["logo_img"]),
                      height: 300,
                      width: 300,
                    )),
                Container(
                    width: 400,
                    height: 600,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white),
                    child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: DropdownButton(
                                  hint: Text(
                                    currentLang,
                                  ),
                                  items: languagelist,
                                  onChanged: (value) => setState(() {
                                        currentLang = value.toString();
                                        //get json for language
                                      })),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Column(
                                children: [
                                  Text(
                                    parsed["fields"][parsed["count_fields"] - 1]
                                        ["title"],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(parsed["fields"]
                                          [parsed["count_fields"] - 1]
                                      ["description"]),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 420,
                              child: ListView(
                                children: forms,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await http.get(
                                    Uri.parse(
                                        "$server/connecting/connecting.php/?${Uri.base.query}"),
                                    headers: {
                                      "Charset": "utf-8",
                                    },
                                  );
                                  for (int i = 0; i < forms.length; ++i) {
                                    dataToApi.add(forms.elementAt(i).commit());
                                  }
                                  Map<String, dynamic> mapToServer = {
                                    "fields": dataToApi
                                  };
                                  await http.post(
                                    Uri.parse("$server/"),
                                    headers: {
                                      "Content-type": "application/json",
                                    },
                                    body: json.encode(mapToServer),
                                  );
                                },
                                child: const Text("Submit"),
                              ),
                            ),
                          ],
                        ))),
              ],
            )),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
