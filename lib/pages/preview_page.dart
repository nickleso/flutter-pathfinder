import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pathfinder/bloc/pathfinder_bloc.dart';
import 'package:pathfinder/bloc/pathfinder_state.dart';
import 'package:pathfinder/components/header.dart';
import 'package:pathfinder/components/text_widget.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Header(
            title: 'Result list screen',
            withButton: true,
          ),
          BlocBuilder<PathfinderBloc, PathfinderState>(
            builder: (context, state) {
              if (state is PathfinderLoaded) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      children: [
                        const TextWidget(
                          text: 'List',
                          textAlign: TextAlign.center,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.data.length,
                            itemBuilder: (context, index) {
                              final item = state.data[index];
                              return Column(
                                children: [
                                  Text('ID: ${item["id"]}'),
                                  Text('Field: ${item["field"].join(", ")}'),
                                  Text('Field: ${item["start"]}'),
                                  Text('Field: ${item["end"]}'),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                // Якщо даних ще немає
                return const Center(
                  child: Text('No data available'),
                );
              }
            },
          ),
          SizedBox(
            height: 24.h,
          )
        ],
      ),
    );
  }
}
