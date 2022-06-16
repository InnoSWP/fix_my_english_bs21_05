import 'package:flutter/material.dart';
import 'analysis_data.dart';
import 'analyzed_text_widget.dart';
import 'api_interactions.dart';

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
              SafeArea(
                minimum: const EdgeInsets.all(20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(45),
                  child: Container(
                    color: const Color(0xFFFBFDF7),
                    padding: const EdgeInsets.only(
                        right: 10, left: 10, top: 25, bottom: 25),
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
              Column(
                children: [
                  SafeArea(
                    minimum: const EdgeInsets.only(top: 25, left: 20),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.5,
                      alignment: Alignment.topRight,
                      //widget.analysisRequests.first
                      child: FutureBuilder(
                        future: widget.analysisRequests.first,
                        builder: (BuildContext context,
                            AsyncSnapshot<AnalyzedText> snapshot) {
                          if (snapshot.hasData) {
                            debugPrint(snapshot.data!.rawText);
                            textEditingController.text = snapshot.data!.rawText;
                            return TextFormField(
                              //initialValue: snapshot.data!.rawText,
                              controller: textEditingController,
                              minLines: 25,
                              maxLines: 25,
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
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        analyzedTextController.changeAnalysis(
                            sendToIExtract(textEditingController.text));
                      },
                      label: const Text(
                        "Update the text",
                        style: TextStyle(fontSize: 20),
                      ),
                      icon: const Icon(Icons.short_text, size: 60),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 8,
                        left: 20,
                        right: 20),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        //TODO: Extract function
                      },
                      label: const Text(
                        "Export CSV",
                        style: TextStyle(fontSize: 20),
                      ),
                      icon: const Icon(Icons.arrow_downward, size: 60),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
