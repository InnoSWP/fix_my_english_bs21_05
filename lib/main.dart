import 'package:flutter/material.dart';
import 'package:swp/utils/moofiy_color.dart';
import 'pages/root_widget.dart';

//Entry point of our application
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
