import 'package:flutter/material.dart';
import 'admin.dart';

// ignore: must_be_immutable
class CustomForm extends StatefulWidget {
  CustomForm({super.key});

  var a = CustomField();

  CustomField getChild() {
    return a;
  }

  void setChild(CustomField cf) {
    a = cf;
  }

  @override
  State<CustomForm> createState() => FormState();
}

class FormState extends State<CustomForm> {
  FormState();

  final List<DropdownMenuItem<String>> fields = [
    const DropdownMenuItem(value: "textfield", child: Text("textfield")),
    const DropdownMenuItem(value: "email", child: Text("email")),
    const DropdownMenuItem(value: "number", child: Text("number")),
    const DropdownMenuItem(value: "checkbox", child: Text("checkbox")),
    const DropdownMenuItem(value: "brand", child: Text("brand")),
  ];

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
                  hint: Text(widget.a.type),
                  items: fields,
                  onChanged: (value) {
                    setState(() {
                      if (value == "email") {
                        widget.a = CustomField.email();
                      } else if (value == "number") {
                        widget.a = CustomField.number();
                      } else if (value == "checkbox") {
                        widget.a = CustomField.checkbox();
                      } else if (value == "brand") {
                        widget.a = CustomField.brand();
                      } else {
                        widget.a = CustomField();
                      }
                    });
                  }),
            ],
          ),
          widget.a,
        ]));
  }
}

// ignore: must_be_immutable
class CustomField extends StatefulWidget {
  CustomField({super.key}) {
    type = "textfield";
    hasApi = true;
    hasDescription = true;
    hasIcon = false;
  }
  CustomField.front({super.key}) {
    type = "front";
    hasApi = false;
    hasDescription = true;
    hasIcon = false;
  }
  CustomField.email({super.key}) {
    type = "email";
    hasApi = true;
    hasDescription = false;
    hasIcon = false;
  }
  CustomField.number({super.key}) {
    type = "number";
    hasApi = true;
    hasDescription = false;
    hasIcon = false;
  }
  CustomField.checkbox({super.key}) {
    type = "checkbox";
    hasApi = true;
    hasDescription = false;
    hasIcon = false;
  }
  CustomField.brand({super.key}) {
    type = "brand";
    hasApi = true;
    hasDescription = false;
    hasIcon = true;
  }
  String type = "textfield";
  String? api;
  Map<String, String> title = {};
  Map<String, String> description = {};
  String? icon;
  bool hasApi = true;
  bool hasDescription = false;
  bool hasIcon = false;
  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerDesciption = TextEditingController();
  TextEditingController controllerApi = TextEditingController();
  TextEditingController controllerIcon = TextEditingController();

  Map<String, dynamic> commit() {
    api = controllerApi.text;
    Map<String, dynamic> object = {
      "type": type,
      "title": title,
    };
    if (hasApi) {
      object.addAll({"api_name": api});
    }
    if (hasDescription) {
      object.addAll({"description": description});
    }
    if (hasIcon) {
      icon = controllerIcon.text;
      object.addAll({"icon": icon});
    }
    return object;
  }

  @override
  State<CustomField> createState() => Field();
}

class Field extends State<CustomField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration:
          const BoxDecoration(color: Color.fromARGB(255, 255, 255, 255)),
      child: Column(children: [
        (widget.hasApi)
            ? Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    const Text("Key"),
                    SizedBox(
                      width: 250,
                      height: 40,
                      child: TextFormField(
                        controller: widget.controllerApi,
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox(),
        SizedBox(
          height: 50,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: languagelist.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return TextButton(
                    onPressed: () => setState(() {
                          currentLang = languagelist.elementAt(index);
                        }),
                    child: Text(languagelist.elementAt(index)));
              }),
        ),
        Column(
          children: [
            const Text("Zagolovok"),
            TextFormField(
              onChanged: (value) => setState(() {
                widget.title.addAll({currentLang: value});
              }),
            ),
          ],
        ),
        (widget.hasDescription)
            ? Column(
                children: [
                  const Text("Podzagolovok"),
                  TextFormField(
                    onChanged: (value) => setState(() {
                      widget.description.addAll({currentLang: value});
                    }),
                  ),
                ],
              )
            : const SizedBox(),
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
            : const SizedBox(),
      ]),
    );
  }
}
