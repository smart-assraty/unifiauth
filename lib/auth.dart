import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'server_connector.dart' show AuthHelper;
import 'auth_form.dart';
import 'main.dart';

Locale language = ui.window.locale;

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  final authHelper = const AuthHelper();
  @override
  State<AuthPage> createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  List<DropdownMenuItem<String>> languagelist = [];
  String currentLang = "rus";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: widget.authHelper.getForms(currentLang),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
            dynamic body = snapshot.data!;
            languagelist = setLanguages(body);
            return Container(
              width: MediaQuery.of(context).size.width,
              height: double.maxFinite,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("$server/img/${body['bg_image']}"),
                  fit: BoxFit.fill)
                ),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.055,
                      alignment: Alignment.topCenter,
                      child: DropdownButton(
                        hint: Text(
                          currentLang,
                          style: const TextStyle(color: Colors.white),
                        ),
                        items: languagelist,
                        onChanged: (value) => setState(() {
                          currentLang = value.toString().split(" ")[1];
                        }),
                    ),
                  ),
                  AuthForm(
                        languagelist: languagelist,
                        currentLang: currentLang,
                        submit: body["submit_lang"],
                        logo: body["logo_image"],
                        data: body["fields"],
                        fieldsCount: body["count_fields"],
                      ),
                  
                      SizedBox(

                    height: MediaQuery.of(context).size.height * 0.055
                    ),
              ],)
              )
              )
                
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> setLanguages(dynamic body) {
    List<DropdownMenuItem<String>> languagelist = List.generate(
        body["count_langs"],
        (index) => DropdownMenuItem<String>(
              value: "${body["langs_flags"][index]} ${body["langs"][index]}",
              child: Text(
                "${body["langs"][index]}",
                style: textStyle,
              ),
            ));
    return languagelist;
  }
}
