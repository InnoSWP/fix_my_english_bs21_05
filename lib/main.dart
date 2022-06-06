import 'dart:async';
import 'dart:ui';
import 'analysis_page.dart';
import 'package:flutter/material.dart';
import 'pdf_reader.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const MyApp());
}

late StreamController<String> dataFromField = StreamController();
late StreamController<List<String>> dataFromPDF = StreamController();

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
                        goToAnalysisPage();
                        dataFromField.add(value);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50, bottom: 50),
                    child: TextButton(
                      onPressed: goToAnalysisPage,
                      child: const Text("Submit for analysis"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(50),
                    child: TextButton(
                      onPressed: uploadPDF,
                      child: Text("Submit the PDF files"),),
                  )
                  //Text(data)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void goToAnalysisPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
        const MyAnalysisPage(
          title: 'Fix My English',
        ),
      ),
    );
  }

  void uploadPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true, type: FileType.custom, allowedExtensions: ["pdf"]);
    if(result != null) {
      List<String> pdfTexts = [];
      for(PlatformFile file in result.files) {
        pdfTexts.add(PDFToRawTextConverter(file.bytes!).result);
      }
      dataFromPDF.add(pdfTexts);
    }
  }
}
