import 'package:avoid_keyboard/avoid_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'main.dart';
import 'server_connector.dart' show AuthHelper;
import 'auth_forms.dart';

// ignore: must_be_immutable
class AuthPage extends StatefulWidget {
  AuthPage({super.key});

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String currentLang = "rus";
  AuthHelper authHelper = AuthHelper();
  List<AuthForm> fields = [];
  List<AuthForm> brands = [];
  List<AuthForm> forms = [];
  List<DropdownMenuItem<String>> languagelist = [];
  List<Map<String, dynamic>> dataToApi = [];
  List<TextEditingController> controllers = [];
  dynamic body;
  @override
  State<AuthPage> createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage>
    with AutomaticKeepAliveClientMixin<AuthPage> {
  dynamic formsGetter;
  @override
  void initState() {
    super.initState();

    formsGetter = widget.authHelper.getForms(widget.currentLang);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
          backgroundColor: Colors.black,
          resizeToAvoidBottomInset: false,
          body: FutureBuilder(
            future: formsGetter,
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                widget.body = snapshot.data;
                generateForms(widget.body);
                return LayoutBuilder(builder: (context, constraints) {
                  if (constraints.maxWidth < 600) {
                    return webMobile();
                  }
                  return webDesktop();
                });
              } else {
                return const CircularProgressIndicator();
              }
            },
          )),
    );
  }

  Widget webMobile() {
    return Container(
      height: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage("$server/img/imageBG.jpg"),
              fit: BoxFit.fill)),
      child: ListView(shrinkWrap: true, children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                width: 450,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: DropdownButton(
                              hint: Text(
                                widget.currentLang,
                              ),
                              items: widget.languagelist,
                              onChanged: (value) => setState(() {
                                    widget.currentLang = value.toString();
                                  })),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Column(
                            children: [
                              Text(
                                widget.body["fields"]
                                    [widget.body["count_fields"] - 1]["title"],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(widget.body["fields"]
                                      [widget.body["count_fields"] - 1]
                                  ["description"]),
                            ],
                          ),
                        ),
                        Form(
                          key: widget.formkey,
                          child: AvoidKeyboard(
                              child: ListView(
                            shrinkWrap: true,
                            children: [
                              Column(
                                children: widget.fields,
                              ),
                              (widget.brands.isNotEmpty)
                                  ? SizedBox(
                                      height: 100,
                                      child: Column(
                                        children: [
                                          Text(widget.brands[0].title),
                                          Row(
                                            children: widget.brands,
                                          )
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              style: buttonStyle,
                              onPressed: () async {
                                if (widget.formkey.currentState!.validate()) {
                                  widget.authHelper.connecting();
                                  var response = await widget.authHelper
                                      .postData(widget.currentLang,
                                          widget.dataToApi, widget.forms);
                                  if (response == 200) {
                                    // ignore: use_build_context_synchronously
                                    Routemaster.of(context).push("/logged");
                                  }
                                }
                              },
                              child: const Text("Submit"),
                            ),
                          ),
                        ),
                      ],
                    ))),
          ],
        )
      ]),
    );
  }

  Widget webDesktop() {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage("$server/img/imageBG.jpg"),
              fit: BoxFit.fill)),
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
              padding: const EdgeInsets.all(20),
              child: Image(
                image: NetworkImage("$server/img/imageLogo.jpg"),
                height: 300,
                width: 300,
              )),
          Container(
              width: 400,
              height: 600,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.white),
              child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: DropdownButton(
                            hint: Text(
                              widget.currentLang,
                            ),
                            items: widget.languagelist,
                            onChanged: (value) => setState(() {
                                  widget.currentLang = value.toString();
                                })),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            Text(
                              widget.body["fields"]
                                  [widget.body["count_fields"] - 1]["title"],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(widget.body["fields"]
                                    [widget.body["count_fields"] - 1]
                                ["description"]),
                          ],
                        ),
                      ),
                      Form(
                        key: widget.formkey,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Column(
                              children: widget.fields,
                            ),
                            (widget.brands.isNotEmpty)
                                ? SizedBox(
                                    height: 100,
                                    child: Column(
                                      children: [
                                        Text(widget.brands[0].title),
                                        Row(
                                          children: widget.brands,
                                        )
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: buttonStyle,
                          onPressed: () async {
                            if (widget.formkey.currentState!.validate()) {
                              widget.authHelper.connecting();
                              var response = await widget.authHelper.postData(
                                  widget.currentLang,
                                  widget.dataToApi,
                                  widget.forms);
                              if (response == 200) {
                                // ignore: use_build_context_synchronously
                                Routemaster.of(context).push("/logged");
                              }
                            }
                          },
                          child: const Text("Submit"),
                        ),
                      ),
                    ],
                  ))),
        ],
      )),
    );
  }

  void generateForms(dynamic body) {
    widget.forms.clear();
    widget.fields.clear();
    widget.brands.clear();
    widget.languagelist.clear();

    widget.controllers =
        List.generate(body["count_fields"], (index) => TextEditingController());

    widget.languagelist = List.generate(
        body["count_langs"],
        (index) => DropdownMenuItem<String>(
              value: body["langs"][index],
              child: Text(body["langs"][index]),
            ));

    for (int i = 0; i < body["count_fields"] - 1; ++i) {
      widget.forms.add(AuthForm.createForm(
          body["fields"][i]["type"],
          body["fields"][i]["api_name"],
          body["fields"][i]["title"],
          body["fields"][i]["description"],
          body["fields"][i]["brand_icon"],
          body["fields"][i]["api_value"],
          widget.controllers[i]));
      (body["fields"][i]["type"] != "brand")
          ? widget.fields.add(AuthForm.createForm(
              body["fields"][i]["type"],
              body["fields"][i]["api_name"],
              body["fields"][i]["title"],
              body["fields"][i]["description"],
              body["fields"][i]["brand_icon"],
              body["fields"][i]["api_value"],
              widget.controllers[i]))
          : widget.brands.add(AuthForm.createForm(
              body["fields"][i]["type"],
              body["fields"][i]["api_name"],
              body["fields"][i]["title"],
              body["fields"][i]["description"],
              body["fields"][i]["brand_icon"],
              body["fields"][i]["api_value"].toString(),
              widget.controllers[i]));
    }
  }

  @override
  bool get wantKeepAlive => true;
}
