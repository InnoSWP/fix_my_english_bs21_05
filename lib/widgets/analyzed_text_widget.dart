import 'package:flutter/material.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AnalyzedText>(
      future: analysis,
      builder: (BuildContext context, AsyncSnapshot<AnalyzedText> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          //If future recieve text, show it
          return ListView.builder(
            itemCount: snapshot.data!.analyzedSentences.length,
            itemBuilder: (BuildContext context, int index) {
              var label = snapshot.data!.analyzedSentences[index].label;
              Color color = const Color(0xFFF38A40);
              if (label == 'DIGIT8') {
                color = const Color(0xFFF34545);
              } else if (label == 'PRONOUN4') {
                color = const Color(0xFFFCAE10);
              } else if (label == 'SPOKN1') {
                color = const Color(0xFFFF7134);
              } else if (label == 'VOCAB5') {
                color = const Color(0xFFFF0000);
              } else if (label == 'WORNES3') {
                color = const Color(0xFFFF6C00);
              }
              Widget result = const Text('asd'); //Чо за асд? Это кто
              if (snapshot.data!.analyzedSentences[index].match == '' &&
                  label == 'WORDNES3') {
                result = Tooltip(
                  message: snapshot.data!.analyzedSentences[index].description,
                  decoration: const BoxDecoration(
                    color: Colors.white38,
                    shape: BoxShape.rectangle,
                  ),
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Merriweather',
                    fontWeight: FontWeight.bold,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      alignment: Alignment.topCenter,
                      margin: const EdgeInsets.all(5),
                      color: const Color(0xFFFBFDF7),
                      child: Text(
                        '${snapshot.data!.analyzedSentences[index].sentence}\n',
                        style: TextStyle(
                          backgroundColor: color,
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Merriweather',
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                result = Column(
                  children: [
                    Tooltip(
                      message:
                          snapshot.data!.analyzedSentences[index].description,
                      decoration: const BoxDecoration(
                        color: Colors.black12,
                        shape: BoxShape.rectangle,
                      ),
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontFamily: 'Merriweather',
                        fontWeight: FontWeight.bold,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          alignment: Alignment.topCenter,
                          padding: const EdgeInsets.only(
                              top: 10, right: 10, left: 10),
                          color: const Color(0xFFFBFDF7),
                          child: RichText(
                            textAlign: TextAlign.left,
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
                                  style: TextStyle(
                                    backgroundColor: color,
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                );
              }
              return result;
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
