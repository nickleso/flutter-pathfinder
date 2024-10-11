import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pathfinder/components/header.dart';
import 'package:pathfinder/components/text_widget.dart';

class ResultListPage extends StatelessWidget {
  const ResultListPage({super.key, required this.title});

  final String title;

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
          // const Spacer(),
          // MainTextButton(
          //   buttonName: 'Send results to server',
          //   onPressed: () => Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) =>
          //             const ResultListPage(title: 'Process screen')),
          //   ),
          // ),
          SizedBox(
            height: 24.h,
          )
        ],
      ),
    );
  }
}
