import 'server_connector.dart' show AdminHelper;
import 'package:flutter/material.dart';
import 'admin.dart';

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

// ignore: must_be_immutable
abstract class AdminField extends StatefulWidget {
  AdminField({super.key, required this.type, required this.id});

  factory AdminField.createAdminField(String type) {
    if (type == "email") {
      return Email();
    } else if (type == "number") {
      return Number();
    } else if (type == "checkbox") {
      return CheckBox();
    } else if (type == "brand") {
      return Brand();
    } else {
      return Textfield();
    }
  }

  Color onSelected = Colors.amber;
  int id;
  bool isRequired = false;
  String type;
  String currentLang = languagelist[0];
  Map<String, dynamic> title = {};
  Map<String, dynamic> description = {};

  String? brandIcon;

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
      "number": id,
      "field_type": type,
      "api_name": controllerApi.text,
      "brand_icon": brandIcon,
      "field_title": fieldTitle,
      "description": fieldDesc
    };

    return object;
  }
}

// ignore: must_be_immutable
class Front extends AdminField {
  Front({
    super.key,
    super.type = "front",
    super.id = 0,
  });

  Front.fromJson(int id, dynamic title, dynamic description, {Key? key})
      : super(key: key, type: "front", id: id) {
    super.title = title;
    super.description = description;
    super.controllerTitle.text = title[currentLang];
    super.controllerDesc.text = description[currentLang];
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
      "number": id,
      "field_type": type,
      "field_title": fieldTitle,
      "api_name": "",
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
      child: Column(children: [
        SizedBox(
          height: 50,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: languagelist.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return TextButton(
                    onPressed: () {
                      setState(() {
                        super.widget.currentLang = languagelist[index];
                        (widget.title[widget.currentLang] != null)
                            ? super.widget.controllerTitle.text =
                                widget.title[widget.currentLang]!
                            : null;
                        (widget.description[widget.currentLang] != null)
                            ? super.widget.controllerDesc.text =
                                widget.description[widget.currentLang]!
                            : null;
                      });
                    },
                    child: Text(
                      languagelist[index],
                      style: TextStyle(
                          color: (widget.currentLang == languagelist[index])
                              ? widget.onSelected
                              : Colors.black),
                    ));
              }),
        ),
        Focus(
          onFocusChange: (value) {
            (value)
                ? null
                : widget.title
                    .addAll({widget.currentLang: widget.controllerTitle.text});
          },
          child: TextFormField(
            decoration: const InputDecoration(labelText: "Title"),
            controller: super.widget.controllerTitle,
          ),
        ),
        Focus(
          onFocusChange: (value) {
            (value)
                ? null
                : widget.description
                    .addAll({widget.currentLang: widget.controllerDesc.text});
          },
          child: TextFormField(
            decoration: const InputDecoration(labelText: "Description"),
            controller: super.widget.controllerDesc,
          ),
        ),
      ]),
    );
  }
}

// ignore: must_be_immutable
class Textfield extends AdminField {
  Textfield({
    super.key,
    super.type = "textfield",
    super.id = 0,
  });

  Textfield.fromJson(int id, Map<String, dynamic> title, dynamic descripion,
      String apiName, bool isRequired,
      {Key? key})
      : super(key: key, type: "textfield", id: id) {
    super.title = title;
    super.description = descripion;
    super.controllerApi.text = apiName;
    super.controllerTitle.text = super.title[currentLang]!;
    super.controllerDesc.text = super.description[currentLang]!;
    super.isRequired = isRequired;
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
      "number": id,
      "field_type": type,
      "api_name": controllerApi.text,
      "field_title": fieldTitle,
      "description": fieldDesc,
      "required_field": isRequired.toString()
    };
    return object;
  }

  @override
  State<Textfield> createState() => TextFieldState();
}

class TextFieldState extends State<Textfield> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(children: [
        Row(
          children: [
            Checkbox(
              value: widget.isRequired,
              onChanged: (value) {
                setState(() {
                  widget.isRequired = value!;
                });
              },
            ),
            const Text("Required"),
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 10),
              child: SizedBox(
                width: 250,
                height: 40,
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "Key"),
                  controller: widget.controllerApi,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 50,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: languagelist.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return TextButton(
                    onPressed: () {
                      setState(() {
                        super.widget.currentLang = languagelist[index];
                        (widget.title[widget.currentLang] != null)
                            ? widget.controllerTitle.text =
                                widget.title[widget.currentLang]!
                            : null;
                        (widget.description[widget.currentLang] != null)
                            ? super.widget.controllerDesc.text =
                                widget.description[widget.currentLang]!
                            : null;
                      });
                    },
                    child: Text(
                      languagelist[index],
                      style: TextStyle(
                          color: (widget.currentLang == languagelist[index])
                              ? widget.onSelected
                              : Colors.black),
                    ));
              }),
        ),
        Focus(
          onFocusChange: (value) {
            (value)
                ? null
                : widget.title
                    .addAll({widget.currentLang: widget.controllerTitle.text});
          },
          child: TextFormField(
            decoration: const InputDecoration(labelText: "Title"),
            controller: super.widget.controllerTitle,
          ),
        ),
        Focus(
          onFocusChange: (value) {
            (value)
                ? null
                : widget.description
                    .addAll({widget.currentLang: widget.controllerDesc.text});
          },
          child: TextFormField(
            decoration: const InputDecoration(labelText: "Description"),
            controller: super.widget.controllerDesc,
          ),
        ),
      ]),
    );
  }
}

