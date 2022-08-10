import 'package:flutter/material.dart';
import 'auth.dart';

class Connection extends StatelessWidget {
  const Connection({super.key});

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
}
