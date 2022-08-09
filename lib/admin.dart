import 'dart:async';
import 'package:flutter/material.dart';

List<Widget> forms = [];

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});
  static String routeName = "/admin";
  @override
  State<AdminPage> createState() => AdminPageState();
}

class AdminPageState extends State<AdminPage> {
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
                                        forms.add(CustomTextFormField(
                                          name: controllerName.text,
                                          hintText: controllerHintText.text,
                                          isObscure: isObscure,
                                        ));
                                        Navigator.pop(context);
                                        debugPrint(forms.length.toString());
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
}

// ignore: must_be_immutable
class CustomTextFormField extends StatelessWidget {
  late String name;
  bool isObscure = false;
  late String hintText;

  CustomTextFormField(
      {super.key,
      required this.name,
      required this.hintText,
      required this.isObscure});
  TextEditingController controller = TextEditingController();
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
          obscureText: isObscure,
          decoration: InputDecoration(
            hintText: hintText,
          ),
        ),
      ]),
    );
  }
}

List<Widget> getForms() {
  return forms;
}
