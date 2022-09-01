import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show MultipartFile, MultipartRequest;

import 'main.dart';

// ignore: must_be_immutable
abstract class AuthForm extends StatefulWidget {
  dynamic data;
  String apiKey;
  String type;
  String title;
  String? description;
  //final formkey = GlobalKey<FormState>();

  AuthForm({
    super.key,
    required this.apiKey,
    required this.type,
    required this.title,
    this.description,
  });

  Map<String, dynamic> commit() {
    return {"type": type, "title": title, "api_name": apiKey, "value": data};
  }

  factory AuthForm.createForm(String type, String apiKey, String title,
      String? description, String? brand) {
    if (type == "email") {
      return Email(title: title, apiKey: apiKey);
    } else if (type == "number") {
      return Number(title: title, apiKey: apiKey);
    } else if (type == "checkbox") {
      return CheckBox(title: title, apiKey: apiKey);
    } else if (type == "brand") {
      return Brand(
        title: title,
        apiKey: apiKey,
        brand: brand!,
      );
    } else {
      return TextField(
        apiKey: apiKey,
        title: title,
      );
    }
  }
}

// ignore: must_be_immutable
class TextField extends AuthForm {
  TextField({
    super.key,
    required super.apiKey,
    required super.title,
    super.description,
  }) : super(type: "textfield");

  final TextEditingController controller = TextEditingController();

  @override
  Map<String, dynamic> commit() {
    data = controller.text;
    return {"type": type, "title": title, "api_name": apiKey, "value": data};
  }

  @override
  State<TextField> createState() => TextFieldState();
}

class TextFieldState extends State<TextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.title,
            ),
          ),
          TextFormField(
            onChanged: (value) {
              widget.data = value;
            },
            onEditingComplete: () {
              debugPrint(widget.controller.text);
            },
            controller: widget.controller,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: widget.description,
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class Email extends AuthForm {
  Email({
    super.key,
    required super.apiKey,
    required super.title,
  }) : super(type: "email");

  TextEditingController controller = TextEditingController();

  @override
  State<Email> createState() => EmailState();
}

class EmailState extends State<Email> {
  RegExp regExp = RegExp(
      "^[a-zA-Z0-9]+(?:\\.[a-zA-Z0-9]+)*@[a-zA-Z0-9]+(?:\\.[a-zA-Z0-9]+)*\$");
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.title,
            ),
          ),
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return "Fill the form";
              } else if (!value.contains(regExp)) {
                return "Hint: example@mail.com";
              } else {
                return null;
              }
            },
            controller: widget.controller,
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }
}

//ignore: must_be_immutable
class Number extends AuthForm {
  Number({
    super.key,
    required super.apiKey,
    required super.title,
  }) : super(type: "number");

  TextEditingController controller = TextEditingController();

  @override
  State<Number> createState() => NumberState();
}

class NumberState extends State<Number> {
  RegExp regExp = RegExp("[1-9]{11}");
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.title,
            ),
          ),
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return "Fill the field";
              } else if (!value.contains(regExp)) {
                return "Hint: must contain 11 digits";
              } else {
                return null;
              }
            },
            controller: widget.controller,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}

//ignore: must_be_immutable
class CheckBox extends AuthForm {
  CheckBox({
    super.key,
    required super.apiKey,
    required super.title,
  }) : super(type: "checkbox");

  @override
  State<CheckBox> createState() => CheckBoxState();
}

class CheckBoxState extends State<CheckBox> {
  bool accept = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Column(
        children: [
          Text(
            widget.title,
          ),
          Checkbox(
              value: accept,
              onChanged: (value) => setState(() {
                    accept = value!;
                    widget.data = accept;
                  }))
        ],
      ),
    );
  }
}

//ignore: must_be_immutable
class Brand extends AuthForm {
  String brand;
  Brand({
    super.key,
    required super.apiKey,
    required super.title,
    required this.brand,
  }) : super(type: "brand");

  @override
  State<Brand> createState() => BrandState();
}

class BrandState extends State<Brand> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Column(
      children: [
        Text(
          widget.title,
        ),
        IconButton(
          iconSize: 50,
          icon: Image(
            image: NetworkImage("http://185.125.88.30/img/${widget.brand}"),
          ),
          onPressed: () async {
            String imageUrl = await sendImage(await pickfile(), "Brands");
            setState(() {
              widget.data = imageUrl;
            });
          },
        ),
      ],
    ));
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
      var file =
          MultipartFile.fromBytes("file", listImage, filename: 'myImage.png');
      request.files.add(file);
      var response = await request.send();
      return response.stream.bytesToString();
    } catch (e) {
      return "$e";
    }
  }
}
