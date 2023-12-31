import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:simple_todo_app/core/project_constants.dart';
import 'package:simple_todo_app/screens/home_page.dart';
import 'package:simple_todo_app/uses_cases/network_change/no_network_widget.dart';
import 'package:simple_todo_app/view_models/home_view_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      builder: (context, child) => MaterialApp(
        title: 'Simple Todo',
        theme: ProjectConstants.lightTheme,
        darkTheme: ProjectConstants.darkTheme,
        themeMode: ThemeMode.system,
        builder: (context, child) {
          return Column(
            children: [
              Expanded(child: child ?? const SizedBox()),
              const NoNetworkWidget(),
            ],
          );
        },
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
