import 'package:flutter/material.dart';
import 'admin_forms.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => AdminPageState();
}

String response = "";

class AdminPageState extends State<AdminPage> {
  int stage = 1;
  String title = "";
  String description = "";
  /*String background = "";
  String icon = "";*/
  var a = AdminField.front();
  List<AdminForm> forms = [];
  TextEditingController sendTo = TextEditingController();
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
    return ListView(
      shrinkWrap: true,
      children: [
        const Text("Sent:"),
        ListView.builder(
            shrinkWrap: true,
            itemCount: response.split(',').length,
            itemBuilder: (context, index) {
              return Text(response.split(',')[index]);
            }),
        const Spacer(),
        ElevatedButton(
            onPressed: () => setState(() {
                  currentLang = "rus";
                  i = 0;
                  post.clear();
                  forms.clear();
                  stage = 1;
                  a = AdminField.front();
                  sendTo.text = "";
                }),
            child: const Text("Back"))
      ],
    );
  }

  Widget contentPageThree() {
    return Container(
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
              onPressed: () async {
                response = await postToServer();
                setState(() {
                  stage = 4;
                });
              },
              child: const Text("Ready"),
            ),
          ]),
        ],
      ),
    );
  }

  Future<String> postToServer() async {
    var b = AdminForm();
    b.setChild(a);
    forms.add(b);
    List<Map<String, dynamic>> list = [];
    for (int i = 0; i < forms.length; i++) {
      list.add(forms.elementAt(i).getChild().commit());
    }

    post.addAll({
      "login": "string",
      "settings": {
        "langs": languagelist,
        "count_langs": languagelist.length,
        "logo_img": "string",
        "bg_image": "string",
        "bg_color": null,
        "count_fields": forms.length
      },
      "fields": list,
      "langs": languagelist,
      "langs_count": languagelist.length,
      "fields_count": forms.length,
      "send_to": sendTo.text,
    });
    var request = await http.post(Uri.parse("$server:8000/LoginForm/"),
        headers: {
          "Content-type": "application/json",
        },
        body: json.encode(post));

    return request.body;
  }

  Widget contentPageTwo() {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      width: 350,
      child: ListView(
        children: [
          contentHeader(),
          Column(
            children: forms,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      forms.add(AdminForm());
                    });
                  },
                  child: const Text("Add new field")),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      forms.removeLast();
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
                  onPressed: () {
                    setState(() {
                      stage = 3;
                    });
                  },
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
                                  a = AdminField.front();
                                })),
                      );
                    },
                  ),
                  TextButton(
                      onPressed: () => setState(() {
                            languagelist
                                .add(languages[languagelist.length].value!);
                            a = AdminField.front();
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
                onPressed: () {
                  setState(() {
                    currentLang = "rus";
                    stage = 2;
                  });
                },
                child: const Text("Next"),
              )),
        ],
      ),
    );
  }
}
