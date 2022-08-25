import 'package:flutter/material.dart';
import 'dart:convert';
import 'admin.dart';

// ignore: must_be_immutable
class AdminForm extends StatefulWidget {
  AdminForm({super.key});

  var adminField = AdminField.textfield();

  AdminField getChild() => adminField;

  void setChild(AdminField newAdminField) {
    adminField = newAdminField;
  }

  factory AdminForm.fromJson(String type, String title, String key,
      String? description, String? brand) {
    if (type == "email") {
      return AdminForm()..setChild(AdminField.email());
    } else if (type == "number") {
      return AdminForm()..setChild(AdminField.number());
    } else if (type == "checkbox") {
      return AdminForm()..setChild(AdminField.checkbox());
    } else if (type == "brand") {
      return AdminForm()..setChild(AdminField.brand());
    } else if (type == "front") {
      return AdminForm()..setChild(AdminField.front());
    } else {
      return AdminForm();
    }
  }

  @override
  State<AdminForm> createState() => AdminFormState();
}

class AdminFormState extends State<AdminForm> {
  List<DropdownMenuItem<AdminField>> fields = [
    DropdownMenuItem(
      value: AdminField.textfield(),
      child: const Text("textfield"),
    ),
    DropdownMenuItem(
      value: AdminField.email(),
      child: const Text("email"),
    ),
    DropdownMenuItem(
      value: AdminField.number(),
      child: const Text("number"),
    ),
    DropdownMenuItem(
      value: AdminField.checkbox(),
      child: const Text("checkbox"),
    ),
    DropdownMenuItem(
      value: AdminField.brand(),
      child: const Text("brand"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Text("Type"),
              ),
              DropdownButton<AdminField>(
                  hint: Text(widget.adminField.type),
                  items: fields,
                  onChanged: (value) {
                    setState(() {
                      widget.adminField = value!;
                    });
                  }),
            ],
          ),
          widget.adminField,
        ]));
  }
}

// ignore: must_be_immutable
class AdminField extends StatefulWidget {
  AdminField.textfield({super.key}) {
    type = "textfield";
    hasApi = true;
    hasDescription = true;
    hasIcon = false;
  }
  AdminField.front({super.key}) {
    type = "front";
    hasApi = false;
    hasDescription = true;
    hasIcon = false;
  }
  AdminField.email({super.key}) {
    type = "email";
    hasApi = true;
    hasDescription = false;
    hasIcon = false;
  }
  AdminField.number({super.key}) {
    type = "number";
    hasApi = true;
    hasDescription = false;
    hasIcon = false;
  }
  AdminField.checkbox({super.key}) {
    type = "checkbox";
    hasApi = true;
    hasDescription = false;
    hasIcon = false;
  }
  AdminField.brand({super.key}) {
    type = "brand";
    hasApi = true;
    hasDescription = false;
    hasIcon = true;
  }
  String type = "textfield";
  bool hasApi = true;
  bool hasDescription = false;
  bool hasIcon = false;
  Map<String, String> title = {};
  Map<String, String> description = {};

  String? api;
  String? brand;

  TextEditingController controllerApi = TextEditingController();
  TextEditingController controllerIcon = TextEditingController();

  Map<String, dynamic> commit() {
    Map<String, dynamic> object = {
      "number": numerator,
      "field_type": type,
    };
    numerator++;
    if (hasApi) {
      api = controllerApi.text;
      object.addAll({"api_name": api});
    }
    List<Map<String, String>> fieldTitle = [];
    for (int j = 0; j < title.length; ++j) {
      fieldTitle.add(
          {"lang": title.keys.elementAt(j), "text": title.values.elementAt(j)});
    }
    object.addAll({
      "field_title": fieldTitle,
    });
    if (hasDescription) {
      List<Map<String, String>> list = [];
      for (int j = 0; j < description.length; ++j) {
        list.add({
          "lang": description.keys.elementAt(j),
          "text": description.values.elementAt(j)
        });
      }
      object.addAll({
        "description": list,
      });
    }
    if (hasIcon) {
      object.addAll({"brand_icon": brand});
    }
    return object;
  }

  @override
  State<AdminField> createState() => AdminFieldState();
}

class AdminFieldState extends State<AdminField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(color: Colors.white),
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
                  IconButton(
                      onPressed: () async {
                        widget.brand = await imgUrl();
                      },
                      icon: const Icon(Icons.abc)),
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

  Future<String> imgUrl() async {
    var response = json.decode(await sendImage(await pickfile(), "Brands"));
    return response["url"];
  }
}
