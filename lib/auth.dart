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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: widget.authHelper.getForms(language.toString()),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            dynamic body = snapshot.data!;
            return Container(
                width: MediaQuery.of(context).size.width,
                height: double.maxFinite,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage("$server/img/${body['bg_image']}"),
                        fit: BoxFit.fill)),
                child: Center(
                    child: SingleChildScrollView(
                        child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AuthForm(
                      languagelist: languagelist,
                      currentLang: language.toString(),
                      submit: body["submit_lang"],
                      logo: body["logo_image"],
                      data: body["fields"],
                      fieldsCount: body["count_fields"],
                    ),
                  ],
                ))));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
