import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pathfinder/bloc/pathfinder_bloc.dart';
import 'package:pathfinder/bloc/pathfinder_state.dart';
import 'package:pathfinder/components/header.dart';
import 'package:pathfinder/components/text_widget.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[300],
      body: Column(
        children: [
          const Header(
            title: 'Preview Screen',
            withButton: true,
          ),
          BlocBuilder<PathfinderBloc, PathfinderState>(
            builder: (context, state) {
              if (state is PathfinderLoaded) {
                final item =
                    state.data.firstWhere((element) => element['id'] == id);

                List<String> field = List<String>.from(item['field']);
                Map<String, int> start = Map<String, int>.from(item['start']);
                Map<String, int> end = Map<String, int>.from(item['end']);
                List<Map<String, int>>? steps =
                    List<Map<String, int>>.from(item['steps'] ?? []);

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 24.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: field[0].length,
                              childAspectRatio: 1.0,
                            ),
                            itemCount: field.length * field[0].length,
                            itemBuilder: (context, index) {
                              int x = index % field[0].length;
                              int y = index ~/ field[0].length;

                              return Container(
                                margin: const EdgeInsets.all(1.0),
                                color: _getCellColor(
                                    x, y, start, end, steps, field),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: TextWidget(
                                    text: '($x,$y)',
                                    color: Colors.amber[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        TextWidget(
                          text: 'Path: ${item['path']}',
                          fontSize: 18,
                          color: const Color(0xFF141B22),
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: Text('No data available'),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Color _getCellColor(
    int x,
    int y,
    Map<String, int> start,
    Map<String, int> end,
    List<Map<String, int>> steps,
    List<String> field,
  ) {
    if (start['x'] == x && start['y'] == y) {
      return const Color(0xFF64FFDA);
    } else if (end['x'] == x && end['y'] == y) {
      return const Color(0xFF009688);
    } else if (steps.any((step) => step['x'] == x && step['y'] == y)) {
      return const Color(0xFF4CAF50);
    } else if (field[y][x] == 'X') {
      return const Color(0xFF000000);
    } else {
      return const Color(0xFFFFFFFF);
    }
  }
}
