import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pathfinder/bloc/pathfinder_bloc.dart';
import 'package:pathfinder/bloc/pathfinder_event.dart';
import 'package:pathfinder/components/header.dart';
import 'package:pathfinder/components/main_text_button.dart';
import 'package:pathfinder/components/text_widget.dart';
import 'package:pathfinder/components/url_input.dart';
import 'package:pathfinder/pages/process_page.dart';
import 'package:pathfinder/repositories/pathfinder_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _urlController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final String urlString = 'https://flutter.webspark.dev/flutter/api';

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

  bool isValidUrl(String url) {
    final Uri? uri = Uri.tryParse(url);
    return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
  }

  Future<void> fetchPathfinderFields(String url) async {
    if (!isValidUrl(url)) {
      setState(() {
        isError = true;
        errorMessage = 'Invalid URL. Please, try again';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
      isError = false;
    });

    try {
      final result = await pathfinderRepository.getFields(urlString: url);

      if (mounted) {
        context.read<PathfinderBloc>().add(SavePathfinderData(result['data']));
        context.read<PathfinderBloc>().add(SavePathfinderUrl(url));
      }

      setState(() {
        isLoading = false;

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProcessPage()),
          );
        }
      });
    } catch (error) {
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
            title: 'Home screen',
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                children: [
                  const TextWidget(
                      text: 'Set valid API base URL in order to continue'),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Form(
                      key: _formKey,
                      child: UrlInput(
                        controller: _urlController,
                        label: 'Set URL',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  if (isError)
                    TextWidget(
                      text: errorMessage!,
                      textAlign: TextAlign.center,
                      color: const Color(0xFFD93535),
                      fontSize: 14,
                    ),
                  if (isLoading) const Spacer(),
                  if (isLoading)
                    const CircularProgressIndicator(
                        color: Color.fromARGB(255, 110, 230, 11)),
                  const Spacer(),
                  MainTextButton(
                      buttonName:
                          isLoading ? 'Loading....' : 'Start counting process',
                      isDisabled: isLoading,
                      onPressed: () =>
                          fetchPathfinderFields(_urlController.text)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
