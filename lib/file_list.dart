import 'package:flutter/material.dart';
import 'analysis_data.dart';

class FileListController {}

class FileListWidget extends StatefulWidget {
  FileListController controller;
  List<Future<AnalyzedText>> info;

  FileListWidget({Key? key, required this.controller, required this.info})
      : super(key: key);

  @override
  State<FileListWidget> createState() => _FileListWidget();
}

class _FileListWidget extends State<FileListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return const ListTile(
          leading: Icon(Icons.file_present_rounded),
          title: const Text("File"),
        );
      },
      itemCount: widget.info.length,
    );
  }
}
