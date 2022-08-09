import 'dart:async';

import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});
  @override
  State<AdminPage> createState() => AdminPageState();
}

class AdminPageState extends State<AdminPage> {
  List<Widget> forms = [];
  StreamController controller = StreamController<int>();
  @override
  Widget build(BuildContext context) {
    TextEditingController controllerType = TextEditingController();
    TextEditingController controllerName = TextEditingController();
    TextEditingController controllerHintText = TextEditingController();
    Stream stream = controller.stream;
    controller.add(forms.length);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel"),
      ),
      body: Column(
        children: [
          Container(
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 188, 219, 247)),
            height: 600,
            width: 550,
            child: StreamBuilder(
                stream: stream,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return Column(
                    children: forms,
                  );
                }),
          ),
          SizedBox(
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
                                  child: Text("Form Type"),
                                ),
                                TextFormField(
                                  controller: controllerType,
                                ),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Form Name"),
                                ),
                                TextFormField(
                                  controller: controllerName,
                                ),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Form HintText"),
                                ),
                                TextFormField(
                                  controller: controllerHintText,
                                ),
                                Checkbox(
                                  value: isObscure,
                                  onChanged: (event) => setState(() {
                                    isObscure = event!;
                                  }),
                                ),
                                const Spacer(),
                                ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        forms.add(customTextFormField(
                                            controllerName.text,
                                            controllerHintText.text,
                                            isObscure,
                                            (controllerType.text == "Email")
                                                ? true
                                                : false));
                                        Navigator.pop(context);
                                        debugPrint(forms.length.toString());
                                        //(context as Element).reassemble();
                                      });
                                    },
                                    child: const Text("Add Form")),
                              ],
                            ),
                          );
                        }),
                  },
                  child: const Text("Add Form"),
                ),
                ElevatedButton(
                  onPressed: () => setState(() {
                    forms.removeLast();
                  }),
                  child: const Text("Remove Last"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  SizedBox customTextFormField(
      String name, String? hintText, bool? isObscure, bool? isEmail) {
    return SizedBox(
      child: Column(children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(name),
        ),
        TextFormField(
          textAlign: TextAlign.center,
          obscureText: (isObscure == null) ? false : true,
          decoration: InputDecoration(
            hintText: hintText,
          ),
        ),
      ]),
    );
  }
}
