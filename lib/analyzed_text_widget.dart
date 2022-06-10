import 'package:flutter/material.dart';
import 'analysis_data.dart';

class AnalyzedTextController {
  late Function updateCallback;

  void changeAnalysis(Future<AnalyzedText> analysis) {
    updateCallback(analysis);
  }
}

///Widget to show text analyzed by IExtract with all highlighting and other stuff (will be implemented soon)
///This widget uses futures to load text!
class AnalyzedTextWidget extends StatefulWidget {
  final Future<AnalyzedText> analysis;
  final AnalyzedTextController controller;

  ///Constructs AnalyzedTextWidget
  ///
  ///Requires future of AnalysisData class instance [analysis]
  const AnalyzedTextWidget(
      {Key? key, required this.analysis, required this.controller})
      : super(key: key);

  @override
  State<AnalyzedTextWidget> createState() => _AnalyzedTextWidget();
}

///Class that represent state controll of AnalyzedTextWidget
class _AnalyzedTextWidget extends State<AnalyzedTextWidget> {
  //Future of AnalysisData
  late Future<AnalyzedText> analysis;
  late AnalyzedTextController controller;

  void updateText(Future<AnalyzedText> newAnalysis) {
    setState(() {
      analysis = newAnalysis;
    });
  }

  @override
  void initState() {
    super.initState();
    //Get AnalysisData future from parent
    analysis = super.widget.analysis;
    //Get controller from parent
    controller = super.widget.controller;
    controller.updateCallback = updateText;
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
              if (snapshot.data!.analyzedSentences[index].label == 'WORDNES3') {
                return RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            '${snapshot.data!.analyzedSentences[index].sentence}\n',
                        style: const TextStyle(
                          backgroundColor: Color(0xFFDC7024),
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Merriweather',
                        ),
                      ),
                      TextSpan(
                        text:
                            '${snapshot.data!.analyzedSentences[index].description}\n',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontFamily: 'Merriweather',
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: snapshot.data!.analyzedSentences[index]
                          .splitOnThree()[0],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Merriweather',
                      ),
                    ),
                    TextSpan(
                      text: snapshot.data!.analyzedSentences[index]
                          .splitOnThree()[1],
                      style: const TextStyle(
                        backgroundColor: Color(0xFFF38A40),
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Merriweather',
                      ),
                    ),
                    TextSpan(
                      text:
                          '${snapshot.data!.analyzedSentences[index].splitOnThree()[2]}\n',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Merriweather',
                      ),
                    ),
                    TextSpan(
                      text:
                          '${snapshot.data!.analyzedSentences[index].description}\n',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontFamily: 'Merriweather',
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          //If text is not recieved yet, show progress indicator
          return Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator(
              color: Color(0xFF864921),
            ),
          );
        }
      },
    );
  }
}
