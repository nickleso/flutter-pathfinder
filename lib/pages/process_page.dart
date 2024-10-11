import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pathfinder/components/header.dart';
import 'package:pathfinder/components/main_text_button.dart';
import 'package:pathfinder/components/text_widget.dart';
import 'package:pathfinder/pages/preview_page.dart';
import 'package:pathfinder/pages/result_list_page.dart';
import 'package:pathfinder/repositories/pathfinder_repository.dart';

class ProcessPage extends StatefulWidget {
  const ProcessPage({super.key});

  @override
  State<ProcessPage> createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage> {
  late final PathfinderRepository pathfinderRepository;
  Map<String, dynamic> searchResults = {};
  String? errorMessage;
  bool isLoading = false;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    pathfinderRepository = PathfinderRepository();
  }

  Future<void> fetchPathfinderFields(String url) async {
    print('****');

    setState(() {
      isLoading = true;
      errorMessage = null;
      isError = false;
    });

    try {
      final result =
          await pathfinderRepository.sendResult(urlString: url, body: [
        {
          "id": "7d785c38-cd54-4a98-ab57-44e50ae646c1",
          "result": {
            "steps": [
              {"x": "0", "y": "0"},
              {"x": "0", "y": "1"}
            ],
            "path": "(0,0)->(0,1)"
          }
        }
      ]);

      print('****result: ${result['data']}');

      setState(() {
        // searchResults = result;
        isLoading = false;

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ResultListPage()),
          );
        }
      });
    } catch (error) {
      print('****error: $error');

      setState(() {
        isError = true;
        errorMessage = error.toString();
        searchResults = {};
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Header(
            title: 'Process screen',
            withButton: true,
          ),
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
                        : 'All calculations has finished, you can send your results to server',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12.h),
                  const TextWidget(
                    text: '100%',
                    textAlign: TextAlign.center,
                    fontSize: 20,
                  ),
                  const Spacer(),
                  // MainTextButton(
                  //   buttonName: 'Send results to server',
                  //   onPressed: () => Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const ResultListPage()),
                  //   ),
                  // ),
                  MainTextButton(
                    buttonName: 'Send results to server',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PreviewPage()),
                    ),
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
