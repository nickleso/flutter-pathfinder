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
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    pathfinderRepository = PathfinderRepository();

    final blocState = context.read<PathfinderBloc>().state as PathfinderLoaded;
    pathfinderData = blocState.data;

    calculatPathfinderData();
  }

  void calculatPathfinderData() async {
    List<Map<String, dynamic>> results = [];
    List<Map<String, dynamic>> updatedData = [];

    for (var i = 0; i < pathfinderData!.length; i++) {
      var obj = pathfinderData![i];

      List<String> field = List<String>.from(obj['field']);
      Map<String, int> start = Map<String, int>.from(obj['start']);
      Map<String, int> end = Map<String, int>.from(obj['end']);

      List<Map<String, int>>? path = await bfs(
        field,
        start,
        end,
        (double currentProgress) {
          setState(() {
            progress = currentProgress;
          });
        },
        i,
        pathfinderData!.length,
      );

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
    if (mounted) {
      context.read<PathfinderBloc>().add(SavePathfinderData(updatedData));
    }

    setState(() {
      progress = 1.0;
    });
  }

  Future<void> sendPathfinderResult(String url) async {
    setState(() {
      isCalculating = false;
      isLoading = true;
      errorMessage = null;
      isError = false;
    });

    try {
      await pathfinderRepository.sendResult(
        urlString: url,
        body: pathfinderData!,
      );

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
                        : progress == 1.0
                            ? 'All calculations have finished. You can send results to the server.'
                            : 'Calculating...',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  if (isLoading)
                    const CircularProgressIndicator(
                        color: Color.fromARGB(255, 110, 230, 11)),
                  SizedBox(height: 24.h),
                  if (isCalculating)
                    Column(
                      children: [
                        CircularProgressIndicator(
                          value: progress,
                          color: const Color.fromARGB(255, 110, 230, 11),
                        ),
                        SizedBox(height: 12.h),
                        TextWidget(
                          text: '${(progress * 100).toStringAsFixed(0)}%',
                          fontSize: 18,
                          color: const Color(0xFFF2F2F2),
                          fontWeight: FontWeight.w500,
                        ),
                      ],
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
                  if (progress == 1.0)
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
