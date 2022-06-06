import 'package:flutter/material.dart';
import 'main.dart';
import 'pdf_reader.dart';

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
    // я хз. Я так и не заюзал еще стримы. Вот учусь...ок ща
    //if (dataFromField.)
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/logo.png',
          height: 70,
          alignment: Alignment.centerLeft,
        ),
      ),  // типо при разных нажатиях будут разные страницы открываться
      body: StreamBuilder<String>(
        stream: dataFromField.stream,
        builder: (context, snapshot) {
          if(snapshot.hasData)
            return Text(snapshot.data!);
          return CircularProgressIndicator();
        },
      ),
      // тут надо вот смотреть и разные виды делать.
    );
  }
}