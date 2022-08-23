import 'package:flutter/material.dart';
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
    Map<String, dynamic> parsed = json.decode(response);
    var languagelist = List.generate(
        parsed["settings"]["count_langs"],
        (index) => DropdownMenuItem<String>(
              value: parsed["settings"]["langs"][index],
              child: Text(parsed["settings"]["langs"][index]),
            ));
    String currentLang = languagelist[0].value![0];

    return Scaffold(
        body: Column(
      children: [
        const Text(
          "TechnoGym",
          style: TextStyle(
            fontSize: 48,
          ),
        ),
        Container(
            width: 350,
            height: 600,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: DropdownButton(
                      items: languagelist,
                      onChanged: (value) => setState(() {
                            currentLang = value.toString();
                            //get json for language
                          })),
                ),
                Center(
                  child: Column(
                    children: [
                      Text(parsed["fields"]
                              [parsed["settings"]["count_fields"] - 1]
                          ["field_title"]),
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
                        description: parsed["fields"][index]["description"],
                      );
                    })
              ],
            )),
      ],
    ));
  }
}
