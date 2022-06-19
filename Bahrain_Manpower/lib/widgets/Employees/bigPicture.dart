// ignore: file_names

// ignore_for_file: file_names, duplicate_ignore

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BigPicture extends StatefulWidget {
  String? link;
  BigPicture({Key? key,  this.link}) : super(key: key);
  @override
  BigPictureState createState() => BigPictureState();
}

class BigPictureState extends State<BigPicture> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Image.network(widget.link!, fit: BoxFit.cover, width: 1000)),
    );
  }
}
