import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    show HtmlWidget;
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import 'server_connector.dart' show AdminHelper;
import 'admin_forms.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => AdminPageState();
}

List<DropdownMenuItem<dynamic>> languages = [];
List<dynamic> languagelist = ["rus"];
String? token;

class AdminPageState extends State<AdminPage> {
  AdminHelper adminHelper = AdminHelper();

  int numerator = 0;
  late String theJson;
  int stage = 0;
  late dynamic backgroundImage;
  late dynamic logo;
  var frontAdminField = Front();
  List<AdminForm> forms = [];

  TextEditingController sendTo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: getContent(),
      ),
    );
  }

  Widget getContent() {
    if (stage == 0) {
      return adminLogin();
    } else if (stage == 1) {
      return contentPageOne();
    } else if (stage == 2) {
      return contentPageTwo();
    } else if (stage == 3) {
      return contentPageThree();
    } else {
      return contentPageFour();
    }
  }

  Widget adminLogin() {
    TextEditingController login = TextEditingController();
    TextEditingController password = TextEditingController();
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/bg.jpeg"), fit: BoxFit.fill)),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Padding(
            padding: const EdgeInsets.only(top: 400),
            child: Column(
              children: const [
                Text(
                  "TechnoGym",
                  style: TextStyle(fontSize: 48),
                ),
                Text(
                  "The Wellness Company",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                )
              ],
            ),
          ),
          Container(
              height: 500,
              width: 350,
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      "Login to free-WiFi Admin",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Login"),
                      controller: login,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Password"),
                      obscureText: true,
                      controller: password,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          var send = await adminHelper.login(
                              login.text, password.text);
                          token = await send!.stream.bytesToString();
                          if (send.statusCode == 200) {
                            forms = await generateForms();
                            frontAdminField = (forms.last.getChild() as Front);
                            forms.removeLast();
                            setState(() {
                              stage = 1;
                            });
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Card(
                                    child: HtmlWidget(token.toString()),
                                  );
                                });
                          }
                        },
                        child: const Text("Submit")),
                  ],
                ),
              )),
        ]));
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
                    child: Center(
                      child: TextButton(
                          onPressed: () {
                            stage = 1;
                          },
                          child: const Text("1")),
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
                    child: Center(
                      child: TextButton(
                          onPressed: () {
                            stage = 2;
                          },
                          child: const Text("2")),
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
                  child: Center(
                    child: TextButton(
                        onPressed: () {
                          stage = 3;
                        },
                        child: const Text("3")),
                  ),
                ),
              ],
            ),
          ],
        ));
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
                          child: DropdownButton<dynamic>(
                              hint: Text(languagelist[index]),
                              items: languages,
                              onChanged: (value) {
                                setState(() {
                                  languagelist[index] = value!;
                                  frontAdminField = Front();
                                });
                              }));
                    },
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      languagelist.add(languages[languagelist.length].value!);
                      frontAdminField = Front();
                    });
                  },
                  child: const Text(
                    "Добавить язык +",
                    style: TextStyle(color: Colors.amber),
                  )),
              TextButton(
                  onPressed: () {
                    setState(() {
                      languagelist.removeLast();
                      frontAdminField = Front();
                    });
                  },
                  child: const Text(
                    "Remove language",
                    style: TextStyle(color: Colors.amber),
                  )),
            ],
          ),
          frontAdminField,
          Row(
            children: [
              Column(
                children: [
                  const Text("Background Image"),
                  IconButton(
                      icon: const Icon(
                        Icons.abc,
                      ),
                      onPressed: () async {
                        backgroundImage = await adminHelper.pickfile();
                        var result = await adminHelper.sendImage(
                            backgroundImage, "UploadBGImage", token!);
                        debugPrint(result);
                      }),
                ],
              ),
              const VerticalDivider(),
              Column(
                children: [
                  const Text("Icon"),
                  IconButton(
                      icon: const Icon(
                        Icons.abc,
                      ),
                      onPressed: () async {
                        logo = await adminHelper.pickfile();
                        await adminHelper.sendImage(
                            logo, "UploadLogoImage", token!);
                      }),
                ],
              ),
            ],
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    stage = 2;
                  });
                },
                child: const Text("Next"),
              )),
        ],
      ),
    );
  }

  Widget contentPageTwo() {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      width: 350,
      child: Column(
        children: [
          contentHeader(),
          SizedBox(
            height: 500,
            child: ListView(
              children: [Column(children: forms)],
            ),
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
                var formForAdminField = AdminForm();
                formForAdminField.setChild(frontAdminField);
                forms.add(formForAdminField);
                theJson = await adminHelper.postToServer(
                    forms, languagelist, sendTo.text, token!);
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

//Test
  Widget contentPageFour() {
    return ListView(
      shrinkWrap: true,
      children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: forms.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Text(forms[index].getChild().type),
                  Text(forms[index].getChild().controllerApi.text),
                  Text(forms[index].getChild().title.toString()),
                  Text(forms[index].getChild().description.toString()),
                ],
              );
            }),
        const Spacer(),
        ElevatedButton(
            onPressed: () => setState(() {
                  forms.clear();
                  stage = 1;
                  frontAdminField = Front();
                  sendTo.text = "";
                }),
            child: const Text("Back")),
        ElevatedButton(
            onPressed: () => Routemaster.of(context).push("/guest/s/default"),
            child: const Text("Auth")),
      ],
    );
  }
  //Test

  Future<List<AdminForm>> generateForms() async {
    var body = await adminHelper.getForms(token!);
    var getLangs = await adminHelper.getLangs();

    if (body != null) {
      languagelist.clear();
      languages.clear();

      languages = List.generate(
          getLangs.length,
          (index) => DropdownMenuItem<String>(
                value: getLangs[index],
                child: Text(getLangs[index]),
              ));

      for (int i = 0; i < body["settings"]["count_langs"]; i++) {
        languagelist.add(languages.elementAt(i).value!);
      }
      List<AdminForm> formsFromServer = [];
      sendTo.text = body["settings"]["api_url"];
      for (int i = 0; i < body["settings"]["count_fields"]; ++i) {
        String type = "";
        Map<String, dynamic> title;
        Map<String, dynamic> description;
        String? apiName = "";
        String? brand = "";
        type = body["fields"][i]["type"];
        title = Map.from(body["fields"][i]["title"]);
        description = Map.from(body["fields"][i]["description"]);
        apiName = body["fields"][i]["api_name"];
        brand = body["fields"][i]["brand_icon"];
        apiName ??= "";

        formsFromServer.add(AdminForm.fromJson(
            type, numerator, title, description, apiName, brand));
        numerator++;
      }
      return formsFromServer;
    } else {
      return [AdminForm()..setChild(Front())];
    }
  }
}
