import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  TextEditingController controllerType = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TechoGym Guest"),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: getLines(),
            builder: (context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length - 1,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Text("element[$i]"),
                            Column(
                              children: twoStrings(
                                  snapshot.data!.elementAt(i).split(",")),
                            ),
                          ],
                        ),
                      );
                    });
              } else {
                return const Center(
                  child: Text("Not loaded"),
                );
              }
            },
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () async {
              await http.get(
                Uri.parse(
                    "http://192.168.1.103/connecting/connecting.php/?${Uri.base.query}"),
                headers: {
                  "Charset": "utf-8",
                },
              );
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  List<Widget> twoStrings(List<String> list) {
    List<Widget> widgets = [];
    for (int i = 0; i < list.length - 1; i++) {
      widgets.add(Container(
        color: Colors.grey,
        width: 50,
        child: Text(list.elementAt(i)),
      ));
    }
    return widgets;
  }
}

Future<List<String>> getLines() async {
  var response = await http
      .get(Uri.parse("http://192.168.43.87/admin/admin.php/?cmd=find"));
  return response.body.split(";");
}
