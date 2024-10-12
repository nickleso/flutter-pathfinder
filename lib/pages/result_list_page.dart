import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pathfinder/bloc/pathfinder_bloc.dart';
import 'package:pathfinder/bloc/pathfinder_state.dart';
import 'package:pathfinder/components/header.dart';
import 'package:pathfinder/components/text_widget.dart';
import 'package:pathfinder/pages/preview_page.dart';

class ResultListPage extends StatelessWidget {
  const ResultListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final data =
        (context.read<PathfinderBloc>().state as PathfinderLoaded).data;

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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PreviewPage(id: data[index]['id'])),
                        );
                      },
                      title: TextWidget(
                        text: data[index]['path'],
                        textAlign: TextAlign.center,
                        color: const Color(0xFF141B22),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
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
