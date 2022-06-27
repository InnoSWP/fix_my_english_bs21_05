import 'dart:async';

import 'package:flutter/material.dart';
import 'package:swp/utils/text_highlighter.dart';
import '../utils/analysis_data.dart';

class AnalyzedTextController {
  late Function(Future<AnalyzedText>) changeFutureCallback;
  late Function(AnalyzedText) changeDirectCallback;
  AnalyzedText? currentAnalysis;

  void changeAnalysisFuture(Future<AnalyzedText> analysis) {
    changeFutureCallback(analysis);
  }

  void changeAnalysisDirect(AnalyzedText analysis) {
    changeDirectCallback(analysis);
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
  late ValueNotifier<String> descriptionListener;

  void _updateByFutureText(Future<AnalyzedText> newAnalysis) {
    newAnalysis.then((value) => {controller.currentAnalysis = value});
    setState(() {
      analysis = newAnalysis;
    });
  }

  void _updateByDirectText(AnalyzedText newAnalysis) {
    controller.currentAnalysis = newAnalysis;
    _updateByFutureText(_pseudoFuture(newAnalysis));
  }

  Future<AnalyzedText> _pseudoFuture(AnalyzedText directAnalysis) async {
    return directAnalysis;
  }

  @override
  void initState() {
    super.initState();
    //Get AnalysisData future from parent
    analysis = super.widget.analysis;
    //Get controller from parent
    controller = super.widget.controller;
    controller.changeFutureCallback = _updateByFutureText;
    controller.changeDirectCallback = _updateByDirectText;
    analysis.then((value) => {controller.currentAnalysis = value});
    descriptionListener =
        ValueNotifier<String>('Hover highlighted sentence for information.');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AnalyzedText>(
      future: analysis,
      builder: (BuildContext context, AsyncSnapshot<AnalyzedText> snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          //If future receive text, show it
          //debugPrint(snapshot.data!.analyzedSentences.toString());
          if (snapshot.data!.analyzedSentences.isEmpty) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(12),
                  color: const Color(0xECFBFDF7),
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Wow, man! Your text does not have mistakes. Respect!',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 35,
                        fontFamily: 'Merriweather',
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          List<TextSpan> text = [];
          List<HighlighCharacter> highlightMap =
              getHighlightMap(snapshot.data!);
          for (int i = 0; i < highlightMap.length; i++) {
            if (highlightMap[i].isHighligh) {
              text.add(
                TextSpan(
                  text: snapshot.data!.rawText[i],
                  style: const TextStyle(
                    backgroundColor: Color(0xffeed912),
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Merriweather',
                    fontWeight: FontWeight.bold,
                    //fontStyle: FontStyle.italic,
                  ),
                  onEnter: (event) {
                    descriptionListener.value =
                        highlightMap[i].analysisSentence!.description;
                  },
                ),
              );
            } else {
              text.add(
                TextSpan(
                  text: snapshot.data!.rawText[i],
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Merriweather',
                  ),
                ),
              );
            }
          }
          return Column(
            children: [
              Expanded(
                flex: 10,
                //child: ClipRRect(
                //  borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  //margin: const EdgeInsets.all(7),
                  padding: const EdgeInsets.all(12),
                  //0xFFFBFDF7
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFFFBFDF7),
                    border: Border.all(
                      color: const Color(0xFF864921),
                      width: 2,
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: ScrollController(),
                    child: RichText(
                      text: TextSpan(children: text),
                    ),
                  ),
                  // ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 10,
                      //child: ClipRRect(
                      //   borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xFFFBFDF7),
                          border: Border.all(
                            color: const Color(0xFF864921),
                            width: 2,
                          ),
                        ),
                        child: ValueListenableBuilder<String>(
                          valueListenable: descriptionListener,
                          builder: (context, value, child) {
                            return Center(
                              child: Text(
                                value,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontFamily: 'Merriweather',
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'Hover highlighted sentence',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Merriweather',
                            ),
                          ),
                        ),
                        // ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      //child: ClipRRect(
                      //  borderRadius: BorderRadius.circular(20),
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.07,
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xFFFBFDF7),
                            border: Border.all(
                              color: const Color(0xFF864921),
                              width: 2,
                            ),
                          ),
                          child: Tooltip(
                            decoration: const BoxDecoration(
                              color: Color(0xFFFBFDF7),
                            ),
                            message: 'Number of mistakes',
                            textStyle: const TextStyle(
                              fontSize: 19,
                              color: Color(0xFF864921),
                              fontFamily: 'Merriweather',
                            ),
                            child: Text(
                              snapshot.data!.analyzedSentences.length
                                  .toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF864921),
                                fontSize: 35,
                                fontFamily: 'Merriweather',
                              ),
                            ),
                          )
                          // ),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          //If text is not recieved yet, show progress indicator
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              color: const Color(0xFFFBFDF7),
              alignment: Alignment.center,
              child: const CircularProgressIndicator(
                color: Color(0xFF864921),
              ),
            ),
          );
        }
      },
    );
  }
}
