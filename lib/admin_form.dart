import 'package:flutter/material.dart';

import 'admin_fields.dart';

// ignore: must_be_immutable
class AdminForm extends StatefulWidget {
  AdminForm({super.key});

  var adminField = AdminField.createAdminField("textfield");
  AdminField getChild() => adminField;

  void setChild(AdminField newAdminField) {
    adminField = newAdminField;
  }

  factory AdminForm.fromJson(
      String type,
      int id,
      Map<String, dynamic> title,
      Map<String, dynamic>? description,
      String apiName,
      String? brandIcon,
      String? apiValue,
      bool? isRequired) {
    if (type == "email") {
      return AdminForm()
        ..setChild(Email.fromJson(id, title, apiName, isRequired!));
    } else if (type == "number") {
      return AdminForm()
        ..setChild(Number.fromJson(id, title, apiName, isRequired!));
    } else if (type == "checkbox") {
      return AdminForm()..setChild(CheckBox.fromJson(id, title, apiName));
    } else if (type == "brand") {
      return AdminForm()
        ..setChild(Brand.fromJson(id, title, apiName, brandIcon, apiValue!));
    } else if (type == "front") {
      return AdminForm()..setChild(Front.fromJson(id, title, description));
    } else {
      return AdminForm()
        ..setChild(
            Textfield.fromJson(id, title, description, apiName, isRequired!));
    }
  }

  AdminForm.front({super.key}) {
    setChild(Front());
  }

  @override
  State<AdminForm> createState() => AdminFormState();
}

class AdminFormState extends State<AdminForm> {
  List<DropdownMenuItem<AdminField>> fields = [
    DropdownMenuItem(
      value: Textfield(),
      child: const Text("textfield"),
    ),
    DropdownMenuItem(
      value: Email(),
      child: const Text("email"),
    ),
    DropdownMenuItem(
      value: Number(),
      child: const Text("number"),
    ),
    DropdownMenuItem(
      value: CheckBox(),
      child: const Text("checkbox"),
    ),
    DropdownMenuItem(
      value: Brand(),
      child: const Text("brand"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return (widget.adminField.type != "front")
        ? Container(
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 240, 240, 240),
                border: Border(
                  left: BorderSide(width: 5, color: Colors.amber),
                )),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
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
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: widget.adminField,
              ),
            ]))
        : widget.adminField;
  }
}