// ignore: must_be_immutable
class Email extends AdminField {
  Email({super.key, super.type = "email", super.id = 0});

  Email.fromJson(int id, dynamic title, String apiName, bool isRequired,
      {Key? key})
      : super(key: key, type: "email", id: id) {
    super.controllerApi.text = apiName;
    super.controllerTitle.text = title[currentLang];
    super.title = title;
    super.isRequired = isRequired;
  }

  @override
  Map<String, dynamic> commit() {
    List<Map<String, String>> fieldTitle = [];

    for (int j = 0; j < title.length; ++j) {
      fieldTitle.add(
          {"lang": title.keys.elementAt(j), "text": title.values.elementAt(j)});
    }

    Map<String, dynamic> object = {
      "number": id,
      "field_type": type,
      "api_name": controllerApi.text,
      "field_title": fieldTitle,
      "required_field": isRequired.toString(),
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
      child: Column(children: [
        Row(
          children: [
            Checkbox(
              value: widget.isRequired,
              onChanged: (value) {
                setState(() {
                  widget.isRequired = value!;
                });
              },
            ),
            const Text("Required"),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SizedBox(
                width: 250,
                height: 40,
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "Key"),
                  controller: widget.controllerApi,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 50,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: languagelist.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return TextButton(
                    onPressed: () {
                      setState(() {
                        super.widget.currentLang = languagelist[index];
                        (widget.title[widget.currentLang] != null)
                            ? widget.controllerTitle.text =
                                widget.title[widget.currentLang]!
                            : null;
                        (widget.description[widget.currentLang] != null)
                            ? super.widget.controllerDesc.text =
                                widget.description[widget.currentLang]!
                            : null;
                      });
                    },
                    child: Text(
                      languagelist[index],
                      style: TextStyle(
                          color: (widget.currentLang == languagelist[index])
                              ? widget.onSelected
                              : Colors.black),
                    ));
              }),
        ),
        Focus(
          onFocusChange: (value) {
            (value)
                ? null
                : widget.title
                    .addAll({widget.currentLang: widget.controllerTitle.text});
          },
          child: TextFormField(
            decoration: const InputDecoration(labelText: "Title"),
            controller: super.widget.controllerTitle,
          ),
        ),
      ]),
    );
  }
}

// ignore: must_be_immutable
class Number extends AdminField {
  Number({
    super.key,
    super.type = "number",
    super.id = 0,
  });

  Number.fromJson(int id, dynamic title, String apiName, bool isRequired,
      {Key? key})
      : super(key: key, type: "number", id: id) {
    super.controllerApi.text = apiName;
    super.controllerTitle.text = title[currentLang];
    super.title = title;
    super.isRequired = isRequired;
  }

  @override
  Map<String, dynamic> commit() {
    List<Map<String, String>> fieldTitle = [];

    for (int j = 0; j < title.length; ++j) {
      fieldTitle.add(
          {"lang": title.keys.elementAt(j), "text": title.values.elementAt(j)});
    }

    Map<String, dynamic> object = {
      "number": id,
      "field_type": type,
      "api_name": controllerApi.text,
      "field_title": fieldTitle,
      "required_field": isRequired.toString(),
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
      child: Column(children: [
        Row(
          children: [
            Checkbox(
              value: widget.isRequired,
              onChanged: (value) {
                setState(() {
                  widget.isRequired = value!;
                });
              },
            ),
            const Text("Required"),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SizedBox(
                width: 250,
                height: 40,
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "Key"),
                  controller: widget.controllerApi,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 50,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: languagelist.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return TextButton(
                    onPressed: () {
                      setState(() {
                        super.widget.currentLang = languagelist[index];
                        (widget.title[widget.currentLang] != null)
                            ? widget.controllerTitle.text =
                                widget.title[widget.currentLang]!
                            : null;
                      });
                    },
                    child: Text(
                      languagelist[index],
                      style: TextStyle(
                          color: (widget.currentLang == languagelist[index])
                              ? widget.onSelected
                              : Colors.black),
                    ));
              }),
        ),
        Focus(
          onFocusChange: (value) {
            (value)
                ? null
                : widget.title
                    .addAll({widget.currentLang: widget.controllerTitle.text});
          },
          child: TextFormField(
            decoration: const InputDecoration(labelText: "Title"),
            controller: super.widget.controllerTitle,
          ),
        ),
      ]),
    );
  }
}

