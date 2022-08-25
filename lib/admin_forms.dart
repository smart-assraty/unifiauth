import 'package:flutter/material.dart';
import 'dart:convert';
import 'admin.dart';

// ignore: must_be_immutable
class AdminForm extends StatefulWidget {
  AdminForm({super.key});

  var adminField = AdminField.createAdminField("textfield");

  AdminField getChild() => adminField;

  void setChild(AdminField newAdminField) {
    adminField = newAdminField;
  }

  factory AdminForm.fromJson(String type, String title, String key,
      String? description, String? brand) {
    if (type == "email") {
      return AdminForm()..setChild(Email());
    } else if (type == "number") {
      return AdminForm()..setChild(Number());
    } else if (type == "checkbox") {
      return AdminForm()..setChild(Checkbox());
    } else if (type == "brand") {
      return AdminForm()..setChild(Brand());
    } else if (type == "front") {
      return AdminForm()..setChild(Front());
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
      value: TextField(),
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
      value: Checkbox(),
      child: const Text("checkbox"),
    ),
    DropdownMenuItem(
      value: Brand(),
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
  AdminField({super.key, required this.type});

  factory AdminField.createAdminField(String type) {
    if (type == "email") {
      return Email();
    } else if (type == "number") {
      return Number();
    } else if (type == "checkbox") {
      return Checkbox();
    } else if (type == "brand") {
      return Brand();
    } else {
      return TextField();
    }
  }

  String type;
  Map<String, String> title = {};
  Map<String, String> description = {};

  String? api;
  String? brand;

  TextEditingController controllerApi = TextEditingController();
  TextEditingController controllerIcon = TextEditingController();

  Map<String, dynamic> commit() {
    List<Map<String, String>> fieldTitle = [];
    List<Map<String, String>> fieldDesc = [];
    Map<String, dynamic> object = {
      "field_type": type,
      "api_name": controllerApi.text,
      "brand_icon": brand,
    };
    for (int j = 0; j < title.length; ++j) {
      fieldTitle.add(
          {"lang": title.keys.elementAt(j), "text": title.values.elementAt(j)});
    }
    object.addAll({
      "field_title": fieldTitle,
    });
    for (int j = 0; j < description.length; ++j) {
      fieldDesc.add({
        "lang": description.keys.elementAt(j),
        "text": description.values.elementAt(j)
      });
      object.addAll({
        "description": fieldDesc,
      });
    }
    return object;
  }

  @override
  State<AdminField> createState() => AdminFieldState();
}

class AdminFieldState extends State<AdminField> {
  AdminFieldState();

  @override
  Widget build(BuildContext context) {
    return const Text("Something got wrong");
  }
}

// ignore: must_be_immutable
class Front extends AdminField {
  Front({super.key, super.type = "front"});

  @override
  Map<String, dynamic> commit() {
    Map<String, dynamic> object = {
      "field_type": type,
    };
    List<Map<String, String>> fieldTitle = [];
    for (int j = 0; j < title.length; ++j) {
      fieldTitle.add(
          {"lang": title.keys.elementAt(j), "text": title.values.elementAt(j)});
    }
    object.addAll({
      "field_title": fieldTitle,
    });
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
    return object;
  }

  @override
  State<Front> createState() => FrontState();
}

class FrontState extends State<Front> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(children: [
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
        Column(
          children: [
            const Text("Podzagolovok"),
            TextFormField(
              onChanged: (value) => setState(() {
                widget.description.addAll({currentLang: value});
              }),
            ),
          ],
        ),
      ]),
    );
  }
}

// ignore: must_be_immutable
class TextField extends AdminField {
  TextField({super.key, super.type = "textfield"});

  Map<String, dynamic> commit() {
    Map<String, dynamic> object = {
      "field_type": type,
    };
    api = controllerApi.text;
    object.addAll({"api_name": api});
    List<Map<String, String>> fieldTitle = [];
    for (int j = 0; j < title.length; ++j) {
      fieldTitle.add(
          {"lang": title.keys.elementAt(j), "text": title.values.elementAt(j)});
    }
    object.addAll({
      "field_title": fieldTitle,
    });
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
    return object;
  }

