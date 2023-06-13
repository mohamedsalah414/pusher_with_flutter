import 'package:flutter/material.dart';

class TextUtils extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? align;
  final String? fontFamily;

  const TextUtils({
    Key? key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.align,
    this.fontFamily,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontFamily: fontFamily),
    );
  }
}
