import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';

import 'inputFormatters.dart';
import 'main.dart';



// ignore: must_be_immutable
abstract class AuthField extends StatefulWidget {
  final String apiKey;
  final String type;
  final String title;
  final String? description;
  final bool isRequired;
  final String? brandUrl;

  

  dynamic data;
  Map<String, dynamic> commit() {
    if (type == "brand" && data != null) {
      selectedBrandUrl = brandUrl;
    }
    
    return {"type": type, "title": title, "api_name": apiKey, "value": data};
  }

  AuthField({
    super.key,
    required this.apiKey,
    required this.type,
    required this.title,
    this.description,
    this.brandUrl,
    required this.isRequired,
  });

  factory AuthField.createForm(
      String type,
      String apiKey,
      String title,
      String? description,
      String? brand,
      String? apiValue,
      bool? isRequired,
      String? brandUrlForm,
      TextEditingController? controller) {
    if (type == "email") {
      return Email(
        title: title,
        apiKey: apiKey,
        controller: controller!,
        isRequired: isRequired!,
      );
    } else if (type == "number") {
      return Number(
        title: title,
        apiKey: apiKey,
        controller: controller!,
        isRequired: isRequired!,
      );
    } else if (type == "checkbox") {
      return CheckBox(
        title: title,
        apiKey: apiKey,
        isRequired: isRequired!,
      );
    } else if (type == "brand") {
      return Brand(
        title: title,
        apiKey: apiKey,
        brand: brand!,
        apiValue: apiValue!,
        isRequired: isRequired!,
        brandUrl: brandUrlForm,
      );
      
    } else if (type == "front") {
      return Front(
        title: title,
        description: description,
      );
    } else {
      return TextField(
        apiKey: apiKey,
        title: title,
        description: description,
        controller: controller!,
        isRequired: isRequired!,
      );
    }
  }
}

// ignore: must_be_immutable
class Front extends AuthField {
  Front(
      {super.key,
      super.apiKey = "",
      required super.description,
      required super.title,
      super.type = "front",
      super.isRequired = false});

  @override
  State<Front> createState() => FrontState();
}

class FrontState extends State<Front> {
  dynamic data;
  Map<String, dynamic> commit() {
    return {
      "type": widget.type,
      "title": widget.title,
      "api_name": widget.apiKey,
      "value": data
    };
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}

// ignore: must_be_immutable
class TextField extends AuthField {
  TextField(
      {super.key,
      required super.apiKey,
      required super.title,
      required super.description,
      required this.controller,
      required super.isRequired})
      : super(type: "textfield");

  final TextEditingController controller;

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
    return TextFormField(
      style: textStyleLittle,
      validator: (widget.isRequired)
          ? (value) {
              if (value == null || value.isEmpty) {
                return "This field can not be empty";
              }
              return null;
            }
          : null,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
      controller: widget.controller,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelStyle: textStyleLittle,
        hintStyle: textStyleLittle,
        hintText: widget.description,
        label: Text(
          widget.title,
          style: textStyleLittle,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Email extends AuthField {
  Email(
      {super.key,
      required super.apiKey,
      required super.title,
      required this.controller,
      required super.isRequired})
      : super(type: "email");

  final TextEditingController controller;

  @override
  Map<String, dynamic> commit() {
    data = controller.text;
    return {"type": type, "title": title, "api_name": apiKey, "value": data};
  }

  @override
  State<Email> createState() => EmailState();
}

class EmailState extends State<Email> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: textStyleLittle,
      validator: (value) {
        if (widget.isRequired && value == null) {
          return "Please enter your email";
        }
        if (value != null && !EmailValidator.validate(value)) {
          return "Example: example@mail.com";
        }
        return null;
      },
      decoration: InputDecoration(
        label: Text(
          widget.title,
          style: textStyleLittle,
        ),
      ),
      textInputAction: TextInputAction.next,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
      controller: widget.controller,
      keyboardType: TextInputType.emailAddress,
    );
  }
}

//ignore: must_be_immutable
class Number extends AuthField {
  Number(
      {super.key,
      required super.apiKey,
      required super.title,
      required this.controller,
      required super.isRequired})
      : super(type: "number");

