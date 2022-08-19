import 'package:flutter/material.dart';
import 'custom_text_form_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String server = "http://185.125.88.30";

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => AdminPageState();
}

class AdminPageState extends State<AdminPage> {
  int stage = 1;
  bool name = false;
  bool email = false;
  bool num = false;
  bool company = false;
  List<String> languagelist = ["rus", "eng", "kaz"];
  List<CustomForm> fields = [];
  TextEditingController zag = TextEditingController();
  TextEditingController pod = TextEditingController();
  TextEditingController sendTo = TextEditingController();
  TextEditingController zagolovok = TextEditingController();
  TextEditingController podzagolovok = TextEditingController();
  Map<String, Map<String, dynamic>> post = {};
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
    return Text(post.toString());
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
              Column(
                children: [
                  const Text("Send these"),
                  Row(
                    children: [
                      Checkbox(
                          value: name,
                          onChanged: (bool? value) {
                            setState(() {
                              name = value!;
                            });
                          }),
                      const Text("name"),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          value: email,
                          onChanged: (bool? value) {
                            setState(() {
                              email = value!;
                            });
                          }),
                      const Text("email"),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          value: num,
                          onChanged: (bool? value) {
                            setState(() {
                              num = value!;
                            });
                          }),
                      const Text("num"),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          value: company,
                          onChanged: (bool? value) {
                            setState(() {
                              company = value!;
                            });
                          }),
                      const Text("company"),
                    ],
                  ),
                ],
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
                    for (int i = 0; i < fields.length; i++) {
                      Map<String, Map<String, dynamic>> map = {
                        "object[$i]": fields.elementAt(i).commit()
                      };
                      post.addAll(map);
                    }
                    Map<String, int> map = {"langs_count": languagelist.length};
                    post.addAll({"int": map});
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
                    debugPrint(fields.length.toString());
                  },
                  child: const Text("Add new field")),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      fields.removeLast();
                    });
                    debugPrint(fields.length.toString());
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
      height: 600,
      child: Column(
        children: [
          contentHeader(),
          Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    const Text("Языки"),
                    ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return DropdownButton<String>(
                            items: languages,
                            onChanged: (value) => setState(() {
                                  languagelist[index] = value!;
                                }));
                      },
                    ),
                    TextButton(
                        onPressed: () => languagelist
                            .add(languages[languagelist.length].value!),
                        child: const Text(
                          "Добавить язык +",
                          style: TextStyle(color: Colors.amber),
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return TextButton(
                          onPressed: () => setState(() {
                                currentLang = languages.elementAt(index).value!;
                              }),
                          child: Text(languages.elementAt(index).value!));
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 10),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Zagolovok"),
                    ),
                    SizedBox(
                      height: 35,
                      child: TextFormField(
                        controller: zag,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30, top: 10),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Podzagolovok"),
                    ),
                    SizedBox(
                      height: 35,
                      child: TextFormField(
                        controller: pod,
                      ),
                    ),
                  ],
                ),
              ),
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
        ],
      ),
    );
  }
}
