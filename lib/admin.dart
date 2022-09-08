import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:routemaster/routemaster.dart';
import 'package:file_picker/file_picker.dart';

import 'server_connector.dart' show AdminHelper;
import 'main.dart';
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

  late String bgImage;
  late String logoImage;
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
    return Layout(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: getContent(),
      ),
    ));
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
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: "Login"),
                            controller: login,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Password",
                            ),
                            obscureText: true,
                            controller: password,
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                        style: buttonStyle,
                        onPressed: () async {
                          var send = (await adminHelper.login(
                              login.text, password.text))!;
                          token = await send.stream.bytesToString();
                          if (send.statusCode == 200) {
                            forms = await generateForms();
                            frontAdminField = (forms.last.getChild() as Front);
                            forms.removeLast();
                            setState(() {
                              stage = 1;
                            });
                          } else {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Invalid username or password")));
                          }
                        },
                        child: Text(
                          "Submit",
                          style: buttonText,
                        )),
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
                  child: const Center(child: Text("1")),
                ),
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
                  child: const Center(child: Text("2")),
                ),
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
                  child: const Center(child: Text("3")),
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
                        if (backgroundImage.runtimeType == FilePickerResult) {
                          bgImage = await adminHelper.sendImage(
                              backgroundImage, "UploadBGImage", token!, null);
                        }
                        if (backgroundImage.runtimeType == String) {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Failed to load file. Please try again")));
                        }
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
                        if (logo.runtimeType == FilePickerResult) {
                          logoImage = await adminHelper.sendImage(
                              logo, "UploadLogoImage", token!, null);
                        }
                        if (logo.runtimeType == String) {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Failed to load file. Please try again")));
                        }
                      }),
                ],
              ),
            ],
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                style: buttonStyle,
                onPressed: () {
                  setState(() {
                    stage = 2;
                  });
                },
                child: Text(
                  "Next",
                  style: buttonText,
                ),
              )),
        ],
      ),
    );
  }

  Widget contentPageTwo() {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      width: 400,
      child: Column(
        children: [
          contentHeader(),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: forms.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    forms[index],
                    const SizedBox(
                      height: 10,
                    )
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                    style: buttonStyle,
                    onPressed: () {
                      setState(() {
                        forms.add(AdminForm());
                      });
                    },
                    child: Text(
                      "Add new field",
                      style: buttonText,
                    )),
                OutlinedButton(
                    style: buttonStyle,
                    onPressed: () {
                      setState(() {
                        forms.removeLast();
                      });
                    },
                    child: Text(
                      "Remove field",
                      style: buttonText,
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                    style: buttonStyle,
                    onPressed: () => setState(() {
                          stage = 1;
                        }),
                    child: const Text(
                      "Back",
                      style: TextStyle(fontSize: 24, color: Colors.black),
                    )),
                OutlinedButton(
                    style: buttonStyle,
                    onPressed: () {
                      setState(() {
                        stage = 3;
                      });
                    },
                    child: const Text(
                      "Next",
                      style: TextStyle(fontSize: 24, color: Colors.black),
                    )),
              ],
            ),
          )
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
                style: buttonStyle,
                onPressed: () => setState(() {
                      stage = 2;
                    }),
                child: Text(
                  "Back",
                  style: buttonText,
                )),
            ElevatedButton(
              style: buttonStyle,
              onPressed: () async {
                try {
                  var formForAdminField = AdminForm();
                  formForAdminField.setChild(frontAdminField);
                  forms.add(formForAdminField);
                  theJson = await adminHelper.postToServer(bgImage, logoImage,
                      forms, languagelist, sendTo.text, token!);
                  setState(() {
                    stage = 4;
                  });
                } catch (e) {
                  forms.removeLast();
                  debugPrint("$e");
                }
              },
              child: Text(
                "Ready",
                style: buttonText,
              ),
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
        Text(bgImage),
        Text(logoImage),
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
                  Text(forms[index].getChild().brandIcon.toString()),
                ],
              );
            }),
        ElevatedButton(
            style: buttonStyle,
            onPressed: () => setState(() {
                  forms.clear();
                  stage = 1;
                  frontAdminField = Front();
                  sendTo.text = "";
                }),
            child: Text(
              "Back",
              style: buttonText,
            )),
        ElevatedButton(
            style: buttonStyle,
            onPressed: () => Routemaster.of(context).push("/guest/s/default/"),
            child: Text(
              "Auth",
              style: buttonText,
            )),
      ],
    );
  }
  //Test

  Future<List<AdminForm>> generateForms() async {
    var body = await adminHelper.getForms(token!);
    var getLangs = await adminHelper.getLangs();

    if (body != null) {
      bgImage = body["settings"]["bg_image"];
      logoImage = body["settings"]["logo_image"];
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
        String? apiName;
        String? brandIcon;
        String? apiValue;
        type = body["fields"][i]["type"];
        title = Map.from(body["fields"][i]["title"]);
        description = Map.from(body["fields"][i]["description"]);
        apiName = body["fields"][i]["api_name"];
        brandIcon = body["fields"][i]["brand_icon"];
        apiValue = body["fields"][i]["api_value"];
        apiName ??= "";

        formsFromServer.add(AdminForm.fromJson(
            type, numerator, title, description, apiName, brandIcon, apiValue));
        numerator++;
      }
      return formsFromServer;
    } else {
      bgImage = body["settings"]["bg_image"];
      logoImage = body["settings"]["logo_image"];
      languages = List.generate(
          getLangs.length,
          (index) => DropdownMenuItem<String>(
                value: getLangs[index],
                child: Text(getLangs[index]),
              ));
      return [AdminForm()..setChild(Front())];
    }
  }
}
