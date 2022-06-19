// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:bahrain_manpower/Global/theme.dart';


class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton(
      {Key? key,
        required this.width,
        required this.height,
        this.icon,
        this.background,
        this.forground,
        this.text,
        this.onPressed,
        this.circle = false, this.hasTextStyle=false, this.textStyle, this.bordersColor, this.borderReduis})
      : super(key: key);
  final double width;
  final textStyle;
  final bordersColor;
  final double height;
  final icon;
  final text;
  final hasTextStyle;
  final borderReduis;
  final forground;
  final onPressed;
  final background ;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(

          splashFactory: InkSplash.splashFactory,
          fixedSize: MaterialStateProperty.all(Size(width, height)),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return mainOrangeColor;
            }
            return background;
          }),

          foregroundColor: MaterialStateProperty.all(forground),
          shape:
          circle ? MaterialStateProperty.all(const CircleBorder()) : MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderReduis??16.0),
                  side: BorderSide(color: bordersColor??background)
              )
          ) ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) icon,
          if (text != null) ...[
            if (icon != null) const SizedBox(width: 9),
            if (hasTextStyle) Text(
              text,
              style: textStyle,
            ) else Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ]
        ],
      ),
    );
  }
}