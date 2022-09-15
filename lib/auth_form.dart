import 'package:layout/layout.dart';
import 'package:avoid_keyboard/avoid_keyboard.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter/material.dart';

import 'server_connector.dart';
import 'auth_fields.dart';
import 'main.dart';

// ignore: must_be_immutable
class AuthForm extends StatefulWidget {
  late List<DropdownMenuItem<String>> languagelist;
  String currentLang;
  String submit;
  String logo;
  int fieldsCount;
  dynamic data;

  AuthForm(
      {super.key,
      required this.languagelist,
      required this.currentLang,
      required this.submit,
      required this.logo,
      required this.data,
      required this.fieldsCount}) {
    forms = generateForms(data);
    for (var element in forms) {
      if (element.type == "brand") {
        brands.add(element);
      } else if (element.type == "checkbox") {
        checkboxes.add(element);
      } else {
        fields.add(element);
      }
    }
  }

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  AuthHelper authHelper = AuthHelper();

  List<AuthField> forms = [];
  List<TextEditingController> controllers = [];
  List<AuthField> fields = [];
  List<AuthField> brands = [];
  List<AuthField> checkboxes = [];

  String frontTitle = "";
  String frontDescription = "";

  List<AuthField> generateForms(dynamic body) {
    controllers =
        List.generate(fieldsCount, (index) => TextEditingController());

    for (int i = 0; i < fieldsCount; ++i) {
      forms.add(AuthField.createForm(
          body[i]["type"],
          body[i]["api_name"],
          body[i]["title"],
          body[i]["description"],
          body[i]["brand_icon"],
          body[i]["api_value"],
          body[i]["required_field"],
          controllers[i]));
      if (forms[i].type == "front") {
        frontTitle = forms[i].title;
        frontDescription = forms[i].description!;
      }
    }
    return forms;
  }

  @override
  State<AuthForm> createState() => AuthFieldsState();
}

class AuthFieldsState extends State<AuthForm> {
  @override
  Widget build(BuildContext context) {
    return Layout(
        child: AdaptiveBuilder(
      xs: (context) => webMobile(widget.logo),
      md: (context) => webDesktop(widget.logo),
    ));
  }

  ScrollController scrollController = ScrollController();

  Widget webMobile(String logo) {
    return Padding(
      padding: const EdgeInsets.only(right: 5, left: 5),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(25)),
        child: Column(
          children: [
            Image(
              image: NetworkImage("$server/img/$logo"),
              height: 100,
              width: 250,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    children: [
                      Text(
                        widget.frontTitle,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.frontDescription,
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
                Form(
                  key: widget.formkey,
                  child: AvoidKeyboard(
                    child: Column(
                      children: [
                        Column(
                          children: widget.fields,
                        ),
                        (widget.brands.isNotEmpty)
                            ? Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Text(
                                      widget.brands[0].title,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 120,
                                    child: (widget.brands.length >
                                            3) // Доп логика, грязь но пох
                                        ? Scrollbar(
                                            controller: scrollController,
                                            trackVisibility: true,
                                            thumbVisibility: true,
                                            thickness: 2,
                                            child: ListView.builder(
                                              itemCount: widget.brands.length,
                                              controller: scrollController,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  child: widget.brands[index],
                                                );
                                              },
                                            ))
                                        : Center(
                                            // И вот так
                                            widthFactor: 100,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: widget.brands,
                                            )),
                                  )
                                ],
                              )
                            : const SizedBox(),
                        (widget.checkboxes.isNotEmpty)
                            ? Column(
                                children: widget.checkboxes,
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Center(
                    child: ElevatedButton(
                      style: buttonStyle,
                      onPressed: () async {
                        if (widget.formkey.currentState!.validate()) {
                          widget.authHelper.connecting();
                          var response = await widget.authHelper
                              .postData(widget.currentLang, widget.forms);
                          if (response == 200) {
                            // ignore: use_build_context_synchronously
                            Routemaster.of(context).push("/logged");
                          }
                        }
                      },
                      child: Text(widget.submit,
                          style: const TextStyle(
                              color: Colors.black, fontFamily: "Arial")),
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
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
            width: 400, // Убрал Height дало гибкости в размерах
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.white),
            child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            widget.frontTitle,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.frontDescription,
                            style: textStyle,
                          ),
                        ],
                      ),
                    ),
                    Form(
                      key: widget.formkey,
                      child: Column(
                        children: [
                          Column(
                            children: widget.fields,
                          ),
                          (widget.brands.isNotEmpty)
                              ? Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Text(
                                        widget.brands[0].title,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      height: 90,
                                      child: (widget.brands.length >
                                              3) // Доп логика, грязь но пох
                                          ? Scrollbar(
                                              controller: scrollController,
                                              trackVisibility: true,
                                              thumbVisibility: true,
                                              thickness: 2,
                                              child: ListView(
                                                controller: scrollController,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                children: widget.brands,
                                              ))
                                          : Center(
                                              // И вот так
                                              widthFactor: 100,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: widget.brands,
                                              )),
                                    )
                                  ],
                                )
                              : const SizedBox(),
                          (widget.checkboxes.isNotEmpty)
                              ? Column(
                                  children: widget.checkboxes,
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        style: buttonStyle,
                        onPressed: () async {
                          if (widget.formkey.currentState!.validate()) {
                            if (widget.authHelper
                                .checkBrandRequired(widget.brands)) {
                              widget.authHelper.connecting();
                              var response = await widget.authHelper
                                  .postData(widget.currentLang, widget.forms);
                              if (response == 200) {
                                // ignore: use_build_context_synchronously
                                Routemaster.of(context).push("/logged");
                              }
                            } else {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      content: Text(
                                "You have to choose a brand",
                                style: textStyle,
                              )));
                            }
                          }
                        },
                        child: Text(
                          widget.submit,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    )),
                  ],
                ))),
      ],
    ));
  }
}
