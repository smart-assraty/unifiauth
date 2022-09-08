import 'package:avoid_keyboard/avoid_keyboard.dart';
import 'package:breakpoint/breakpoint.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:routemaster/routemaster.dart';

import 'main.dart';
import 'server_connector.dart' show AuthHelper;
import 'auth_forms.dart';

// ignore: must_be_immutable
class AuthPage extends StatefulWidget {
  AuthPage({super.key});

  String currentLang = "rus";
  String? currentFlag;
  AuthHelper authHelper = AuthHelper();
  List<DropdownMenuItem<String>> languagelist = [];
  List<Map<String, dynamic>> dataToApi = [];
  List<TextEditingController> controllers = [];
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
            (widget.currentFlag == null)
                ? widget.currentFlag = widget.languagelist[0].value!
                : null;
            return Container(
                height: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage("$server/img/${body['bg_image']}"),
                        fit: BoxFit.fill)),
                child: Column(children: [
                  Align(
                    alignment: Alignment.center,
                    child: DropdownButton(
                      hint: Text(
                        widget.currentFlag!,
                        style: const TextStyle(color: Colors.white),
                      ),
                      items: widget.languagelist,
                      onChanged: (value) => setState(() {
                        widget.currentLang = value.toString().split(" ")[1];
                        widget.currentFlag = value.toString();
                      }),
                    ),
                  ),
                  AuthFields(
                    forms: generateForms(body),
                    languagelist: widget.languagelist,
                    currentLang: widget.currentLang,
                    title: body["fields"][body["count_fields"] - 1]["title"],
                    description: body["fields"][body["count_fields"] - 1]
                        ["description"],
                    submit: body["submit_lang"],
                    logo: body["logo_image"],
                  ),
                ]));
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
              child:
                  Text("${body["langs_flags"][index]} ${body["langs"][index]}"),
            ));
    return languagelist;
  }

  List<AuthForm> generateForms(dynamic body) {
    List<AuthForm> forms = [];

    widget.controllers =
        List.generate(body["count_fields"], (index) => TextEditingController());

    for (int i = 0; i < body["count_fields"] - 1; ++i) {
      forms.add(AuthForm.createForm(
          body["fields"][i]["type"],
          body["fields"][i]["api_name"],
          body["fields"][i]["title"],
          body["fields"][i]["description"],
          body["fields"][i]["brand_icon"],
          body["fields"][i]["api_value"],
          widget.controllers[i]));
    }
    return forms;
  }
}

// ignore: must_be_immutable
class AuthFields extends StatefulWidget {
  late List<AuthForm> forms;
  late List<DropdownMenuItem<String>> languagelist;
  AuthHelper authHelper = AuthHelper();
  String currentLang;
  String title;
  String description;
  String submit;
  String logo;
  AuthFields(
      {super.key,
      required this.forms,
      required this.languagelist,
      required this.currentLang,
      required this.title,
      required this.description,
      required this.submit,
      required this.logo}) {
    for (var element in forms) {
      (element.type == "brand") ? brands.add(element) : fields.add(element);
    }
  }

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  List<AuthForm> fields = [];
  List<AuthForm> brands = [];
  List<Map<String, dynamic>> dataToApi = [];
  List<TextEditingController> controllers = [];
  @override
  State<AuthFields> createState() => AuthFieldsState();
}

class AuthFieldsState extends State<AuthFields> {
  @override
  Widget build(BuildContext context) {
    final breakpoint = Breakpoint.fromMediaQuery(context);
    return Layout(
      child: (breakpoint.window > WindowSize.small)
          ? webDesktop(widget.logo)
          : webMobile(),
    );
  }

  Widget webMobile() {
    return ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 5, left: 5),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(25)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(widget.description),
                        ],
                      ),
                    ),
                    Form(
                      key: widget.formkey,
                      child: AvoidKeyboard(
                        child: Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.fields.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    widget.fields[index],
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                );
                              },
                            ),
                            (widget.brands.isNotEmpty)
                                ? SizedBox(
                                    height: 150,
                                    child: Column(
                                      children: [
                                        Text(
                                          widget.brands[0].title,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          children: widget.brands,
                                        )
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: buttonStyle,
                          onPressed: () async {
                            if (widget.formkey.currentState!.validate()) {
                              widget.authHelper.connecting();
                              var response = await widget.authHelper.postData(
                                  widget.currentLang,
                                  widget.dataToApi,
                                  widget.forms);
                              if (response == 200) {
                                // ignore: use_build_context_synchronously
                                Routemaster.of(context).push("/logged");
                              }
                            }
                          },
                          child: Text(widget.submit,
                              style: const TextStyle(color: Colors.black)),
                        ),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget webDesktop(String logo) {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
            padding: const EdgeInsets.all(20),
            child: Image(
              image: NetworkImage("$server/img/$logo"),
              height: 300,
              width: 300,
            )),
        Container(
            width: 400,
            height: 550,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.white),
            child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(widget.description),
                        ],
                      ),
                    ),
                    Form(
                      key: widget.formkey,
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.fields.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  widget.fields[index],
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              );
                            },
                          ),
                          (widget.brands.isNotEmpty)
                              ? SizedBox(
                                  height: 150,
                                  child: Column(
                                    children: [
                                      Text(
                                        widget.brands[0].title,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: widget.brands,
                                      )
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: buttonStyle,
                        onPressed: () async {
                          if (widget.formkey.currentState!.validate()) {
                            widget.authHelper.connecting();
                            var response = await widget.authHelper.postData(
                                widget.currentLang,
                                widget.dataToApi,
                                widget.forms);
                            if (response == 200) {
                              // ignore: use_build_context_synchronously
                              Routemaster.of(context).push("/logged");
                            }
                          }
                        },
                        child: Text(
                          widget.submit,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ))),
      ],
    ));
  }
}
