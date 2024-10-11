import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({
    super.key,
    required this.text,
    this.color = const Color(0xFFF2F2F2),
    this.fontSize = 16,
    this.height = 1.4,
    this.fontWeight = FontWeight.w400,
    this.textAlign = TextAlign.start,
  });

  final String text;
  final Color? color;
  final double? fontSize;
  final double? height;
  final FontWeight fontWeight;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      softWrap: true,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        height: height,
        fontWeight: fontWeight,
      ),
    );
  }
}
