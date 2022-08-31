import 'package:flutter/material.dart';
import 'server_connector.dart' show AuthHelper;
import 'auth_forms.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  String currentLang = "rus";
  AuthHelper authHelper = AuthHelper();
  List<AuthForm> fields = [];
  List<AuthForm> brands = [];
  List<Map<String, dynamic>> dataToApi = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: serverTest(),
    );
  }

  Widget serverTest() {
    return FutureBuilder(
      future: authHelper.getForms(currentLang),
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          dynamic body = snapshot.data!;
          generateForms(body);
          var languagelist = List.generate(
              body["count_langs"],
              (index) => DropdownMenuItem<String>(
                    value: body["langs"][index],
                    child: Text(body["langs"][index]),
                  ));
          List<AuthForm> forms = [];
          for (int index = 0; index < body["count_fields"] - 1; ++index) {
            forms.add(AuthForm.createForm(
                body["fields"][index]["type"],
                body["fields"][index]["title"],
                body["fields"][index]["description"],
                body["fields"][index]["brand_icon"]));
          }
          return Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: NetworkImage("http://185.125.88.30/img/imageBG.jpeg"),
            )),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Padding(
                    padding: EdgeInsets.all(20),
                    child: Image(
                      image: NetworkImage(
                          "http://185.125.88.30/img/imageLogo.jpeg"),
                      height: 300,
                      width: 300,
                    )),
                Container(
                    width: 400,
                    height: 600,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white),
                    child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: DropdownButton(
                                  hint: Text(
                                    currentLang,
                                  ),
                                  items: languagelist,
                                  onChanged: (value) => setState(() {
                                        currentLang = value.toString();
                                      })),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Column(
                                children: [
                                  Text(
                                    body["fields"][body["count_fields"] - 1]
                                        ["title"],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(body["fields"][body["count_fields"] - 1]
                                      ["description"]),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 320,
                              child: ListView(
                                children: fields,
                              ),
                            ),
                            SizedBox(
                              height: 100,
                              child: ListView(
                                  scrollDirection: Axis.vertical,
                                  children: [
                                    Row(
                                      children: brands,
                                    )
                                  ]),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () async {
                                  for (int i = 0; i < forms.length; i++) {
                                    if (forms[i]
                                        .formkey
                                        .currentState!
                                        .validate()) {
                                      continue;
                                    }
                                  }
                                  authHelper.connecting();
                                  authHelper.postData(dataToApi, forms);
                                },
                                child: const Text("Submit"),
                              ),
                            ),
                          ],
                        ))),
              ],
            )),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void generateForms(dynamic body) {
    fields.clear();
    brands.clear();

    for (int i = 0; i < body["count_fields"] - 1; ++i) {
      (body["fields"][i]["type"] != "brand")
          ? fields.add(AuthForm.createForm(
              body["fields"][i]["type"],
              body["fields"][i]["title"],
              body["fields"][i]["description"],
              body["fields"][i]["brand_icon"]))
          : brands.add(AuthForm.createForm(
              body["fields"][i]["type"],
              body["fields"][i]["title"],
              body["fields"][i]["description"],
              body["fields"][i]["brand_icon"]));
    }
  }
}
