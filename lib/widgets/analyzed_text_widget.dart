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
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          //If future receive text, show it
          //debugPrint(snapshot.data!.analyzedSentences.toString());
          if (snapshot.data!.analyzedSentences.isEmpty) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
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
          String letters =
              'zxcvbnmasdfghjklqwertyuiopZXCVBNMASDFGHJKLQWERTYUIOP';
          List<TextSpan> text = [];
          List<bool> used = [];
          List<String> descriptions = [];
          for (int i = 0; i < snapshot.data!.rawText.length; i++) {
            used.add(false);
            descriptions.add('');
          }
          for (var s in snapshot.data!.analyzedSentences) {
            String match = s.match.compareTo('') == 0 ? s.sentence : s.match;
            for (int i = 0; i < used.length - match.length; i++) {
              if (snapshot.data!.rawText
                          .substring(i, i + match.length)
                          .compareTo(match) ==
                      0 /*&&
                  (!letters
                          .contains(snapshot.data!.rawText[i + match.length]) ||
                      !letters.contains(snapshot.data!.rawText[i - 1]))*/
                  ) {
                used.fillRange(i, i + match.length, true);
                descriptions.fillRange(i, i + match.length, s.description);
              }
            }
          }
          for (int i = 0; i < used.length; i++) {
            if (used[i]) {
              text.add(
                TextSpan(
                  text: snapshot.data!.rawText[i],
                  style: const TextStyle(
                    backgroundColor: Color(0xffeed912),
                    //0xffeed912
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Merriweather',
                    //fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                  onEnter: (event) {
                    // debugPrint(descriptions[i]);
                    Navigator.push(
                      context,
                      DialogRoute(
                        context: context,
                        builder: (context) {
                          return SimpleDialog(title: Text(descriptions[i]));
                        },
                      ),
                    );
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
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.all(12),
                color: const Color(0xFFFBFDF7),
                child: RichText(
                  text: TextSpan(children: text),
                ),
              ),
            ),
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
