import 'package:flutter/material.dart';
import 'admin.dart';

// ignore: must_be_immutable
class CustomForm extends StatefulWidget {
  CustomForm({super.key});
  CustomForm.front({super.key}) {
    type = "front";
    hasApi = false;
    hasDescription = true;
    hasIcon = false;
  }
  final List<DropdownMenuItem<String>> fields = [
    const DropdownMenuItem(value: "textfield", child: Text("textfield")),
    const DropdownMenuItem(value: "email", child: Text("email")),
    const DropdownMenuItem(value: "number", child: Text("number")),
    const DropdownMenuItem(value: "checkbox", child: Text("checkbox")),
    const DropdownMenuItem(value: "brand", child: Text("brand")),
  ];
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
  State<CustomForm> createState() => Form();
}

class Form extends State<CustomForm> {
  @override
  Widget build(BuildContext context) {
    if (widget.type == "textfield") {
      widget.hasApi = true;
      widget.hasDescription = true;
      widget.hasIcon = false;
    }
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration:
          const BoxDecoration(color: Color.fromARGB(255, 255, 255, 255)),
      child: Column(children: [
        (widget.type != "front")
            ? Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text("Type"),
                  ),
                  DropdownButton<String>(
                      hint: Text(widget.type),
                      items: widget.fields,
                      onChanged: (value) => setState(() {
                            if (value == "textfield") {
                              widget.hasApi = true;
                              widget.type = "textfield";
                              widget.hasDescription = true;
                              widget.hasIcon = false;
                            } else if (value == "email") {
                              widget.hasApi = true;
                              widget.type = "email";
                              widget.hasDescription = false;
                              widget.hasIcon = false;
                            } else if (value == "number") {
                              widget.hasApi = true;
                              widget.type = "number";
                              widget.hasDescription = false;
                              widget.hasIcon = false;
                            } else if (value == "checkbox") {
                              widget.hasApi = true;
                              widget.type = "checkbox";
                              widget.hasDescription = false;
                              widget.hasIcon = false;
                            } else if (value == "brand") {
                              widget.hasApi = true;
                              widget.type = "brand";
                              widget.hasIcon = true;
                              widget.hasDescription = false;
                            }
                          })),
                ],
              )
            : const SizedBox(),
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
        Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: SizedBox(
              height: 40,
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
            )),
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
