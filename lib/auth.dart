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
    Map<String, dynamic> parsed = json.decode(theJson);
    var languagelist = List.generate(
        parsed["settings"]["count_langs"],
        (index) => DropdownMenuItem<String>(
              value: parsed["settings"]["langs"][index],
              child: Text(parsed["settings"]["langs"][index]),
            ));
    String currentLang = languagelist[0].value!;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/bg.jpeg"),
        )),
        child: Center(
            child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "TechnoGym",
                style: TextStyle(
                  fontSize: 48,
                ),
              ),
            ),
            Container(
                width: 380,
                height: 550,
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
                                parsed["fields"]
                                        [parsed["settings"]["count_fields"] - 1]
                                    ["field_title"],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(parsed["fields"]
                                      [parsed["settings"]["count_fields"] - 1]
                                  ["description"]),
                            ],
                          ),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: parsed["settings"]["count_fields"] - 1,
                            itemBuilder: (context, index) {
                              return AuthForm(
                                type: parsed["fields"][index]["field_type"],
                                title: parsed["fields"][index]["field_title"],
                                description: parsed["fields"][index]
                                    ["description"],
                              );
                            }),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
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
                          ),
                        ),
                      ],
                    ))),
          ],
        )),
      ),
    );
  }
}
