import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'dart:convert';
import 'dart:html';

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

  late Future<List<AdminForm>> generator;
  late Future<dynamic> futureBody;
  late Future<List<dynamic>> futureLangs;
  late String bgImage;
  late String logoImage;
  late String theJson;
  int stage = 0;
  late dynamic backgroundImage;
  late dynamic logo;
  List<AdminForm> forms = [];
  AdminForm frontForm = AdminForm()..setChild(Front());

  TextEditingController sendTo = TextEditingController();

  @override
  void initState() {
    super.initState();
    try {
      if (document.cookie!.isNotEmpty &&
          document.cookie!.contains("expires") &&
          document.cookie!.contains("token_type") &&
          document.cookie!.contains("access_token")) {
        String expires = json.decode(document.cookie!)["expires"];
        if (DateTime.parse(expires).isAfter(DateTime.now())) {
          try {
            token = document.cookie;
            futureBody = adminHelper.getForms(token!);
            futureLangs = adminHelper.getLangs();
          } catch (e) {
            debugPrint("on InitState: $e");
          }
          stage = 1;
        }
      }
      generator = generateForms(futureBody, futureLangs);
    } catch (e) {
      debugPrint("on Generator fail: $e");
      stage = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
        child: (stage == 0)
            ? Scaffold(
                body: Center(
                child: adminLogin(),
              ))
            : Scaffold(
                appBar: AppBar(
                    backgroundColor: Colors.black,
                    centerTitle: false,
                    title: Row(children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text("Admin"),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: () {
                          setState(() {
                            stage = 4;
                          });
                        },
                        child: const Text(
                          'Change Password',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 18),
                        ),
                      ),
                    ])),
                backgroundColor: const Color.fromARGB(255, 242, 242, 246),
                body: Center(
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 15, color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: getContent()),
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
    } else if (stage == 4) {
      return contentPagePasswordChange();
    } else {
      return adminLogin();
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
                          try {
                            var send = (await adminHelper.login(
                                login.text, password.text))!;
                            token = await send.stream.bytesToString();
                            if (send.statusCode == 200) {
                              try {
                                //document.cookie = token;
                                futureBody = adminHelper.getForms(token!);
                                futureLangs = adminHelper.getLangs();
                                generator =
                                    generateForms(futureBody, futureLangs);
                              } catch (e) {
                                debugPrint("on adminLogin: $e");
                              }
                              setState(() {
                                stage = 1;
                              });
                            } else {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Invalid username or password")));
                            }
                          } catch (e) {
                            debugPrint("$e");
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
          bottom: 20,
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      "Настройка формы ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18), //
                    )),
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
                    color: (stage > 1) ? Colors.amber : Colors.white,
                    border: Border.all(width: 2, color: Colors.amber),
                  ),
                  child: Center(
                      child: (stage > 1)
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                            )
                          : const Text("1")),
                ),
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: (stage > 2) ? Colors.amber : Colors.white,
                    border: Border.all(
                        width: 2,
                        color: (stage == 2)
                            ? Colors.amber
                            : (stage > 2)
                                ? Colors.amber
                                : Colors.grey),
                  ),
                  child: Center(
                      child: (stage > 2)
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                            )
                          : const Text("2")),
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
    return FutureBuilder(
        future: generator,
        builder: (context, AsyncSnapshot<List<AdminForm>> snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            forms = snapshot.data!;
            for (int i = 0; i < forms.length; i++) {
              if (forms[i].adminField.type == "front") {
                frontForm = forms[i];
                forms.remove(forms[i]);
              }
            }

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
                          const Text("Langs"),
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
                                          frontForm = AdminForm()
                                            ..setChild(Front());
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
                              languagelist
                                  .add(languages[languagelist.length].value!);
                              futureBody.then((value) =>
                                  ++value["settings"]["count_langs"]);
                              frontForm = AdminForm()..setChild(Front());
                            });
                          },
                          child: const Text(
                            "Add language +",
                            style: TextStyle(color: Colors.amber),
                          )),
                      TextButton(
                          onPressed: () async {
                            setState(() {
                              futureBody.then((value) =>
                                  --value["settings"]["count_langs"]);
                              for (var element in forms) {
                                element.adminField.title
                                    .remove(languagelist.last.toString());
                              }
                              languagelist.removeLast();
                              frontForm = AdminForm()..setChild(Front());
                            });
                          },
                          child: const Text(
                            "Remove language",
                            style: TextStyle(color: Colors.amber),
                          )),
                    ],
                  ),
                  frontForm,
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
                                if (backgroundImage.runtimeType ==
                                    FilePickerResult) {
                                  bgImage = await adminHelper.sendImage(
                                      backgroundImage,
                                      "UploadBGImage",
                                      token!,
                                      null);
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
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.amber,
              ),
            );
          }
        });
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
                if (forms[index].adminField.type == "front") {
                  return const SizedBox();
                }
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
                        forms.add(AdminForm()
                          ..adminField.id = forms.last.adminField.id + 1);
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
                      if (forms.contains(frontForm)) {
                        forms.remove(frontForm);
                      }
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
                  forms.add(frontForm);
                  theJson = await adminHelper.postToServer(bgImage, logoImage,
                      forms, languagelist, sendTo.text, token!);
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(theJson)));
                } catch (e) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("$e")));
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

  final _passwordChangeFormkey = GlobalKey<FormState>();
  final passwordChangeControllerUsername = TextEditingController();
  final passwordChangeControllerOldPassword = TextEditingController();
  final passwordChangeControllerNewPassword = TextEditingController();
  final passwordChangeControllerRepeatPassword = TextEditingController();
  bool sendPasswordEnabled = false;
  Widget contentPagePasswordChange() {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      width: 350,
      height: 600,
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FocusTraversalGroup(
                child: Form(
                  key: _passwordChangeFormkey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Wrap(
                    children: [
                      const Text("Change Administrator Password"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              hintText: 'Enter administrator login',
                              labelText: 'Admin'),
                          controller: passwordChangeControllerUsername,
                          validator: (String? value) {
                            return (value == null) ? 'Empty field!' : null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              hintText: 'Enter administrator old password',
                              labelText: '********'),
                          controller: passwordChangeControllerOldPassword,
                          validator: (String? value) {
                            return (value == null) ? 'Empty field!' : null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              hintText: 'Enter administrator new password',
                              labelText: '*********'),
                          controller: passwordChangeControllerNewPassword,
                          validator: (String? value) {
                            return (value == null) ? 'Empty field!' : null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              hintText: 'Repeat new administrator password',
                              labelText: '*********'),
                          controller: passwordChangeControllerRepeatPassword,
                          validator: (String? value) {
                            if (passwordChangeControllerRepeatPassword.text !=
                                passwordChangeControllerNewPassword.text) {
                              return 'Passwords do not match';
                            }

                            return (value == null) ? 'Empty field!' : null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          const Spacer(),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            ElevatedButton(
                style: buttonStyle,
                onPressed: () => setState(() {
                      stage = 1; // Избавиться от присваиваний
                    }),
                child: Text(
                  "Cancel",
                  style: buttonText,
                )),
            ElevatedButton(
              style: buttonStyle,
              onPressed: () async {
                if (_passwordChangeFormkey.currentState!.validate()) {
                  theJson = await adminHelper.postChangePassword(
                      passwordChangeControllerUsername.text,
                      passwordChangeControllerOldPassword.text,
                      passwordChangeControllerNewPassword.text,
                      token!);
                  var errorMsg = (theJson == "200")
                      ? "Password Changed!"
                      : "ERROR! Password have not changed!";
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(errorMsg)));

                  return setState(() {
                    stage = 1; // Избавиться от присваиваний
                  });
                }
                debugPrint("Passwod change status: $theJson");
              },
              child: Text(
                "Change Password",
                style: buttonText,
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Future<List<AdminForm>> generateForms(
      Future<dynamic> futureBody, Future<List<dynamic>> futureLangs) async {
    var body = await futureBody;
    var getLangs = await futureLangs;
    if (body != null) {
      bgImage = body["settings"]["bg_image"];
      logoImage = body["settings"]["logo_image"];
      languages.clear();

      languages = List.generate(
          getLangs.length,
          (index) => DropdownMenuItem<String>(
                value: getLangs[index],
                child: Text(getLangs[index]),
              ));
      for (int i = 0; i < body["settings"]["count_langs"]; i++) {
        if (!languagelist.contains(languages[i].value!)) {
          languagelist.add(languages.elementAt(i).value!);
        }
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
        bool? isRequired;
        type = body["fields"][i]["type"];
        title = Map.from(body["fields"][i]["title"]);
        description = Map.from(body["fields"][i]["description"]);
        apiName = body["fields"][i]["api_name"];
        brandIcon = body["fields"][i]["brand_icon"];
        apiValue = body["fields"][i]["api_value"];
        isRequired = body["fields"][i]["required_field"];
        apiName ??= "";

        formsFromServer.add(AdminForm.fromJson(type, i, title, description,
            apiName, brandIcon, apiValue, isRequired));
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
