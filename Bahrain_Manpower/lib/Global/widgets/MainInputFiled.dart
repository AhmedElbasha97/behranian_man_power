// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:bahrain_manpower/Global/theme.dart';

class MainInputFiled extends StatefulWidget {
  final String? label;
  final TextInputType inputType;
  final TextEditingController? controller;
  final bool enabled;
  final Function(String?)? validator;
  final FocusNode? focusNode;
  const MainInputFiled(
      {Key? key,  this.label,
      this.inputType = TextInputType.text,
       this.controller,
      this.enabled = true,
       this.validator,
       this.focusNode}) : super(key: key);
  @override
  MainInputFiledState createState() => MainInputFiledState();
}


class MainInputFiledState extends State<MainInputFiled> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        validator: (value){widget.validator??(value);
return null;},
        keyboardType: widget.inputType,
        controller: widget.controller,
        focusNode: widget.focusNode,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            enabled: widget.enabled,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 4,
            ),
            border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: mainOrangeColor)),
            enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: mainOrangeColor)),
            disabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: mainOrangeColor)),
            focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.blueAccent)),
            hintStyle: const TextStyle(fontSize: 12),
            hintText: "${widget.label}"),
      ),
    );
  }
}