  @override
  State<TextField> createState() => TextFieldState();
}

class TextFieldState extends State<TextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(children: [
        Padding(
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
        ),
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
        Column(
          children: [
            const Text("Podzagolovok"),
            TextFormField(
              onChanged: (value) => setState(() {
                widget.description.addAll({currentLang: value});
              }),
            ),
          ],
        ),
      ]),
    );
  }
}

// ignore: must_be_immutable
class Email extends AdminField {
  Email({super.key, super.type = "email"});

  Map<String, dynamic> commit() {
    Map<String, dynamic> object = {
      "field_type": type,
    };
    api = controllerApi.text;
    object.addAll({"api_name": api});
    List<Map<String, String>> fieldTitle = [];
    for (int j = 0; j < title.length; ++j) {
      fieldTitle.add(
          {"lang": title.keys.elementAt(j), "text": title.values.elementAt(j)});
    }
    object.addAll({
      "field_title": fieldTitle,
    });
    return object;
  }

  @override
  State<Email> createState() => EmailState();
}

class EmailState extends State<Email> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(children: [
        Padding(
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
        ),
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
      ]),
    );
  }
}

// ignore: must_be_immutable
class Number extends AdminField {
  Number({super.key, super.type = "number"});

  Map<String, dynamic> commit() {
    Map<String, dynamic> object = {
      "field_type": type,
    };
    api = controllerApi.text;
    object.addAll({"api_name": api});
    List<Map<String, String>> fieldTitle = [];
    for (int j = 0; j < title.length; ++j) {
      fieldTitle.add(
          {"lang": title.keys.elementAt(j), "text": title.values.elementAt(j)});
    }
    object.addAll({
      "field_title": fieldTitle,
    });
    return object;
  }

  @override
  State<Number> createState() => NumberState();
}

class NumberState extends State<Number> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(children: [
        Padding(
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
        ),
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
      ]),
    );
  }
}

// ignore: must_be_immutable
class Checkbox extends AdminField {
  Checkbox({super.key, super.type = "checkbox"});

  Map<String, dynamic> commit() {
    Map<String, dynamic> object = {
      "number": numerator,
      "field_type": type,
    };
    numerator++;
    api = controllerApi.text;
    object.addAll({"api_name": api});
    List<Map<String, String>> fieldTitle = [];
    for (int j = 0; j < title.length; ++j) {
      fieldTitle.add(
          {"lang": title.keys.elementAt(j), "text": title.values.elementAt(j)});
    }
    object.addAll({
      "field_title": fieldTitle,
    });
    return object;
  }

  @override
  State<Checkbox> createState() => CheckboxState();
}

class CheckboxState extends State<Checkbox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(children: [
        Padding(
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
        ),
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
      ]),
    );
  }
}

// ignore: must_be_immutable
class Brand extends AdminField {
  Brand({super.key, super.type = "Brand"});

  Map<String, dynamic> commit() {
    Map<String, dynamic> object = {
      "field_type": type,
    };
    api = controllerApi.text;
    object.addAll({"api_name": api});
    List<Map<String, String>> fieldTitle = [];
    for (int j = 0; j < title.length; ++j) {
      fieldTitle.add(
          {"lang": title.keys.elementAt(j), "text": title.values.elementAt(j)});
    }
    object.addAll({
      "field_title": fieldTitle,
    });
    object.addAll({"brand_icon": brand});
    return object;
  }

  @override
  State<Brand> createState() => BrandState();
}

class BrandState extends State<Brand> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(children: [
        Padding(
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
        ),
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
        Row(
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
      ]),
    );
  }

  Future<String> imgUrl() async {
    var response = json.decode(await sendImage(await pickfile(), "Brands"));
    return response["url"];
  }
}
