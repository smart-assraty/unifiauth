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

  factory AdminForm.fromJson(String type, dynamic title, dynamic description,
      String apiName, String? brand) {
    if (type == "email") {
      return AdminForm()..setChild(Email.fromJson(title, apiName));
    } else if (type == "number") {
      return AdminForm()..setChild(Number.fromJson(title, apiName));
    } else if (type == "checkbox") {
      return AdminForm()..setChild(Checkbox.fromJson(title, apiName));
    } else if (type == "brand") {
      return AdminForm()..setChild(Brand.fromJson(title, apiName));
    } else if (type == "front") {
      return AdminForm()..setChild(Front.fromJson(title, description!));
    } else {
      return AdminForm()
        ..setChild(TextField.fromJson(title, description!, apiName));
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
  String currentLang = languages[0];
  dynamic title;
  dynamic description;

  String? brand;

  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerDesc = TextEditingController();
  TextEditingController controllerApi = TextEditingController();
  TextEditingController controllerIcon = TextEditingController();

  Map<String, dynamic> commit() {
    List<Map<String, String>> fieldTitle = [];
    List<Map<String, String>> fieldDesc = [];

    for (int j = 0; j < title.length; ++j) {
      fieldTitle.add(
          {"lang": title.keys.elementAt(j), "text": title.values.elementAt(j)});
      fieldDesc.add({
        "lang": description.keys.elementAt(j),
        "text": description.values.elementAt(j)
      });
    }

    Map<String, dynamic> object = {
      "field_type": type,
      "api_name": controllerApi.text,
      "brand_icon": brand,
      "field_title": fieldTitle,
      "description": fieldDesc
    };

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
  Front({
    super.key,
    super.type = "front",
  });

  Front.fromJson(dynamic title, dynamic description, {Key? key})
      : super(key: key, type: "front") {
    super.title = title;
    super.description = description;
    super.controllerTitle.text = title.toString();
    super.controllerDesc.text = description.toString();
  }

  @override
  Map<String, dynamic> commit() {
    List<Map<String, String>> fieldTitle = [];
    List<Map<String, String>> fieldDesc = [];

    for (int j = 0; j < title.length; ++j) {
      fieldTitle.add(
          {"lang": title.keys.elementAt(j), "text": title.values.elementAt(j)});
      fieldDesc.add({
        "lang": description.keys.elementAt(j),
        "text": description.values.elementAt(j)
      });
    }

    Map<String, dynamic> object = {
      "field_type": type,
      "field_title": fieldTitle,
      "description": fieldDesc
    };
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
              itemCount: languages.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return TextButton(
                    onPressed: () {
                      setState(() {
                        super.widget.currentLang = languages[index];
                      });
                    },
                    child: Text(languages[index]));
              }),
        ),
        Column(
          children: [
            const Text("Zagolovok"),
            TextFormField(
              controller: super.widget.controllerTitle,
              onChanged: (value) => setState(() {
                widget.title.addAll({super.widget.currentLang: value});
              }),
            ),
          ],
        ),
        Column(
          children: [
            const Text("Podzagolovok"),
            TextFormField(
              controller: super.widget.controllerDesc,
              onChanged: (value) => setState(() {
                widget.description.addAll({super.widget.currentLang: value});
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

  TextField.fromJson(dynamic title, dynamic descripion, String apiName,
      {Key? key})
      : super(key: key, type: "textfield") {
    super.controllerApi.text = apiName;
    super.controllerTitle.text = title.toString();
    super.controllerDesc.text = descripion.toString();
    super.title = title;
    super.description = descripion;
  }

  @override
  Map<String, dynamic> commit() {
    List<Map<String, String>> fieldTitle = [];
    List<Map<String, String>> fieldDesc = [];

    for (int j = 0; j < title.length; ++j) {
      fieldTitle.add(
          {"lang": title.keys.elementAt(j), "text": title.values.elementAt(j)});
      fieldDesc.add({
        "lang": description.keys.elementAt(j),
        "text": description.values.elementAt(j)
      });
    }

    Map<String, dynamic> object = {
      "field_type": type,
      "api_name": controllerApi.text,
      "field_title": fieldTitle,
      "description": fieldDesc
    };
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
              itemCount: languages.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return TextButton(
                    onPressed: () {
                      setState(() {
                        super.widget.currentLang = languages[index];
                      });
                    },
                    child: Text(languages[index]));
              }),
        ),
        Column(
          children: [
            const Text("Zagolovok"),
            TextFormField(
              controller: super.widget.controllerTitle,
              onChanged: (value) => setState(() {
                widget.title.addAll({super.widget.currentLang: value});
              }),
            ),
          ],
        ),
        Column(
          children: [
            const Text("Podzagolovok"),
            TextFormField(
              controller: super.widget.controllerDesc,
              onChanged: (value) => setState(() {
                widget.description.addAll({super.widget.currentLang: value});
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

  Email.fromJson(dynamic title, String apiName, {Key? key})
      : super(key: key, type: "email") {
    super.controllerApi.text = apiName;
    super.controllerTitle.text = title.toString();
    super.title = title;
  }

  @override
  Map<String, dynamic> commit() {
    List<Map<String, String>> fieldTitle = [];

    for (int j = 0; j < title.length; ++j) {
      fieldTitle.add(
          {"lang": title.keys.elementAt(j), "text": title.values.elementAt(j)});
    }

    Map<String, dynamic> object = {
      "field_type": type,
      "api_name": controllerApi.text,
      "field_title": fieldTitle,
    };
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
              itemCount: languages.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return TextButton(
                    onPressed: () {
                      setState(() {
                        super.widget.currentLang = languages[index];
                      });
                    },
                    child: Text(languages[index]));
              }),
        ),
        Column(
          children: [
            const Text("Zagolovok"),
            TextFormField(
              controller: super.widget.controllerTitle,
              onChanged: (value) => setState(() {
                widget.title.addAll({super.widget.currentLang: value});
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

  Number.fromJson(dynamic title, String apiName, {Key? key})
      : super(key: key, type: "number") {
    super.controllerApi.text = apiName;
    super.controllerTitle.text = title.toString();
    super.title = title;
  }

  @override
  Map<String, dynamic> commit() {
    List<Map<String, String>> fieldTitle = [];

    for (int j = 0; j < title.length; ++j) {
      fieldTitle.add(
          {"lang": title.keys.elementAt(j), "text": title.values.elementAt(j)});
    }

    Map<String, dynamic> object = {
      "field_type": type,
      "api_name": controllerApi.text,
      "field_title": fieldTitle,
    };
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
              itemCount: languages.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return TextButton(
                    onPressed: () {
                      setState(() {
                        super.widget.currentLang = languages[index];
                      });
                    },
                    child: Text(languages[index]));
              }),
        ),
        Column(
          children: [
            const Text("Zagolovok"),
            TextFormField(
              controller: super.widget.controllerTitle,
              onChanged: (value) => setState(() {
                widget.title.addAll({super.widget.currentLang: value});
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

  Checkbox.fromJson(dynamic title, String apiName, {Key? key})
      : super(key: key, type: "checkbox") {
    super.controllerApi.text = apiName;
    super.controllerTitle.text = title.toString();
    super.title = title;
  }

  @override
  Map<String, dynamic> commit() {
    List<Map<String, String>> fieldTitle = [];

    for (int j = 0; j < title.length; ++j) {
      fieldTitle.add(
          {"lang": title.keys.elementAt(j), "text": title.values.elementAt(j)});
    }

    Map<String, dynamic> object = {
      "field_type": type,
      "api_name": controllerApi.text,
      "field_title": fieldTitle,
    };
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
              itemCount: languages.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return TextButton(
                    onPressed: () {
                      setState(() {
                        super.widget.currentLang = languages[index];
                      });
                    },
                    child: Text(languages[index]));
              }),
        ),
        Column(
          children: [
            const Text("Zagolovok"),
            TextFormField(
              controller: super.widget.controllerTitle,
              onChanged: (value) => setState(() {
                widget.title.addAll({super.widget.currentLang: value});
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
  Brand({super.key, super.type = "brand"});

  Brand.fromJson(dynamic title, String apiName, {Key? key})
      : super(key: key, type: "brand") {
    super.controllerApi.text = apiName;
    super.controllerTitle.text = title.toString();
    super.title = title;
  }

  @override
  Map<String, dynamic> commit() {
    List<Map<String, String>> fieldTitle = [];

    for (int j = 0; j < title.length; ++j) {
      fieldTitle.add(
          {"lang": title.keys.elementAt(j), "text": title.values.elementAt(j)});
    }

    Map<String, dynamic> object = {
      "field_type": type,
      "api_name": controllerApi.text,
      "brand_icon": brand,
      "field_title": fieldTitle,
    };
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
              itemCount: languages.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return TextButton(
                    onPressed: () {
                      setState(() {
                        super.widget.currentLang = languages[index];
                      });
                    },
                    child: Text(languages[index]));
              }),
        ),
        Column(
          children: [
            const Text("Zagolovok"),
            TextFormField(
              controller: super.widget.controllerTitle,
              onChanged: (value) => setState(() {
                widget.title.addAll({super.widget.currentLang: value});
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
