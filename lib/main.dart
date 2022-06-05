import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

late StreamController<String> data1;
late StreamController<List<String>> data2;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fix My English',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            const SafeArea(
              child: Text(
                "Fix My English",
                style: TextStyle(fontSize: 30),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 50,
                      ),
                      child: Text(
                        "Write your text below",
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20, left: 50, right: 50),
                    child: TextField(
                      maxLines: 10,
                      selectionHeightStyle:
                          BoxHeightStyle.includeLineSpacingBottom,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Text",
                        labelStyle: TextStyle(),
                      ),
                      onSubmitted: (String value) async {
                        data1.add(value);
                        goToSecond();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50, bottom: 50),
                    child: TextButton(
                      onPressed: goToSecond,
                      child: const Text("Submit for analysis"),
                    ),
                  ),
                  //Text(data)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void goToSecond() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const MyAnalysisPage(
                  title: 'Fix My English',
                )));
  }
}

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fix My English',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Analysis'),
    );
  }
}

class MyAnalysisPage extends StatefulWidget {
  const MyAnalysisPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyAnalysisPage> createState() => _MyAnalysisPageState();
}

class _MyAnalysisPageState extends State<MyAnalysisPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/logo.png',
          height: 70,
          alignment: Alignment.centerLeft,
        ),
      ),
      body: Text("asdaslkfjasdkfjas"),
    );
  }
}
