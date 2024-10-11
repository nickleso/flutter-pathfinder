import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pathfinder/components/header.dart';
import 'package:pathfinder/components/main_text_button.dart';
import 'package:pathfinder/components/text_widget.dart';
import 'package:pathfinder/pages/result_list_page.dart';

class ProcessPage extends StatelessWidget {
  const ProcessPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Header(
            title: 'Process screen',
            withButton: true,
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: TextWidget(
              text:
                  'All calculations has finished, you can send ypur results to server',
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          MainTextButton(
            buttonName: 'Send results to server',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const ResultListPage(title: 'Process screen')),
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
