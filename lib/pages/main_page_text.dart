import 'package:flutter/material.dart';
import '../utils/analysis_data.dart';
import '../widgets/analyzed_text_widget.dart';
import '../utils/api_interactions.dart';

///Main page widget. Works with futures to show text analyses
class MainPageWidget extends StatefulWidget {
  //List with all analyses that user has
  final List<Future<AnalyzedText>> analysisRequests = [];

  MainPageWidget({Key? key}) : super(key: key);

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

///Class that represents state controll of MainPageWidget
class _MainPageWidget extends State<MainPageWidget> {
  TextEditingController textEditingController = TextEditingController();
  AnalyzedTextController analyzedTextController = AnalyzedTextController();

  bool canUpdateText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          shadowColor: const Color(0xFFA20505),
          title: const Text(
            'iExtract',
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
      body: SafeArea(
        child: Center(
          child: Row(
            children: [
              SafeArea(
                minimum: const EdgeInsets.all(20),
                child: ClipRRect(
                  //borderRadius: BorderRadius.circular(20),
                  child: Container(
                    ///decoration: const BoxDecoration(),
                    //color: const Color(0xFFFBFDF7),
                    padding: const EdgeInsets.only(
                        right: 10, left: 10, top: 15, bottom: 15),
                    //margin: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: MediaQuery.of(context).size.height * 0.9,
                    alignment: Alignment.centerLeft,
                    child: AnalyzedTextWidget(
                      analysis: widget.analysisRequests.first,
                      controller: analyzedTextController,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 23),
                      width: MediaQuery.of(context).size.width * 0.32,
                      height: MediaQuery.of(context).size.height * 0.8,
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
                              debugPrint(snapshot.data!.rawText);
                            }

                            return TextFormField(
                              controller: textEditingController,
                              minLines: 100,
                              maxLines: 100,
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
                                      color: Theme.of(context).primaryColorDark,
                                      style: BorderStyle.solid),
                                ),
                                border: const OutlineInputBorder(),
                                label: const Text('Your text for analyzing'),
                              ),
                              cursorColor: Theme.of(context).primaryColorDark,
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
                    ),
                    SafeArea(
                      //minimum: const EdgeInsets.only(left: 20, right: 20),
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        width: MediaQuery.of(context).size.width * 0.32,
                        height: MediaQuery.of(context).size.height * 0.12,
                        child: Stack(
                          children: [
                            Expanded(
                              flex: 9,
                              child: Container(
                                alignment: Alignment.bottomLeft,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    analyzedTextController.changeAnalysis(
                                        sendToIExtract(
                                            textEditingController.text));

                                    //canUpdateText = true;
                                  },
                                  label: const Text(
                                    "Analyze the text",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  icon: const Icon(Icons.short_text, size: 60),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.bottomRight,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    //TODO: Extract function
                                  },
                                  label: const Text(
                                    "Export CSV",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  icon: const Icon(Icons.arrow_downward,
                                      size: 60),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
