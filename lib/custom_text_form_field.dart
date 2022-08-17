import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextFormField extends StatelessWidget {
  List<DropdownMenuItem> fields = [];
  late String type;
  late String api;
  late String name;
  late String hint;
  bool hasHint = false;
  bool hasIcon = false;
  TextEditingController controllerApi = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerHint = TextEditingController();
  TextEditingController controllerIcon = TextEditingController();

  CustomTextFormField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(color: Colors.grey),
      child: Column(children: [
        Row(
          children: [
            const Text("Type"),
            DropdownButton(items: fields, onChanged: null),
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
                  controller: controllerApi,
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
              child: TextFormField(controller: controllerName),
            ),
          ],
        ),
        (hasHint)
            ? Column(
                children: [
                  const Text("Podzagolovok"),
                  TextFormField(controller: controllerHint),
                ],
              )
            : const SizedBox(
                height: 1.0,
              ),
        (hasIcon)
            ? Row(
                children: [
                  const Icon(Icons.abc),
                  TextFormField(
                    controller: controllerIcon,
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
