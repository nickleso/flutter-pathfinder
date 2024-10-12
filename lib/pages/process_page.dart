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
import 'package:pathfinder/utils/bfs_algorithm.dart';

class ProcessPage extends StatefulWidget {
  const ProcessPage({super.key});

  @override
  State<ProcessPage> createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage> {
  late final PathfinderRepository pathfinderRepository;
  bool isLoading = false;
  bool isCalculating = true;
  bool isError = false;
  String? errorMessage;
  List<dynamic>? pathfinderData;

  @override
  void initState() {
    super.initState();
    pathfinderRepository = PathfinderRepository();

    final blocState = context.read<PathfinderBloc>().state as PathfinderLoaded;
    pathfinderData = blocState.data;

    Future.delayed(const Duration(seconds: 1), () {
      print('One second has passed.'); // Prints after 1 second.
      calculatPathfinderData();
    });
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

    setState(() {
      isCalculating = false;
    });
  }

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
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ResultListPage()),
          );
        }
        isLoading = false;
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
                        ? 'Sending...'
                        : isCalculating
                            ? 'Calculating...'
                            : 'All calculations have finished. You can send results to the server.',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  if (isLoading)
                    const CircularProgressIndicator(
                        color: Color.fromARGB(255, 110, 230, 11)),
                  SizedBox(height: 24.h),
                  if (!isLoading)
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
                    buttonName:
                        isLoading ? 'Sending...' : 'Send results to server',
                    isDisabled: isLoading,
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
