import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.title,
    this.withButton = false,
    this.onPressed,
  });

  final bool withButton;
  final String title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 110, 230, 11),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12),
      child: Row(
        children: [
          if (withButton)
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Material(
                color: const Color.fromARGB(255, 110, 230, 11),
                child: InkWell(
                  onTap: onPressed ?? () => Navigator.pop(context),
                  splashColor: const Color.fromARGB(255, 254, 254, 254),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Transform.rotate(
                      angle: 0,
                      child: SvgPicture.asset(
                        'assets/icons/goback-arrow.svg',
                        height: 28,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 1.4,
                color: Color(0xFF131A21)),
          ),
          const Spacer(),
          SizedBox(
            width: 24.w,
          ),
        ],
      ),
    );
  }
}
