import 'analysis_data.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'analyzed_text_widget.dart';
import 'api_interactions.dart';
import 'pdf_reader.dart';

///Starting page widget with upload button, text field, and logo
class StartPageWidget extends StatelessWidget {
  //Callback that called after user upload files
  final Function(List<Future<AnalyzedText>>) onFileUploaded;

  //Controller to get text from text field
  final TextEditingController textEditingController = TextEditingController();

  ///Constructs start page widget. Requires callback [onFileUploaded].
  StartPageWidget({Key? key, required this.onFileUploaded}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'iExtract',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                minLines: 15,
                maxLines: 15,
                keyboardType: TextInputType.multiline,
                controller: textEditingController,
                style: const TextStyle(
                  fontSize: 15,
                  fontFamily: 'Merriweather',
                ),
                decoration: InputDecoration(
                  labelStyle: const TextStyle(
                    fontSize: 20,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(2.0)),
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColorDark,
                        style: BorderStyle.solid),
                  ),
                  border: const OutlineInputBorder(),
                  label: const Center(child: Text('Enter text to analyze')),
                ),
                cursorColor: Theme.of(context).primaryColorDark,
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 50),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            //If user typed something into text field send it to IExtract API, then call callback
                            onFileUploaded(
                                [sendToIExtract(textEditingController.text)]);
                          },
                          label: const Text(
                            "Upload as text",
                            style: TextStyle(fontSize: 20),
                          ),
                          icon: const Icon(Icons.short_text, size: 60),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          //Pick pdf files from device
                          FilePickerResult? result = await FilePicker.platform
                              .pickFiles(
                                  allowMultiple: true,
                                  type: FileType.custom,
                                  allowedExtensions: ['pdf']);

                          if (result != null) {
                            //If user picked something, then extract text and send to IExtract API, then call callback
                            onFileUploaded([
                              sendToIExtract(
                                  PDFToRawTextConverter(result.files[0].bytes!)
                                      .result)
                            ]);
                          }
                        },
                        label: const Text(
                          'Upload Files',
                          style: TextStyle(fontSize: 20),
                        ),
                        icon: const Icon(Icons.upload_file, size: 60),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
  @override
  Widget build(BuildContext context) {
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
                    padding: const EdgeInsets.only(right: 10, left: 10, top: 25, bottom: 25),
                    //margin: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: MediaQuery.of(context).size.height * 0.9,
                    alignment: Alignment.centerLeft,
                    child: AnalyzedTextWidget(
                      analysis: widget.analysisRequests.first,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  SafeArea(
                    minimum:
                        const EdgeInsets.only(top: 25, left: 20),
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
                            return TextFormField(
                              initialValue: snapshot.data!.rawText,
                              minLines: 25,
                              maxLines: 25,
                              keyboardType: TextInputType.multiline,
                              //controller: textEditingController,
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
                        //TODO: Function for updating the text for analysis
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
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 8, left: 20, right: 20),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        //TODO: Extract function
                      },
                      label: const Text(
                        "Export the report",
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
