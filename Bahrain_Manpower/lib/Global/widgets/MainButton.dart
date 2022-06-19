// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:bahrain_manpower/Global/theme.dart';

class MainButton extends StatefulWidget {
  final Function? onTap;
  final String? label;
  const MainButton({Key? key,  this.label,  this.onTap}) : super(key: key);
  @override
  MainButtonState createState() => MainButtonState();
}

class MainButtonState extends State<MainButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){widget.onTap!();},
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: mainOrangeColor),
        child: Center(
            child: Text(
          "${widget.label}",
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        )),
      ),
    );
  }
}
