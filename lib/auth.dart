import 'package:avoid_keyboard/avoid_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'server_connector.dart' show AuthHelper;
import 'auth_forms.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String currentLang = "rus";
  AuthHelper authHelper = AuthHelper();
  List<AuthForm> fields = [];
  List<AuthForm> brands = [];
  List<AuthForm> forms = [];
  List<DropdownMenuItem<String>> languagelist = [];
  List<Map<String, dynamic>> dataToApi = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return webMobile();
        }
        return webDesktop();
      }),
    );
  }

  Widget webMobile() {
    return FutureBuilder(
      future: authHelper.getForms(currentLang),
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          dynamic body = snapshot.data!;
          generateForms(body);
          return Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage("http://185.125.88.30/img/imageBG.jpg"),
                    fit: BoxFit.fill)),
            child: ListView(shrinkWrap: true, children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
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
                                    Text(body["fields"]
                                            [body["count_fields"] - 1]
                                        ["description"]),
                                  ],
                                ),
                              ),
                              Form(
                                key: formkey,
                                child: AvoidKeyboard(
                                    child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    Column(
                                      children: fields,
                                    ),
                                    (brands.isNotEmpty)
                                        ? SizedBox(
                                            height: 100,
                                            child: Column(
                                              children: [
                                                Text(brands[0].title),
                                                Row(
                                                  children: brands,
                                                )
                                              ],
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                )),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (formkey.currentState!.validate()) {
                                      Routemaster.of(context).push("/logged");
                                      authHelper.connecting();
                                      authHelper.postData(
                                          currentLang, dataToApi, forms);
                                    }
                                  },
                                  child: const Text("Submit"),
                                ),
                              ),
                            ],
                          ))),
                ],
              )
            ]),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget webDesktop() {
    return FutureBuilder(
      future: authHelper.getForms(currentLang),
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          dynamic body = snapshot.data!;
          generateForms(body);
          return Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage("http://185.125.88.30/img/imageBG.jpg"),
                    fit: BoxFit.fill)),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Padding(
                    padding: EdgeInsets.all(20),
                    child: Image(
                      image: NetworkImage(
                          "http://185.125.88.30/img/imageLogo.jpg"),
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
                            Form(
                                key: formkey,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 320,
                                      child: ListView(
                                        children: fields,
                                      ),
                                    ),
                                    (brands.isNotEmpty)
                                        ? SizedBox(
                                            height: 100,
                                            child: Column(
                                              children: [
                                                Text(brands[0].title),
                                                Row(
                                                  children: brands,
                                                )
                                              ],
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                )),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  Routemaster.of(context).push("/logged");
                                  authHelper.connecting();
                                  authHelper.postData(
                                      currentLang, dataToApi, forms);
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

  List<TextEditingController> controllers = [];

  void generateForms(dynamic body) {
    forms.clear();
    fields.clear();
    brands.clear();
    languagelist.clear();
    controllers.clear();

    controllers =
        List.generate(body["count_fields"], (index) => TextEditingController());

    languagelist = List.generate(
        body["count_langs"],
        (index) => DropdownMenuItem<String>(
              value: body["langs"][index],
              child: Text(body["langs"][index]),
            ));

    for (int i = 0; i < body["count_fields"] - 1; ++i) {
      forms.add(AuthForm.createForm(
          body["fields"][i]["type"],
          body["fields"][i]["api_name"],
          body["fields"][i]["title"],
          body["fields"][i]["description"],
          body["fields"][i]["brand_icon"],
          controllers[i]));
      (body["fields"][i]["type"] != "brand")
          ? fields.add(AuthForm.createForm(
              body["fields"][i]["type"],
              body["fields"][i]["api_name"],
              body["fields"][i]["title"],
              body["fields"][i]["description"],
              body["fields"][i]["brand_icon"],
              controllers[i]))
          : brands.add(AuthForm.createForm(
              body["fields"][i]["type"],
              body["fields"][i]["api_name"],
              body["fields"][i]["title"],
              body["fields"][i]["description"],
              body["fields"][i]["brand_icon"],
              controllers[i]));
    }
  }
}
