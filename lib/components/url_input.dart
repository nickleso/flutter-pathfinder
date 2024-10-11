import 'package:flutter/material.dart';

class UrlInput extends StatelessWidget {
  const UrlInput({
    super.key,
    this.label,
    required this.controller,
  });

  final TextEditingController controller;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.url,
      autocorrect: false,
      cursorColor: const Color(0xFFFDFDFD),
      style: const TextStyle(
        color: Color(0xFFFDFDFD),
      ),
      decoration: InputDecoration(
        hintText: 'https://...',
        hintStyle: const TextStyle(
            fontSize: 14,
            color: Color(0xFFFDFDFD),
            fontWeight: FontWeight.w300,
            height: 1.8),
        fillColor: const Color(0xFFFDFDFD),
        labelStyle: const TextStyle(
            color: Color(0xFFF2F2F2), fontSize: 12, height: 1.8),
        filled: false,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD93535), width: 1.0),
        ),
        contentPadding: const EdgeInsets.only(top: 12),
        labelText: label ?? label,
        errorStyle: const TextStyle(
          color: Color(0xFFD93535),
          fontSize: 10,
          height: 1.8,
        ),
      ),
    );
  }
}