// ignore: must_be_immutable
class CheckBox extends AdminField {
  CheckBox({super.key, super.type = "checkbox", super.id = 0});

  CheckBox.fromJson(int id, dynamic title, String apiName, {Key? key})
      : super(key: key, type: "checkbox", id: id) {
    super.controllerApi.text = apiName;
    super.controllerTitle.text = title[currentLang];
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
      "number": id,
      "field_type": type,
      "api_name": controllerApi.text,
      "field_title": fieldTitle,
      "required_field": isRequired.toString(),
    };
    return object;
  }

  @override
  State<CheckBox> createState() => CheckBoxState();
}

class CheckBoxState extends State<CheckBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(children: [
        Row(
          children: [
            Checkbox(
              value: widget.isRequired,
              onChanged: (value) {
                setState(() {
                  widget.isRequired = value!;
                });
              },
            ),
            const Text("Required"),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SizedBox(
                width: 250,
                height: 40,
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "Key"),
                  controller: widget.controllerApi,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 50,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: languagelist.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return TextButton(
                    onPressed: () {
                      setState(() {
                        super.widget.currentLang = languagelist[index];
                        (widget.title[widget.currentLang] != null)
                            ? widget.controllerTitle.text =
                                widget.title[widget.currentLang]!
                            : null;
                      });
                    },
                    child: Text(
                      languagelist[index],
                      style: TextStyle(
                          color: (widget.currentLang == languagelist[index])
                              ? widget.onSelected
                              : Colors.black),
                    ));
              }),
        ),
        Focus(
          onFocusChange: (value) {
            (value)
                ? null
                : widget.title
                    .addAll({widget.currentLang: widget.controllerTitle.text});
          },
          child: TextFormField(
            decoration: const InputDecoration(labelText: "Title"),
            controller: super.widget.controllerTitle,
          ),
        ),
      ]),
    );
  }
}

// ignore: must_be_immutable
class Brand extends AdminField {
  Brand({
    super.key,
    super.type = "brand",
    super.id = 0,
  });

  Brand.fromJson(
      int id, dynamic title, String apiName, String? brandIcon, String apiValue,
      {Key? key})
      : super(key: key, type: "brand", id: id) {
    super.controllerApi.text = apiName;
    super.controllerTitle.text = title[currentLang];
    super.title = title;
    super.brandIcon = brandIcon;
    super.controllerIcon.text = apiValue;
  }

  @override
  Map<String, dynamic> commit() {
    List<Map<String, String>> fieldTitle = [];

    for (int j = 0; j < title.length; ++j) {
      fieldTitle.add(
          {"lang": title.keys.elementAt(j), "text": title.values.elementAt(j)});
    }

    Map<String, dynamic> object = {
      "number": id,
      "field_type": type,
      "api_name": controllerApi.text,
      "brand_icon": brandIcon,
      "field_title": fieldTitle,
      "api_value": controllerIcon.text,
      "required_field": isRequired.toString(),
    };
    return object;
  }

  @override
  State<Brand> createState() => BrandState();
}

class BrandState extends State<Brand> {
  AdminHelper adminHelper = AdminHelper();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(children: [
        Row(
          children: [
            Checkbox(
              value: widget.isRequired,
              onChanged: (value) {
                setState(() {
                  widget.isRequired = value!;
                });
              },
            ),
            const Text("Required"),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SizedBox(
                width: 250,
                height: 40,
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "Key"),
                  controller: widget.controllerApi,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 50,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: languagelist.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return TextButton(
                    onPressed: () {
                      setState(() {
                        super.widget.currentLang = languagelist[index];
                        (widget.title[widget.currentLang] != null)
                            ? widget.controllerTitle.text =
                                widget.title[widget.currentLang]!
                            : null;
                      });
                    },
                    child: Text(
                      languagelist[index],
                      style: TextStyle(
                          color: (widget.currentLang == languagelist[index])
                              ? widget.onSelected
                              : Colors.black),
                    ));
              }),
        ),
        Focus(
          onFocusChange: (value) {
            (value)
                ? null
                : widget.title
                    .addAll({widget.currentLang: widget.controllerTitle.text});
          },
          child: TextFormField(
            decoration: const InputDecoration(labelText: "Title"),
            controller: widget.controllerTitle,
          ),
        ),
        Row(
          children: [
            IconButton(
                onPressed: () async {
                  var response = await adminHelper.pickfile();
                  if (response == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content:
                            Text("Failed to load file. Please try again")));
                  }
                  widget.brandIcon = await adminHelper.sendImage(
                      response, "UploadBrandImage", token!, widget.id);
                },
                icon: const Icon(Icons.abc)),
            SizedBox(
              width: 100,
              child: Focus(
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "API Value"),
                  controller: widget.controllerIcon,
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }
}
