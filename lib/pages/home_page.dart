import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pathfinder/components/header.dart';
import 'package:pathfinder/components/main_text_button.dart';
import 'package:pathfinder/components/text_widget.dart';
import 'package:pathfinder/pages/process_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Header(
            title: 'Home screen',
          ),
          SizedBox(
            height: 24.h,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child:
                TextWidget(text: 'Set valid API base URL in order to continue'),
          ),
          const Spacer(),
          MainTextButton(
            buttonName: 'Start counting process',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const ProcessPage(title: 'Process screen')),
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
