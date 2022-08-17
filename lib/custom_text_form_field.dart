import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomForm extends StatefulWidget {
  CustomForm({super.key});
  CustomForm.textField({Key? key}) : super(key: key) {
    type = "textfield";
    hasHint = true;
  }
  CustomForm.email({Key? key}) : super(key: key) {
    type = "email";
    name = "example@name.kz";
  }
  CustomForm.number({Key? key}) : super(key: key) {
    type = "number";
    name = "XXX XXX XX XX";
  }
  CustomForm.checkbox({Key? key}) : super(key: key) {
    type = "checkbox";
  }
  CustomForm.brand({Key? key}) : super(key: key) {
    type = "brand";
    hasIcon = true;
  }
  final List<DropdownMenuItem<String>> fields = [
    const DropdownMenuItem(value: "textfield", child: Text("textfield")),
    const DropdownMenuItem(value: "email", child: Text("email")),
    const DropdownMenuItem(value: "number", child: Text("number")),
    const DropdownMenuItem(value: "checkbox", child: Text("checkbox")),
    const DropdownMenuItem(value: "brand", child: Text("brand")),
  ];
  String? type;
  String? api;
  String? name;
  String? hint;
  String? icon;
  bool hasHint = false;
  bool hasIcon = false;
  TextEditingController controllerApi = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerHint = TextEditingController();
  TextEditingController controllerIcon = TextEditingController();

  void commit() {
    api = controllerApi.text;
    name = controllerName.text;
    if (hasHint) {
      hint = controllerHint.text;
    }
    if (hasIcon) {
      icon = controllerIcon.text;
    }
  }

  @override
  State<CustomForm> createState() => Form();
}

class Form extends State<CustomForm> {
  @override
  Widget build(BuildContext context) {
    debugPrint(widget.type);
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
                        widget.hasHint = true;
                        widget.hasIcon = false;
                      } else if (value == "email") {
                        widget.type = "email";
                        widget.hasHint = false;
                        widget.hasIcon = false;
                        widget.name = "example@name.kz";
                      } else if (value == "number") {
                        widget.type = "number";
                        widget.name = "XXX XXX XX XX";
                        widget.hasHint = false;
                        widget.hasIcon = false;
                      } else if (value == "checkbox") {
                        widget.type = "checkbox";
                        widget.hasHint = false;
                        widget.hasIcon = false;
                      } else if (value == "brand") {
                        widget.type = "brand";
                        widget.hasIcon = true;
                        widget.hasHint = false;
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
                controller: widget.controllerName,
                decoration: InputDecoration(hintText: widget.name),
              ),
            ),
          ],
        ),
        (widget.hasHint)
            ? Column(
                children: [
                  const Text("Podzagolovok"),
                  TextFormField(controller: widget.controllerHint),
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
