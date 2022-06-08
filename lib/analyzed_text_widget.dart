import 'package:flutter/material.dart';
import 'analysis_data.dart';

///Widget to show text analyzed by IExtract with all highlighting and other stuff (will be implemented soon)
///This widget uses futures to load text!
class AnalyzedTextWidget extends StatefulWidget {
  final Future<AnalyzedText> analysis;

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
  late Future<AnalyzedText> analysis;

  @override
  void initState() {
    super.initState();
    //Get AnalysisData future from parent
    analysis = super.widget.analysis;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AnalyzedText>(
        future: analysis,
        builder: (BuildContext context, AsyncSnapshot<AnalyzedText> snapshot) {
          if (snapshot.hasData) {
            //If future recieve text, show it
            return ListView.builder(
                itemCount: snapshot.data!.analyzedSentences.length,
                itemBuilder: (BuildContext context, int index) {
                  return RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: snapshot.data!.analyzedSentences[index]
                            .splitOnThree()[0],
                        style: TextStyle(color: Colors.black87)),
                    TextSpan(
                        text: snapshot.data!.analyzedSentences[index]
                            .splitOnThree()[1],
                        style: const TextStyle(
                            backgroundColor: Colors.red,
                            color: Colors.black54)),
                    TextSpan(
                        text: snapshot.data!.analyzedSentences[index]
                            .splitOnThree()[2],
                        style: TextStyle(color: Colors.black87)),
                  ]));
                });
          } else {
            //If text is not recieved yet, show progress indicator
            return Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(
                color: Color(0xFF864921),
              ),
            );
          }
        });
  }
}
