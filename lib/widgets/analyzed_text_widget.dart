import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:swp/utils/moofiy_color.dart';
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
  const AnalyzedTextWidget({
    Key? key,
    required this.analysis,
    required this.controller,
  }) : super(key: key);

  @override
  State<AnalyzedTextWidget> createState() => _AnalyzedTextWidget();
}

///Class that represent state control of AnalyzedTextWidget
class _AnalyzedTextWidget extends State<AnalyzedTextWidget> {
  //Future of AnalysisData
  late Future<AnalyzedText> analysis;
  late AnalyzedTextController controller;
  late ValueNotifier<AnalyzedSentence> sentenceListener;

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
    sentenceListener = ValueNotifier<AnalyzedSentence>(AnalyzedSentence(
        match: '',
        label: 'Here will be type of mistake',
        sentence: '',
        description: 'Click on highlighted sentence for information.'));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AnalyzedText>(
      future: analysis,
      builder: (BuildContext context, AsyncSnapshot<AnalyzedText> snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          //If future receive text, show it
          if (snapshot.data!.analyzedSentences.isEmpty) {
            return ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(12),
                  color: const Color(0xECFBFDF7),
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(children: [
                      Expanded(
                          flex: 5,
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: const Icon(
                              Icons.task_alt,
                              size: 70,
                              color: MoofiyColors.colorTextSmoothBlack,
                            ),
                          )),
                      const Expanded(
                          flex: 5,
                          child: Text(
                            'No issues found!',
                            style: TextStyle(
                              color: MoofiyColors.colorTextSmoothBlack,
                              fontSize: 25,
                              fontFamily: 'Merriweather',
                            ),
                          ))
                    ]),
                  ),
                ));
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
                    //background: ,
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Merriweather',
                    fontWeight: FontWeight.bold,
                    //fontStyle: FontStyle.italic,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => sentenceListener.value =
                        highlightMap[i].analysisSentence!,
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
                      text: TextSpan(
                          children: text, style: const TextStyle(height: 1.7)),
                    ),
                  ),
                  // ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(top: 5),
                    //height: MediaQuery.of(context).size.height * 0.07,
                    //padding: const EdgeInsets.all(19),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFFFBFDF7),
                      border: Border.all(
                        color: const Color(0xFF864921),
                        width: 2,
                      ),
                    ),
                    child: Stack(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: ValueListenableBuilder<AnalyzedSentence>(
                            valueListenable: sentenceListener,
                            builder: (context, value, child) {
                              return Text(
                                '${value.label}\n${value.description}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontFamily: 'Merriweather',
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          margin: const EdgeInsets.only(right: 5, bottom: 15),
                          child: IconButton(
                            alignment: Alignment.topRight,
                            tooltip: 'Report about wrong mistake',
                            icon: const Icon(
                              Icons.report,
                              size: 35,
                            ),
                            color: const Color(0xffbb0d0d),
                            onPressed: () {
                              if (sentenceListener.value.sentence
                                      .compareTo('') ==
                                  0) {
                                return;
                              }
                              addMistakeToFirestore(
                                  sentenceListener.value.toJson());
                            },
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          );
        } else {
          //If text is not received yet, show progress indicator
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
