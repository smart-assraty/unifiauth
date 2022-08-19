import 'package:flutter/material.dart';

//int id = 1;
String currentLang = "rus";
List<DropdownMenuItem<String>> languages = [
  const DropdownMenuItem(value: "rus", child: Text("rus")),
  const DropdownMenuItem(value: "eng", child: Text("eng")),
  const DropdownMenuItem(value: "kaz", child: Text("kaz")),
];

// ignore: must_be_immutable
class CustomForm extends StatefulWidget {
  CustomForm({super.key}) {
    //number = id;
    //id++;
  }
  final List<DropdownMenuItem<String>> fields = [
    const DropdownMenuItem(value: "textfield", child: Text("textfield")),
    const DropdownMenuItem(value: "email", child: Text("email")),
    const DropdownMenuItem(value: "number", child: Text("number")),
    const DropdownMenuItem(value: "checkbox", child: Text("checkbox")),
    const DropdownMenuItem(value: "brand", child: Text("brand")),
  ];
  //late int number;
  String? type;
  String? api;
  late Map<String, String> title;
  late Map<String, String> description;
  String? icon;
  bool hasDescription = false;
  bool hasIcon = false;
  TextEditingController controllerApi = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerHint = TextEditingController();
  TextEditingController controllerIcon = TextEditingController();

  Map<String, dynamic> commit() {
    Map<String, dynamic> object = {
      //"number": number,
      "api": api,
      "type": type,
      "title": title,
      "description": description,
      "icon": icon,
    };
    return object;
  }

  @override
  State<CustomForm> createState() => Form();
}

class Form extends State<CustomForm> {
  String hintText = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration:
          const BoxDecoration(color: Color.fromARGB(255, 255, 255, 255)),
      child: Column(children: [
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Text("Type"),
            ),
            DropdownButton<String>(
                hint: Text(widget.type!),
                items: widget.fields,
                onChanged: (value) => setState(() {
                      if (value == "textfield") {
                        widget.type = "textfield";
                        widget.hasDescription = true;
                        widget.hasIcon = false;
                      } else if (value == "email") {
                        hintText = "example@mail.com";
                        widget.type = "email";
                        widget.hasDescription = false;
                        widget.hasIcon = false;
                      } else if (value == "number") {
                        hintText = "XXX XXX XX XX";
                        widget.type = "number";
                        widget.hasDescription = false;
                        widget.hasIcon = false;
                      } else if (value == "checkbox") {
                        widget.type = "checkbox";
                        widget.hasDescription = false;
                        widget.hasIcon = false;
                      } else if (value == "brand") {
                        widget.type = "brand";
                        widget.hasIcon = true;
                        widget.hasDescription = false;
                      }
                    })),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              const Text("Api name"),
              SizedBox(
                width: 250,
                height: 40,
                child: TextFormField(
                  controller: widget.controllerApi,
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            const Text("Zagolovok"),
            SizedBox(
              height: 30,
              child: TextFormField(
                onEditingComplete: () {
                  widget.title
                      .addAll({currentLang: widget.controllerName.text});
                },
                controller: widget.controllerName,
                decoration: InputDecoration(hintText: hintText),
              ),
            ),
          ],
        ),
        (widget.hasDescription)
            ? Column(
                children: [
                  const Text("Podzagolovok"),
                  TextFormField(
                    controller: widget.controllerHint,
                    onEditingComplete: () {
                      widget.title
                          .addAll({currentLang: widget.controllerName.text});
                    },
                  ),
                ],
              )
            : const SizedBox(
                height: 1.0,
              ),
        (widget.hasIcon)
            ? Row(
                children: [
                  const Icon(Icons.abc, size: 24),
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      controller: widget.controllerIcon,
                    ),
                  ),
                ],
              )
            : const SizedBox(
                height: 1.0,
              ),
      ]),
    );
  }
}
