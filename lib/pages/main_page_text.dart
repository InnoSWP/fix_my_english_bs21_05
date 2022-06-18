import 'package:flutter/material.dart';
import '../utils/analysis_data.dart';
import '../widgets/analyzed_text_widget.dart';
import '../utils/api_interactions.dart';

///Main page widget. Works with futures to show text analyses
class MainPageWidget extends StatefulWidget {
  //List with all analyses that user has
  final List<Future<AnalyzedText>> analysisRequests = [];

  ///Adds new analysis to list. Needs future of AnalysisData [request]
  void addNewAnalysis(Future<AnalyzedText> request) {
    analysisRequests.add(request);
  }

  ///Adds multiple analysis to list. Needs list of futures of AnalysisData [request]
  void addManyAnalyses(List<Future<AnalyzedText>> requests) {
    for (Future<AnalyzedText> request in requests) {
      analysisRequests.add(request);
    }
  }

  @override
  State<MainPageWidget> createState() => _MainPageWidget();
}

///Class that represents state control of TextPageWidget
class _MainPageWidget extends State<MainPageWidget> {
  bool canUpdateText = true;

  @override
  Widget build(BuildContext context) {
    AnalyzedTextController analyzedTextController = AnalyzedTextController();
    TextEditingController textEditingController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'iExtract',
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
      body: SafeArea(
        child: Center(
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(45),
                  child: Container(
                    ///decoration: const BoxDecoration(),
                    //color: const Color(0xFFFBFDF7),
                    padding: const EdgeInsets.all(12),
                    alignment: Alignment.centerLeft,
                    child: AnalyzedTextWidget(
                      analysis: widget.analysisRequests.first,
                      controller: analyzedTextController,
                    ),
                  ),
                ),
              ),
              Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Expanded(
                            flex: 9,
                            child: Container(
                              alignment: Alignment.topRight,
                              //widget.analysisRequests.first
                              child: FutureBuilder(
                                future: widget.analysisRequests.first,
                                builder: (BuildContext context,
                                    AsyncSnapshot<AnalyzedText> snapshot) {
                                  if (snapshot.hasData) {
                                    if (canUpdateText) {
                                      textEditingController.text =
                                          snapshot.data!.rawText;
                                      canUpdateText = false;
                                    }

                                    return TextFormField(
                                      controller: textEditingController,
                                      minLines: null,
                                      maxLines: null,
                                      expands: true,
                                      keyboardType: TextInputType.multiline,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Merriweather',
                                      ),
                                      decoration: InputDecoration(
                                        labelStyle: const TextStyle(
                                          fontSize: 20,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(2.0)),
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                              style: BorderStyle.solid),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(2.0)),
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                              style: BorderStyle.solid),
                                        ),
                                        border: const OutlineInputBorder(),
                                        label: const Text(
                                            'Your text for analyzing'),
                                      ),
                                      cursorColor:
                                          Theme.of(context).primaryColorDark,
                                    );
                                  } else {
                                    return Container(
                                      alignment: Alignment.center,
                                      child: CircularProgressIndicator(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    );
                                  }
                                },
                              ),
                            )),
                        Expanded(
                          flex: 1,
                          child: Row(children: [
                            Expanded(
                                flex: 5,
                                child: Container(
                                  alignment: Alignment.bottomLeft,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      analyzedTextController
                                          .changeAnalysisFuture(sendToIExtract(
                                              textEditingController.text));
                                    },
                                    label: const Text(
                                      "Analyze the text",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    icon:
                                        const Icon(Icons.short_text, size: 50),
                                  ),
                                )),
                            Expanded(
                                flex: 5,
                                child: Container(
                                  alignment: Alignment.bottomRight,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      if (analyzedTextController
                                              .currentAnalysis !=
                                          null) {
                                        analyzedTextController.currentAnalysis!
                                            .saveAsCSV();
                                      }
                                    },
                                    label: const Text(
                                      "Export CSV",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    icon: const Icon(Icons.arrow_downward,
                                        size: 50),
                                  ),
                                )),
                          ]),
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
