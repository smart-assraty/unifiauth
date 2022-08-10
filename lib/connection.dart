import 'package:flutter/material.dart';
//import 'dart:io';
import 'auth.dart';

class Connection extends StatelessWidget {
  const Connection({super.key});
  static const routeName = "/connection";
  @override
  Widget build(BuildContext context) {
    final args = getFormArguments();
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: args.length,
              itemBuilder: (BuildContext context, index) {
                return Text(args[index]);
              }),
          const Text("You've connected")
        ],
      ),
    );
  }

  /*void listen() async {
    final server = ServerSocket.bind("127.0.0.1", 80);
    var listening = HttpServer.listenOn(await server);

    listening.forEach((HttpRequest request) {
      debugPrint(request.first.toString());
    });
  }*/
}
