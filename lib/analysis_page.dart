import 'package:flutter/material.dart';
import 'main.dart';
import 'pdf_reader.dart';
import 'main.dart';

class _MyAnalysisPageState extends State<MyHomePage> {

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
      body: Text(widget.text),
      // тут надо вот смотреть и разные виды делать.
    );
  }
}