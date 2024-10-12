import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pathfinder/bloc/pathfinder_bloc.dart';
import 'package:pathfinder/bloc/pathfinder_event.dart';
import 'package:pathfinder/bloc/pathfinder_state.dart';
import 'package:pathfinder/components/header.dart';
import 'package:pathfinder/components/main_text_button.dart';
import 'package:pathfinder/components/text_widget.dart';
import 'package:pathfinder/pages/result_list_page.dart';
import 'package:pathfinder/repositories/pathfinder_repository.dart';

class ProcessPage extends StatefulWidget {
  const ProcessPage({super.key});

  @override
  State<ProcessPage> createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage> {
  late final PathfinderRepository pathfinderRepository;
  bool isLoading = false;
  bool isError = false;
  String? errorMessage;
  List<dynamic>? pathfinderData;

  @override
  void initState() {
    super.initState();
    pathfinderRepository = PathfinderRepository();

    final blocState = context.read<PathfinderBloc>().state as PathfinderLoaded;
    pathfinderData = blocState.data;

    calculatPathfinderData();
  }

  void calculatPathfinderData() {
    List<Map<String, dynamic>> results = [];
    List<Map<String, dynamic>> updatedData = [];

    for (var obj in pathfinderData!) {
      List<String> field = List<String>.from(obj['field']);
      Map<String, int> start = Map<String, int>.from(obj['start']);
      Map<String, int> end = Map<String, int>.from(obj['end']);

      List<Map<String, int>>? path = bfs(field, start, end);

      if (path != null) {
        String pathString =
            path.map((step) => '(${step['x']},${step['y']})').join('->');

        results.add({
          "id": obj['id'],
          "result": {
            "steps": path,
            "path": pathString,
          }
        });

        obj['steps'] = path;
        obj['path'] = pathString;
      }

      updatedData.add(obj);
    }

    pathfinderData = results;
    context.read<PathfinderBloc>().add(SavePathfinderData(updatedData));

    print('Calculation Results: $results');
  }

  List<Map<String, int>>? bfs(
      List<String> field, Map<String, int> start, Map<String, int> end) {
    int rows = field.length;
    int cols = field[0].length;

    List<List<int>> directions = [
      [0, 1],
      [0, -1],
      [1, 0],
      [-1, 0],
      [1, 1],
      [1, -1],
      [-1, 1],
      [-1, -1]
    ];

    Queue<List<Map<String, int>>> queue = Queue();
    queue.add([start]);

    Set<String> visited = {key(start['x'] ?? 0, start['y'] ?? 0)};

    while (queue.isNotEmpty) {
      List<Map<String, int>> path = queue.removeFirst();
      Map<String, int> current = path.last;

      if (current['x'] == end['x'] && current['y'] == end['y']) {
        return path;
      }

      for (var direction in directions) {
        int newX = (current['x'] ?? 0) + direction[0];
        int newY = (current['y'] ?? 0) + direction[1];

        if (isValidCell(newX, newY, field, visited)) {
          visited.add(key(newX, newY));

          List<Map<String, int>> newPath = List.from(path)
            ..add({"x": newX, "y": newY});
          queue.add(newPath);
        }
      }
    }

    return null;
  }

  bool isValidCell(int x, int y, List<String> field, Set<String> visited) {
    int rows = field.length;
    int cols = field[0].length;

    return x >= 0 &&
        y >= 0 &&
        x < cols &&
        y < rows &&
        field[y][x] == '.' &&
        !visited.contains(key(x, y));
  }

  String key(int x, int y) => '$x,$y';

  Future<void> sendPathfinderResult(String url) async {
    print('****sending_');

    setState(() {
      isLoading = true;
      errorMessage = null;
      isError = false;
    });

    try {
      final result = await pathfinderRepository.sendResult(
        urlString: url,
        body: pathfinderData!,
      );

      print('****sending_result: $result');

      setState(() {
        isLoading = false;

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ResultListPage()),
          );
        }
      });
    } catch (error) {
      print('****process_error: $error');

      setState(() {
        isError = true;
        errorMessage = error.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final urlString =
        (context.read<PathfinderBloc>().state as PathfinderLoaded).url;

    return Scaffold(
      body: Column(
        children: [
          const Header(title: 'Process screen', withButton: true),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                children: [
                  const Spacer(),
                  TextWidget(
                    text: isLoading
                        ? 'Calculating...'
                        : 'All calculations have finished. You can send results to the server.',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12.h),
                  const TextWidget(
                    text: '100%',
                    textAlign: TextAlign.center,
                    fontSize: 20,
                  ),
                  SizedBox(height: 24.h),
                  if (isError)
                    TextWidget(
                      text: errorMessage!,
                      color: const Color(0xFFD93535),
                      textAlign: TextAlign.center,
                      fontSize: 14,
                    ),
                  const Spacer(),
                  MainTextButton(
                    buttonName: 'Send results to server',
                    onPressed: () => sendPathfinderResult(urlString),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
