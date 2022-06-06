import 'package:flutter/material.dart';
import 'analysis_data.dart';

///Widget to show text analyzed by IExtract with all highlighting and other stuff (will be implemented soon)
///This widget uses futures to load text!
class AnalyzedTextWidget extends StatefulWidget {
  final Future<AnalysisData> analysis;

  ///Constructs AnalyzedTextWidget
  ///
  ///Requires future of AnalysisData class instance [analysis]
  const AnalyzedTextWidget({Key? key, required this.analysis})
      : super(key: key);

  @override
  State<AnalyzedTextWidget> createState() => _AnalyzedTextWidget();
}

///Class that represent state controll of AnalyzedTextWidget
class _AnalyzedTextWidget extends State<AnalyzedTextWidget> {
  //Future of AnalysisData
  late Future<AnalysisData> analysis;

  @override
  void initState() {
    super.initState();
    //Get AnalysisData future from parent
    analysis = super.widget.analysis;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AnalysisData>(
        future: analysis,
        builder: (BuildContext context, AsyncSnapshot<AnalysisData> snapshot) {
          if (snapshot.hasData) {
            //If future recieve text, show it
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(snapshot.data!.rawText),
            );
          } else {
            //If text is not recieved yet, show progress indicator
            return const SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}