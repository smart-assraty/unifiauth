import 'package:flutter/material.dart';
import 'admin.dart';

// ignore: must_be_immutable
class AdminForm extends StatefulWidget {
  AdminForm({super.key});

  var a = AdminField();

  AdminField getChild() {
    return a;
  }

  void setChild(AdminField cf) {
    a = cf;
  }

  @override
  State<AdminForm> createState() => AdminFormState();
}

class AdminFormState extends State<AdminForm> {
  AdminFormState();

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
                        widget.a = AdminField.email();
                      } else if (value == "number") {
                        widget.a = AdminField.number();
                      } else if (value == "checkbox") {
                        widget.a = AdminField.checkbox();
                      } else if (value == "brand") {
                        widget.a = AdminField.brand();
                      } else {
                        widget.a = AdminField();
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
class AdminField extends StatefulWidget {
  AdminField({super.key}) {
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
  String? icon;
  TextEditingController controllerApi = TextEditingController();
  TextEditingController controllerIcon = TextEditingController();

  Map<String, dynamic> commit() {
    Map<String, dynamic> object = {
      "number": i,
      "field_type": type,
    };
    i++;
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
      icon = controllerIcon.text;
      object.addAll({
        "brands": {"brands_img": icon, "brands_api_name": api}
      });
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
