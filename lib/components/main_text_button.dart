import 'package:flutter/material.dart';
import 'package:pathfinder/components/text_widget.dart';

class MainTextButton extends StatelessWidget {
  const MainTextButton(
      {super.key,
      required this.buttonName,
      required this.onPressed,
      this.isDisabled = false});

  final String buttonName;
  final VoidCallback onPressed;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: isDisabled ? const Color(0xFFC5C5C5) : const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: isDisabled ? () {} : onPressed,
          splashColor: isDisabled
              ? Colors.transparent
              : const Color(0xFFFFFFFF).withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.fromLTRB(48, 16, 48, 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
            ),
            child: TextWidget(
              text: buttonName,
              textAlign: TextAlign.center,
              color: isDisabled
                  ? const Color(0xFF696969)
                  : const Color(0xFF2E2E2E),
              fontSize: 16,
              height: 1,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
