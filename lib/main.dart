import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pathfinder/pages/home_page.dart';

void main() async {
  // vertical orientation screen lock
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((fn) async {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF58B90A),
      child: SafeArea(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Pathfinder',
          theme: ThemeData(
            fontFamily: 'Poppins',
            scaffoldBackgroundColor: const Color(0xFFF2F2F2),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(
                color: Color(0xFF131A21),
                fontSize: 16,
                height: 1.4,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          home: const HomePage(title: 'Home page'),
          // onGenerateRoute: AppPages.GenerateRouteSettings,
        ),
      ),
    );
  }
}
