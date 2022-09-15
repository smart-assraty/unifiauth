import 'package:flutter/material.dart';

import 'server_connector.dart' show AuthHelper;
import 'auth_form.dart';
import 'main.dart';

// ignore: must_be_immutable
class AuthPage extends StatefulWidget {
  AuthPage({super.key});

  String currentLang = "rus";
  AuthHelper authHelper = AuthHelper();
  List<DropdownMenuItem<String>> languagelist = [];
  @override
  State<AuthPage> createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: widget.authHelper.getForms(widget.currentLang),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            dynamic body = snapshot.data!;
            widget.languagelist = setLanguages(body);
            return Container(
                height: double.maxFinite,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage("$server/img/${body['bg_image']}"),
                        fit: BoxFit.fill)),
                child: ListView(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: DropdownButton(
                        hint: Text(
                          widget.currentLang,
                          style: const TextStyle(color: Colors.white),
                        ),
                        items: widget.languagelist,
                        onChanged: (value) => setState(() {
                          widget.currentLang = value.toString().split(" ")[1];
                        }),
                      ),
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.92,
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AuthForm(
                              languagelist: widget.languagelist,
                              currentLang: widget.currentLang,
                              submit: body["submit_lang"],
                              logo: body["logo_image"],
                              data: body["fields"],
                              fieldsCount: body["count_fields"],
                            ),
                          ],
                        )),
                  ],
                ));
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
