import 'package:flutter/material.dart';
import 'pages/starting_page.dart';
import 'pages/main_page_text.dart';
import 'pages/main_page_files.dart';
import 'utils/moofiy_color.dart';

void main() {
  runApp(const FixMyEnglishApp());
}

class FixMyEnglishApp extends StatelessWidget {
  const FixMyEnglishApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fix my English',
      theme: MoofiyColors.themeData,
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
enum AppPages { startPage, mainPageText, mainPageFiles }

///Class that represents state controll of root widget
class _RootWidget extends State<RootWidget> {
  //Current application page
  late AppPages appState;

  //Start page widget
  late StartPageWidget startPage;

  //Main page widget
  late MainPageWidget mainPageText;

  //Main page with files widget
  late MainPageFilesWidget mainPageFiles;
  @override
  void initState() {
    super.initState();

    //The inital page is start page
    appState = AppPages.startPage;

    //Create start page widget, and listen for uploading event
    startPage = StartPageWidget(
      onFileUploaded: (requests, mode) {
        setState(() {
          //When user uploads files switch to main page
          appState =
              mode == "text" ? AppPages.mainPageText : AppPages.mainPageFiles;
          //Provide all requests made in start page to main page
          mainPageText.addManyAnalyses(requests);
          mainPageFiles.addManyAnalyses(requests);
        });
      },
    );

    //Create main page widget
    mainPageText = MainPageWidget();
    mainPageFiles = MainPageFilesWidget();
  }

  @override
  Widget build(BuildContext context) {
    //Depending on current application page load appropriate page widget
    switch (appState) {
      case AppPages.startPage:
        return startPage;
      case AppPages.mainPageText:
        return mainPageText;
      case AppPages.mainPageFiles:
        return mainPageFiles;
    }
  }
}
