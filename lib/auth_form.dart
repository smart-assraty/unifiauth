import 'package:layout/layout.dart';
import 'package:avoid_keyboard/avoid_keyboard.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter/material.dart';

import 'server_connector.dart';
import 'auth_fields.dart';
import 'main.dart';

class AuthForm extends StatefulWidget {
  final List<DropdownMenuItem<String>> languagelist;
  final String currentLang;
  final String submit;
  final String logo;
  final int fieldsCount;
  final dynamic data;

  final authHelper = const AuthHelper();

  const AuthForm(
      {super.key,
      required this.languagelist,
      required this.currentLang,
      required this.submit,
      required this.logo,
      required this.data,
      required this.fieldsCount});

  @override
  State<AuthForm> createState() => AuthFieldsState();
}

class AuthFieldsState extends State<AuthForm> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  List<AuthField> forms = [];
  List<TextEditingController> controllers = [];
  List<AuthField> fields = [];
  List<AuthField> brands = [];
  List<AuthField> checkboxes = [];

  String frontTitle = "";
  String frontDescription = "";

  List<AuthField> generateForms(dynamic body) {
    controllers = List.generate(widget.fieldsCount, (index) => TextEditingController());

    for (int i = 0; i < widget.fieldsCount; ++i) {
      forms.add(
        AuthField.createForm(
          body[i]["type"],
          body[i]["api_name"],
          body[i]["title"],
          body[i]["description"],
          body[i]["brand_icon"],
          body[i]["api_value"],
          body[i]["required_field"],
          controllers[i]
        )
      );
      if (forms[i].type == "front") {
        frontTitle = forms[i].title;
        frontDescription = forms[i].description!;
      }
    }
    return forms;
  }

  @override
  void initState(){
    super.initState();

    forms = generateForms(widget.data);
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
                        frontTitle,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        frontDescription,
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
                Form(
                  key: formkey,
                  child: AvoidKeyboard(
                    child: Column(
                      children: [
                        Column(
                          children: fields,
                        ),
                        (brands.isNotEmpty)
                            ? Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Text(
                                      brands[0].title,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 90,
                                    child: (brands.length >
                                            3) // Доп логика, грязь но пох
                                        ? Scrollbar(
                                            controller: scrollController,
                                            trackVisibility: true,
                                            thumbVisibility: true,
                                            thickness: 2,
                                            child: ListView.builder(
                                              itemCount: brands.length,
                                              controller: scrollController,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(1),
                                                  child: brands[index],
                                                );
                                              },
                                            ))
                                        : Center(
                                            // И вот так
                                            child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: brands,
                                          )),
                                  )
                                ],
                              )
                            : const SizedBox(),
                        (checkboxes.isNotEmpty)
                            ? Column(
                                children: checkboxes,
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Center(
                    child: ElevatedButton(
                      style: buttonStyle,
                      onPressed: () async {
                        bool isChecked = widget.authHelper
                                .checkBrandRequired(brands);
                            if (isChecked) {
                                if (formkey.currentState!.validate()) {
                              widget.authHelper.connecting();
                              var response = await widget.authHelper
                                  .postData(widget.currentLang, forms);
                              if (response == 200) {
                                // ignore: use_build_context_synchronously
                                Routemaster.of(context).push("/logged");
                              }
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
                            overflow: TextOverflow.visible,
                            frontTitle,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                            
                          Text(
                            overflow: TextOverflow.visible,
                            frontDescription,
                            style: textStyle,
                          ),
                        ],
                      ),
                    ),
                    Form(
                      key: formkey,
                      child: Column(
                        children: [
                          Column(
                            children: fields,
                          ),
                          (brands.isNotEmpty)
                              ? Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Text(
                                        brands[0].title,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 90,
                                      child: (brands.length >
                                              3) // Доп логика, грязь но пох
                                          ? Scrollbar(
                                              controller: scrollController,
                                              trackVisibility: true,
                                              thumbVisibility: true,
                                              thickness: 2,
                                              child: ListView.builder(
                                                itemCount: brands.length,
                                                controller: scrollController,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(1),
                                                    child: brands[index],
                                                  );
                                                },
                                              ))
                                          : Center(
                                              // И вот так
                                              child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: brands,
                                            )),
                                    )
                                  ],
                                )
                              : const SizedBox(),
                          (checkboxes.isNotEmpty)
                              ? Column(
                                  children: checkboxes,
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
                          bool isChecked = widget.authHelper
                                .checkBrandRequired(brands);
                            if (isChecked) {
                                if (formkey.currentState!.validate()) {
                              widget.authHelper.connecting();
                              var response = await widget.authHelper
                                  .postData(widget.currentLang, forms);
                              if (response == 200) {
                                // ignore: use_build_context_synchronously
                                Routemaster.of(context).push("/logged");
                              }
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