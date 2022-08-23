import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AuthForm extends StatefulWidget {
  late String type;
  late String title;
  String? description;
  AuthForm({
    super.key,
    required this.type,
    required this.title,
    this.description,
  });

  factory AuthForm.fromJson(Map<String, dynamic> json) {
    return AuthForm(
      type: json["field_type"],
      title: json["field_title"],
      description: json["description"],
    );
  }

  @override
  State<AuthForm> createState() => AuthFormState();
}

class AuthFormState extends State<AuthForm> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.type == "email") {
      return SizedBox(
        width: 250,
        height: 150,
        child: Column(
          children: [
            Text(widget.title),
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
      );
    } else if (widget.type == "number") {
      return SizedBox(
        width: 250,
        height: 150,
        child: Column(
          children: [
            Text(widget.title),
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      );
    } else if (widget.type == "checkbox") {
      bool b = false;
      return SizedBox(
        width: 250,
        height: 50,
        child: Column(
          children: [
            Text(widget.title),
            Checkbox(
                value: b,
                onChanged: (value) => setState(() {
                      b = value!;
                    }))
          ],
        ),
      );
    } else if (widget.type == "brand") {
      return const SizedBox(
        width: 50,
        height: 50,
        child: IconButton(
          icon: Icon(Icons.abc),
          onPressed: null,
        ),
      );
    } else {
      return SizedBox(
        width: 250,
        height: 250,
        child: Column(
          children: [
            Text(widget.title),
            TextFormField(
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
}
