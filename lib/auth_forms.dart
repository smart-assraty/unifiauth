import 'package:flutter/material.dart';
import 'main.dart';

// ignore: must_be_immutable
class AuthForm extends StatefulWidget {
  late String type;
  late Map<String, dynamic> data;
  AuthForm({
    super.key,
    required this.type,
    required this.data,
  });

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
        child: Column(
          children: [
            Text(widget.data["title"]![currentLang]!),
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
        child: Column(
          children: [
            Text(widget.data["title"]![currentLang]!),
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
        child: Column(
          children: [
            Text(widget.data["title"]![currentLang]!),
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
        child: Column(
          children: [
            Text(widget.data["title"]![currentLang]!),
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 50,
              width: 150,
              child: ListView(
                children: [Text(widget.data["description"]![currentLang]!)],
              ),
            ),
          ],
        ),
      );
    }
  }
}
