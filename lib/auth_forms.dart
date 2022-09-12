import 'package:flutter/material.dart';
import 'package:unifiapp/auth.dart';

import 'main.dart';

// ignore: must_be_immutable
abstract class AuthForm extends StatefulWidget {
  dynamic data;
  String apiKey;
  String type;
  String title;
  String? description;
  bool isRequired;

  AuthForm({
    super.key,
    required this.apiKey,
    required this.type,
    required this.title,
    this.description,
    required this.isRequired,
  });

  Map<String, dynamic> commit() {
    return {"type": type, "title": title, "api_name": apiKey, "value": data};
  }

  factory AuthForm.createForm(
      String type,
      String apiKey,
      String title,
      String? description,
      String? brand,
      String? apiValue,
      bool? isRequired,
      TextEditingController? controller) {
    if (type == "email") {
      return Email(
        title: title,
        apiKey: apiKey,
        controller: controller!,
        isRequired: isRequired!,
      );
    } else if (type == "number") {
      return Number(
        title: title,
        apiKey: apiKey,
        controller: controller!,
        isRequired: isRequired!,
      );
    } else if (type == "checkbox") {
      return CheckBox(
        title: title,
        apiKey: apiKey,
      );
    } else if (type == "brand") {
      return Brand(
        title: title,
        apiKey: apiKey,
        brand: brand!,
        apiValue: apiValue!,
        isRequired: isRequired!,
      );
    } else if (type == "front") {
      return Front(
        title: title,
        description: description,
      );
    } else {
      return TextField(
        apiKey: apiKey,
        title: title,
        description: description,
        controller: controller!,
        isRequired: isRequired!,
      );
    }
  }
}

// ignore: must_be_immutable
class Front extends AuthForm {
  Front(
      {super.key,
      super.apiKey = "",
      required super.description,
      required super.title,
      super.type = "front",
      super.isRequired = false});

  @override
  State<Front> createState() => FrontState();
}

class FrontState extends State<Front> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}

// ignore: must_be_immutable
class TextField extends AuthForm {
  TextField(
      {super.key,
      required super.apiKey,
      required super.title,
      required super.description,
      required this.controller,
      required super.isRequired})
      : super(type: "textfield");

  TextEditingController controller;

  @override
  Map<String, dynamic> commit() {
    data = controller.text;
    return {"type": type, "title": title, "api_name": apiKey, "value": data};
  }

  @override
  State<TextField> createState() => TextFieldState();
}

class TextFieldState extends State<TextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (widget.isRequired)
          ? (value) {
              if (value == null || value.isEmpty) {
                return "This field can not be empty";
              }
              return null;
            }
          : null,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
      controller: widget.controller,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          labelStyle: textStyle,
          hintStyle: textStyle,
          hintText: widget.description,
          labelText: widget.title),
    );
  }
}

// ignore: must_be_immutable
class Email extends AuthForm {
  Email(
      {super.key,
      required super.apiKey,
      required super.title,
      required this.controller,
      required super.isRequired})
      : super(type: "email");

  TextEditingController controller;

  @override
  Map<String, dynamic> commit() {
    data = controller.text;
    return {"type": type, "title": title, "api_name": apiKey, "value": data};
  }

  @override
  State<Email> createState() => EmailState();
}

class EmailState extends State<Email> {
  RegExp regExp = RegExp(
      "^[a-zA-Z0-9]+(?:\\.[a-zA-Z0-9]+)*@[a-zA-Z0-9]+(?:\\.[a-zA-Z0-9]+)*\$");
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (widget.isRequired && value == null) {
          return "Please enter your email";
        }
        if (value != null && !value.contains(regExp)) {
          return "Example: example@mail.com";
        }
        return null;
      },
      decoration: InputDecoration(labelText: widget.title),
      textInputAction: TextInputAction.next,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
      controller: widget.controller,
      keyboardType: TextInputType.emailAddress,
    );
  }
}

//ignore: must_be_immutable
class Number extends AuthForm {
  Number(
      {super.key,
      required super.apiKey,
      required super.title,
      required this.controller,
      required super.isRequired})
      : super(type: "number");

  TextEditingController controller;

  @override
  Map<String, dynamic> commit() {
    data = controller.text;
    return {"type": type, "title": title, "api_name": apiKey, "value": data};
  }

  @override
  State<Number> createState() => NumberState();
}

class NumberState extends State<Number> {
  RegExp regExp =
      RegExp("^[\\+]?[(]?[0-9]{3}[)]?[-\\s\\.]?[0-9]{3}[-\\s\\.]?[0-9]{4,6}\$");
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (widget.isRequired && value == null) {
          return "Please enter your email";
        }
        if (value != null && !value.contains(regExp)) {
          return "Example: 8 777 777 7777";
        }
        return null;
      },
      decoration: InputDecoration(labelText: widget.title),
      textInputAction: TextInputAction.next,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
      controller: widget.controller,
      keyboardType: TextInputType.number,
    );
  }
}

//ignore: must_be_immutable
class CheckBox extends AuthForm {
  CheckBox(
      {super.key,
      required super.apiKey,
      required super.title,
      super.isRequired = false})
      : super(type: "checkbox");

  @override
  State<CheckBox> createState() => CheckBoxState();
}

class CheckBoxState extends State<CheckBox> {
  bool accept = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Checkbox(
              value: accept,
              onChanged: (value) => setState(() {
                    FocusScope.of(context).requestFocus(FocusNode());
                    accept = value!;
                    widget.data = accept;
                  })),
          Text(
            widget.title,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}

//ignore: must_be_immutable
class Brand extends AuthForm {
  String apiValue;
  String brand;
  bool isPicked = false;
  Brand(
      {super.key,
      required super.apiKey,
      required super.title,
      required this.brand,
      required this.apiValue,
      required super.isRequired})
      : super(type: "brand");

  @override
  State<Brand> createState() => BrandState();
}

class BrandState extends State<Brand> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 90,
        width: 90,
        decoration: (widget.isPicked)
            ? const BoxDecoration(
                border: Border(
                bottom: BorderSide(color: Colors.amber, width: 2),
                top: BorderSide(color: Colors.amber, width: 2),
                right: BorderSide(color: Colors.amber, width: 2),
                left: BorderSide(color: Colors.amber, width: 2),
              ))
            : null,
        child: IconButton(
          iconSize: 90,
          icon: Image(
            image: NetworkImage("$server/img/${widget.brand}"),
          ),
          onPressed: () async {
            setState(() {
              FocusScope.of(context).requestFocus(FocusNode());
              (widget.isPicked)
                  ? widget.isPicked = false
                  : widget.isPicked = true;
              (widget.isPicked)
                  ? widget.data = widget.apiValue
                  : widget.data = null;
            });
          },
        ));
  }
}