  TextEditingController controller;

  @override
  Map<String, dynamic> commit() {
    data = controller.text;
    return {"type": type, "title": title, "api_name": apiKey, "value": data};
  }

  @override
  State<Number> createState() => NumberState();
}

class NumberState extends State<Number> {
  

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: textStyleLittle,
      inputFormatters: [
        FieldsFormatter(mask: 'xx xxx xxx xx xxxx', separator: ' '),
        FilteringTextInputFormatter.allow(RegExp("[0-9 +]")),],
      validator: (value) {
        if (widget.isRequired && value == null) {
          return "Please enter your number";
        }

        return null;
      },
      decoration: InputDecoration(
        label: Text(
          widget.title,
          style: textStyleLittle,
        ), hintText: "+7 777 777 77 77"
        
      ),
      textInputAction: TextInputAction.next,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
      controller: widget.controller,
      keyboardType: TextInputType.number,
    );
  }
}

//ignore: must_be_immutable
class CheckBox extends AuthField {
  CheckBox(
      {super.key,
      required super.apiKey,
      required super.title,
      required super.isRequired})
      : super(type: "checkbox");

  @override
  State<CheckBox> createState() => CheckBoxState();
}

class CheckBoxState extends State<CheckBox> {
  bool accept = false;
  @override
  Widget build(BuildContext context) {
    return FormField<bool>(builder: (state) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          (state.hasError)
              ? Text(
                  state.errorText ?? "",
                  style: TextStyle(color: Theme.of(context).errorColor),
                )
              : const SizedBox(),
          Row(
            children: [
              Checkbox(
                  value: accept,
                  onChanged: (value) => setState(() {
                        FocusScope.of(context).requestFocus(FocusNode());
                        accept = value!;
                        widget.data = (accept) ? widget.title : null;
                        state.didChange(value);
                      })),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.0265,
                  width: widget.title.length * 10,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      widget.title,
                      style: textStyleLittle,
                    ),
                  ))
            ],
          ),
        ],
      );
    }, validator: (value) {
      if (widget.isRequired && !accept) {
        return "You need to accept terms";
      }
      return null;
    });
  }
}



//ignore: must_be_immutable
class Brand extends AuthField {
  String apiValue;
  String brand;
  bool isPicked = false;
  Brand(
      {super.key,
      required super.apiKey,
      required super.title,
      required this.brand,
      required this.apiValue,
      required super.isRequired,
      super.brandUrl,
      })
      : super(type: "brand");


  void setValue(bool b){
    isPicked = b;
    (b) ? data = apiValue : data = null;
  }

  @override
  State<Brand> createState() => BrandState();
}

class BrandState extends State<Brand> {
  @override
  Widget build(BuildContext context) {
    
    return Container(
        height: 90,
        width: 90,
        decoration: (widget.isPicked)
            ? const BoxDecoration(
                border: Border(
                bottom: BorderSide(color: Colors.amber, width: 2),
                top: BorderSide(color: Colors.amber, width: 2),
                right: BorderSide(color: Colors.amber, width: 2),
                left: BorderSide(color: Colors.amber, width: 2),
              ))
            : null,
        child: IconButton(
          iconSize: 90,
          icon: Image(
            image: NetworkImage("$server/img/${widget.brand}"),
          ),
          onPressed: () async {
            setState(() {
              FocusScope.of(context).requestFocus(FocusNode());
              
              (widget.isPicked)
                  ? widget.isPicked = false
                  : widget.isPicked = true;
                
              (widget.isPicked)
                  ? widget.data = widget.apiValue
                  : widget.data = null;
            });
          },
        ));
  }
}
