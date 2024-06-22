import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

class TextBuilding extends StatelessWidget {
  final String value;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final bool applyPadding;

  TextBuilding({
    required this.value,
    this.fontSize = 20.0,
    this.color,
    this.fontWeight,
    this.fontFamily,
    this.applyPadding = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget textWidget = Text(
      value,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontFamily: fontFamily,
      ),
    );

    if (applyPadding) {
      return Padding(
        padding: EdgeInsets.only(left: 20),
        child: textWidget,
      );
    } else {
      return textWidget;
    }
  }
}
