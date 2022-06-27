import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'pages/starting_page.dart';
import 'pages/main_page_text.dart';
import 'pages/main_page_files.dart';
import 'pages/root_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const FixMyEnglishApp());
}

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
