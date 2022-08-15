//import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:routemaster/routemaster.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => AdminPageState();
}

class AdminPageState extends State<AdminPage> {
  TextEditingController controllerId = TextEditingController();
  TextEditingController controllerType = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SizedBox(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            bool isObscure = false;
                            return AlertDialog(
                              content: Column(
                                children: [
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Form ID"),
                                  ),
                                  TextField(
                                    keyboardType: TextInputType.number,
                                    controller: controllerId,
                                  ),
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Form Type"),
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    controller: controllerType,
                                  ),
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Form Name"),
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.name,
                                    controller: controllerName,
                                  ),
                                  Checkbox(
                                    value: isObscure,
                                    onChanged: (event) => setState(() {
                                      isObscure = event!;
                                    }),
                                  ),
                                  const Spacer(),
                                  /*ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          addToDB(CustomTextFormField(
                                            id: int.parse(controllerId.text),
                                            name: controllerName.text,
                                            type: controllerType.text,
                                          ));
                                          Routemaster.of(context).pop();
                                        });
                                      },
                                      child: const Text("Add Form")),*/
                                ],
                              ),
                            );
                          }),
                    },
                    child: const Text("Add Form"),
                  ),
                  /* ElevatedButton(
                    onPressed: () => setState(() async {
                      TextEditingController t = TextEditingController();
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Card(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: t,
                              ),
                            );
                          });
                      Routemaster.of(context).pop();
                      deleteForm(int.parse(t.text));
                    }),
                    child: const Text("Remove Last"),
                  )*/
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomTextFormField extends StatelessWidget {
  late int id;
  late String name;
  late String type;
  TextEditingController controller = TextEditingController();

  CustomTextFormField({
    super.key,
    required this.id,
    required this.name,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "type": type,
      "name": name,
    };
  }

  String getString() {
    return "id: $id, type: $type, name: $name\n";
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(name),
        ),
        TextFormField(
          controller: controller,
          textAlign: TextAlign.center,
          obscureText: (type == "password"),
        ),
      ]),
    );
  }
}
