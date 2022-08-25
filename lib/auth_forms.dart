import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AuthForm extends StatefulWidget {
  String type;
  String title;
  dynamic data;
  String? description;

  AuthForm({
    super.key,
    required this.type,
    required this.title,
    this.description,
  });

  Map<String, String> commit() {
    return {"data": data};
  }

  factory AuthForm.createForm(String type, String title, String? description) {
    if (type == "email") {
      return Email(title: title);
    } else if (type == "number") {
      return Number(
        title: title,
      );
    } else if (type == "checkbox") {
      return CheckBox(
        title: title,
      );
    } else if (type == "brand") {
      return Brand(
        title: title,
      );
    } else {
      return TextField(
        title: title,
      );
    }
  }

  @override
  State<AuthForm> createState() => AuthFormState();
}

class AuthFormState extends State<AuthForm> {
  TextEditingController controller = TextEditingController();
  AuthFormState();

  @override
  Widget build(BuildContext context) {
    return const Text("Something went wrong");
  }
}

// ignore: must_be_immutable
class TextField extends AuthForm {
  TextField({
    super.key,
    required super.title,
    super.description,
  }) : super(type: "textfield");

  @override
  State<TextField> createState() => TextFieldState();
}

class TextFieldState extends State<TextField> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(widget.title),
          ),
          TextFormField(
            onChanged: (value) => setState(() {
              widget.data = value;
            }),
            controller: controller,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: widget.description,
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class Email extends AuthForm {
  Email({
    super.key,
    required super.title,
  }) : super(type: "email");

  @override
  State<Email> createState() => EmailState();
}

class EmailState extends State<Email> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(widget.title),
          ),
          TextFormField(
            onChanged: (value) => setState(() {
              widget.data = value;
            }),
            controller: controller,
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }
}

//ignore: must_be_immutable
class Number extends AuthForm {
  Number({
    super.key,
    required super.title,
  }) : super(type: "number");

  @override
  State<Number> createState() => NumberState();
}

class NumberState extends State<Number> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(widget.title),
          ),
          TextFormField(
            onChanged: (value) => setState(() {
              widget.data = value;
            }),
            controller: controller,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}

//ignore: must_be_immutable
class CheckBox extends AuthForm {
  CheckBox({
    super.key,
    required super.title,
  }) : super(type: "checkbox");

  @override
  State<CheckBox> createState() => CheckBoxState();
}

class CheckBoxState extends State<CheckBox> {
  bool accept = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Column(
        children: [
          Text(widget.title),
          Checkbox(
              value: accept,
              onChanged: (value) => setState(() {
                    accept = value!;
                  }))
        ],
      ),
    );
  }
}

//ignore: must_be_immutable
class Brand extends AuthForm {
  Brand({
    super.key,
    required super.title,
  }) : super(type: "brand");

  @override
  State<Brand> createState() => BrandState();
}

class BrandState extends State<Brand> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Column(
      children: [
        Text(widget.title),
        IconButton(
          iconSize: 50,
          icon: const Icon(
            Icons.abc,
          ),
          onPressed: () {
            debugPrint(widget.title);
          },
        ),
      ],
    ));
  }
}
