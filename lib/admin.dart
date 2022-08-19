import 'package:flutter/material.dart';
import 'custom_text_form_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String server = "http://185.125.88.30";
String currentLang = "rus";
List<DropdownMenuItem<String>> languages = [
  const DropdownMenuItem(value: "rus", child: Text("rus")),
  const DropdownMenuItem(value: "eng", child: Text("eng")),
  const DropdownMenuItem(value: "kaz", child: Text("kaz")),
  const DropdownMenuItem(value: "ita", child: Text("ita")),
  const DropdownMenuItem(value: "tur", child: Text("tur")),
  const DropdownMenuItem(value: "uzb", child: Text("uzb")),
];
List<String> languagelist = ["rus", "eng", "kaz"];

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => AdminPageState();
}

class AdminPageState extends State<AdminPage> {
  int stage = 1;
  String title = "";
  String description = "";
  /*String background = "";
  String icon = "";*/
  var a = CustomForm.front();
  List<CustomForm> fields = [];
  TextEditingController sendTo = TextEditingController();
  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  Map<String, dynamic> post = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Admin Panel"),
      ),
      body: Center(
        child: getContent(),
      ),
    );
  }

  Widget getContent() {
    if (stage == 1) {
      return contentPageOne();
    } else if (stage == 2) {
      return contentPageTwo();
    } else if (stage == 3) {
      return contentPageThree();
    } else {
      return contentPageFour();
    }
  }

  Widget contentHeader() {
    return Padding(
        padding: const EdgeInsets.only(
          bottom: 10,
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text("Настройка формы"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1000),
                      color: Colors.white,
                      border: Border.all(
                          width: 2,
                          color: (stage == 1) ? Colors.amber : Colors.grey),
                    ),
                    child: const Center(
                      child: Text("1"),
                    )),
                Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white,
                      border: Border.all(
                          width: 2,
                          color: (stage == 2) ? Colors.amber : Colors.grey),
                    ),
                    child: const Center(
                      child: Text("2"),
                    )),
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.white,
                    border: Border.all(
                        width: 2,
                        color: (stage == 3) ? Colors.amber : Colors.grey),
                  ),
                  child: const Center(
                    child: Text("3"),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget contentPageFour() {
    return Column(
      children: [
        const Text("Sent:"),
        ListView.builder(
            shrinkWrap: true,
            itemCount: post.entries.length,
            itemBuilder: (context, index) {
              return Text(post.entries.elementAt(index).toString());
            }),
        Text(json.encode(post)),
      ],
    );
  }

  Widget contentPageThree() {
    return ListView(
      shrinkWrap: true,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 20),
          width: 350,
          height: 600,
          child: Column(
            children: [
              contentHeader(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    const Text("Send form to"),
                    SizedBox(
                      height: 40,
                      child: TextFormField(
                        controller: sendTo,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                ElevatedButton(
                    onPressed: () => setState(() {
                          stage = 2;
                        }),
                    child: const Text("Back")),
                ElevatedButton(
                  onPressed: () {
                    fields.add(a);
                    for (int i = 0; i < fields.length; i++) {
                      Map<String, Map<String, dynamic>> map = {
                        "object[$i]": fields.elementAt(i).commit()
                      };
                      post.addAll(map);
                    }
                    post.addAll({
                      "langs": languagelist,
                      "langs_count": languagelist.length,
                      "fields_count": fields.length,
                      "send_to": sendTo.text,
                    });
                    /*http.post(Uri.parse("$server:27017"),
                        headers: {
                          "Content-type": "application/json",
                        },
                        body: json.encode(post));*/
                    setState(() {
                      stage = 4;
                    });
                  },
                  child: const Text("Ready"),
                ),
              ]),
            ],
          ),
        ),
      ],
    );
  }

  Widget contentPageTwo() {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      width: 350,
      child: ListView(
        shrinkWrap: true,
        children: [
          contentHeader(),
          Column(
            children: fields,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      fields.add(CustomForm());
                    });
                  },
                  child: const Text("Add new field")),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      fields.removeLast();
                    });
                  },
                  child: const Text("Remove field")),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () => setState(() {
                        stage = 1;
                      }),
                  child: const Text("Back")),
              ElevatedButton(
                  onPressed: () => setState(() {
                        stage = 3;
                      }),
                  child: const Text("Next")),
            ],
          ),
        ],
      ),
    );
  }

  Widget contentPageOne() {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      width: 350,
      height: 610,
      child: ListView(
        shrinkWrap: true,
        children: [
          contentHeader(),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Языки"),
                  ListView.builder(
                    itemCount: languagelist.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: 35,
                        child: DropdownButton<String>(
                            hint: Text(languages[index].value!),
                            items: languages,
                            onChanged: (value) => setState(() {
                                  languagelist[index] = value!;
                                })),
                      );
                    },
                  ),
                  TextButton(
                      onPressed: () => setState(() {
                            languagelist
                                .add(languages[languagelist.length].value!);
                          }),
                      child: const Text(
                        "Добавить язык +",
                        style: TextStyle(color: Colors.amber),
                      ))
                ],
              ),
            ),
          ),
          a,
          Row(
            children: [
              Column(
                children: const [
                  Text("Background Image"),
                  Icon(
                    Icons.abc,
                    size: 80,
                  ),
                ],
              ),
              Column(
                children: const [
                  Text("Background Image"),
                  Icon(Icons.abc, size: 80),
                ],
              ),
              const VerticalDivider(),
              Column(
                children: const [
                  Text("Logo"),
                  Icon(Icons.abc, size: 80),
                ],
              ),
            ],
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () => setState(() {
                  stage = 2;
                }),
                child: const Text("Next"),
              )),
        ],
      ),
    );
  }
}
