import 'dart:ui';
import 'package:flutter/material.dart';
import 'pages.dart';

void main() {
  runApp(const FixMyEnglishApp());
}

final themeData = ThemeData(
  scaffoldBackgroundColor: const Color(0xFFF2EEE1),
  primaryColor: const Color(0xFF864921),
  primaryColorDark: const Color(0xFF7A370B),
  primaryColorLight: const Color(0xFFF2EEE1),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFF2EEE1),
    titleTextStyle:
        TextStyle(color: Color(0xFF864921), fontSize: 50, fontFamily: 'Eczar'),
  ),
  hintColor: const Color(0xFF7A370B),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        onPrimary: const Color(0xFFE9F1E8),
        primary: const Color(0xFF864921),
        textStyle: const TextStyle(fontFamily: 'Eczar')),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    fillColor: Color(0xFFFBFDF7), //0xFFF2EEE1
    filled: true,
    floatingLabelStyle: TextStyle(color: Color(0xFF864921)),
  ),
);

class FixMyEnglishApp extends StatelessWidget {
  const FixMyEnglishApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fix my English',
      theme: themeData,
      home: const RootWidget(),
    );
  }
}

///The root widget to display appropriate page widget depending on current page.
class RootWidget extends StatefulWidget {
  const RootWidget({Key? key}) : super(key: key);

  @override
  State<RootWidget> createState() => _RootWidget();
}

//Application pages
enum AppPages { startPage, mainPage }

///Class that represents state controll of root widget
class _RootWidget extends State<RootWidget> {
  //Current application page
  late AppPages appState;

  //Start page widget
  late StartPageWidget startPage;

  //Main page widget
  late MainPageWidget mainPage;

  @override
  void initState() {
    super.initState();

    //The inital page is start page
    appState = AppPages.startPage;

    //Create start page widget, and listen for uploading event
    startPage = StartPageWidget(onFileUploaded: (requests) {
      setState(() {
        //When user uploads files switch to main page
        appState = AppPages.mainPage;
        //Provide all requests made in start page to main page
        mainPage.addManyAnalyses(requests);
      });
    });

    //Create main page widget
    mainPage = MainPageWidget();
  }

  @override
  Widget build(BuildContext context) {
    //Depending on current application page load appropriate page widget
    switch (appState) {
      case AppPages.startPage:
        return startPage;
      case AppPages.mainPage:
        return mainPage;
    }
  }
}
