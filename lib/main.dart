import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pathfinder/bloc/pathfinder_bloc.dart';
import 'package:pathfinder/pages/home_page.dart';

void main() async {
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
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      child: BlocProvider(
        create: (context) => PathfinderBloc(),
        child: Container(
          color: const Color.fromARGB(255, 110, 230, 11),
          child: SafeArea(
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Pathfinder',
              theme: ThemeData(
                scaffoldBackgroundColor: const Color(0xFF141B22),
                textTheme: const TextTheme(
                  bodyMedium: TextStyle(
                    color: Color(0xFFF2F2F2),
                    fontSize: 16,
                    height: 1.4,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              home: const HomePage(),
            ),
          ),
        ),
      ),
    );
  }
}
