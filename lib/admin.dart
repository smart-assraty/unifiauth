import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    show HtmlWidget;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert' show json;

import 'admin_forms.dart';
import 'main.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => AdminPageState();
}

List<String> lan = ["rus", "eng", "kaz", "ita", "tur"];

int languagesNumber = 1;
List<DropdownMenuItem<String>> languagelist = List.generate(lan.length,
    (index) => DropdownMenuItem(value: lan[index], child: Text(lan[index])));
List<String> languages =
    List.generate(languagesNumber, (index) => languagelist[index].value!);

class AdminPageState extends State<AdminPage> {
  String currentLang = languages[0];
  String? token;
  int stage = 1;
  late String title;
  late String description;
  late dynamic backgroundImage;
  late dynamic logo;
  var frontAdminField = Front();
  List<AdminForm> forms = [];
  Map<String, dynamic> mapToPost = {};
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
            image: DecorationImage(image: AssetImage("assets/bg.jpeg"))),
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
                    Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Login"),
                        ),
                        TextFormField(
                          controller: login,
                          autofocus: true,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Password"),
                        ),
                        TextFormField(
                          controller: password,
                          autofocus: true,
                        ),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          var request = MultipartRequest("POST",
                              Uri.parse("$server:8000/AdministratorSignIn"));
                          request.fields.addAll({
                            "username": login.text,
                            "password": password.text
                          });
                          request.headers
                              .addAll({"Content-type": "multipart/form/data"});
                          var send = await request.send();
                          token = await send.stream.bytesToString();
                          if (send.statusCode == 200) {
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
                    itemCount: languages.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return SizedBox(
                          height: 35,
                          child: DropdownButton<String>(
                              hint: Text(languages[index]),
                              items: languagelist,
                              onChanged: (value) {
                                setState(() {
                                  languages[index] = value!;
                                  frontAdminField = Front();
                                });
                              }));
                    },
                  ),
                  TextButton(
                      onPressed: () => setState(() {
                            languages.add(languagelist[languagesNumber].value!);
                            frontAdminField = Front();
                          }),
                      child: const Text(
                        "Добавить язык +",
                        style: TextStyle(color: Colors.amber),
                      ))
                ],
              ),
            ),
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
                        backgroundImage = await pickfile();
                        (backgroundImage.runtimeType == FilePickerResult)
                            ? await sendImage(backgroundImage, "UploadBGImage")
                            : debugPrint(backgroundImage);
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
                        logo = await pickfile();
                        (logo.runtimeType == FilePickerResult)
                            ? await sendImage(logo, "UploadLogoImage")
                            : debugPrint(logo);
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

  //Test
  Widget contentPageTwo() {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      width: 350,
      child: Column(
        children: [
          contentHeader(),
          SizedBox(
            height: 550,
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
  //End Test

  Widget contentPageTwoServer() {
    return FutureBuilder(
        future: getForms(token!),
        builder: (context, AsyncSnapshot<List<AdminForm>> snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            forms = snapshot.data!;
          }
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
        });
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
                theJson = await postToServer();
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

  Widget contentPageFour() {
    return ListView(
      shrinkWrap: true,
      children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: theJson.split(',').length,
            itemBuilder: (context, index) {
              return Text(theJson.split(',')[index]);
            }),
        const Spacer(),
        ElevatedButton(
            onPressed: () => setState(() {
                  currentLang = "rus";
                  mapToPost.clear();
                  forms.clear();
                  stage = 1;
                  frontAdminField = Front();
                  sendTo.text = "";
                }),
            child: const Text("Back"))
      ],
    );
  }

  Future<String> postToServer() async {
    try {
      var formForAdminField = AdminForm();
      formForAdminField.setChild(frontAdminField);
      forms.add(formForAdminField);
      List<Map<String, dynamic>> list = [];
      for (int i = 0; i < forms.length; i++) {
        list.add(forms.elementAt(i).getChild().commit());
      }

      mapToPost.addAll({
        "login": "string",
        "settings": {
          "langs": languages,
          "count_langs": languages.length,
          "logo_img": "string",
          "bg_image": "string",
          "bg_color": null,
          "count_fields": forms.length,
          "api_url": sendTo.text
        },
        "fields": list,
      });
      /*var request = await post(Uri.parse("$server:8000/LoginForm/"),
          headers: {
            "Content-type": "application/json",
            "Authorization":
                "${json.decode(token!)['token_type']} ${json.decode(token!)['access_token']}"
          },
          body: json.encode(mapToPost));

      return json.encode(request.body);*/
      return json.encode(mapToPost); //Test
    } catch (e) {
      return "Error: $e";
    }
  }
}

Future<dynamic> pickfile() async {
  try {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowCompression: false,
    );
    return file;
  } catch (e) {
    return "$e";
  }
}

Future<String> sendImage(FilePickerResult image, String toDir) async {
  try {
    var bytes = image.files.first.bytes!;
    var request = MultipartRequest(
      "POST",
      Uri.parse("$server:8000/$toDir/"),
    );
    var listImage = List<int>.from(bytes);
    request.headers["content-type"] = "multipart/form-data";
    var file = MultipartFile.fromBytes("file", listImage);
    request.files.add(file);
    var response = await request.send();
    return response.stream.bytesToString();
  } catch (e) {
    return "$e";
  }
}

Future<List<AdminForm>> getForms(String resp) async {
  var response = await get(Uri.parse("$server/"), headers: {
    "Authorization":
        "${json.decode(resp)['token_type']} ${json.decode(resp)['access_token']}"
  });
  var body = json.decode(response.body);

  languagelist = List.generate(
      body["count_langs"],
      (index) => DropdownMenuItem<String>(
            value: body["langs"][index],
            child: Text(body["langs"][index]),
          ));

  List<AdminForm> formsFromServer = [];
  for (int i = 0; i < body["count_langs"]; ++i) {
    formsFromServer.add(AdminForm.fromJson(
        body["fields"][i]["type"],
        body["fields"][i]["title"],
        body["fields"][i]["api_name"],
        body["fields"][i]["description"],
        body["fields"][i]["brand_icon"]));
  }
  return formsFromServer;
}
