import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pathfinder/components/header.dart';
import 'package:pathfinder/components/text_widget.dart';

class ResultListPage extends StatelessWidget {
  const ResultListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Header(
            title: 'Result list screen',
            withButton: true,
          ),
          SizedBox(
            height: 24.h,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: TextWidget(
              text: 'List',
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 24.h,
          )
        ],
      ),
    );
  }
}
