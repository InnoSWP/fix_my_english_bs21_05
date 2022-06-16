import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'analysis_data.dart';
import 'api_interactions.dart';

///Starting page widget with upload button, text field, and logo
class StartPageWidget extends StatelessWidget {
  //Callback that called after user upload files
  final Function(List<Future<AnalyzedText>>, String) onFileUploaded;

  //Controller to get text from text field
  final TextEditingController textEditingController = TextEditingController();

  //Text field font size
  final double textFieldFontSize = 15;

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
              Expanded(
                flex: 8,
                child: TextField(
                  expands: true,
                  maxLines: null,
                  minLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: textEditingController,
                  style: TextStyle(
                    fontSize: textFieldFontSize,
                    fontFamily: 'Merriweather',
                  ),
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(
                      fontSize: 20,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(2.0)),
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColorDark,
                          style: BorderStyle.solid),
                    ),
                    border: const OutlineInputBorder(),
                    label: const Center(child: Text('Enter text to analyze')),
                  ),
                  cursorColor: Theme.of(context).primaryColorDark,
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 3,
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ))),
                          onPressed: () {
                            //If user typed something into text field send it to IExtract API, then call callback
                            onFileUploaded(
                                [sendToIExtract(textEditingController.text)],
                                "text");
                          },
                          label: const Text(
                            "Upload text",
                            style: TextStyle(fontSize: 20),
                          ),
                          icon: const Icon(Icons.short_text, size: 60),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(),
                      ),
                      Expanded(
                        flex: 3,
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ))),
                          onPressed: () async {
                            //Pick pdf files from device
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(
                                    allowMultiple: true,
                                    type: FileType.custom,
                                    allowedExtensions: ['pdf']);

                            if (result != null) {
                              //If user picked something, then extract text and send to IExtract API, then call callback
                              List<Future<AnalyzedText>> requests = [];
                              for (PlatformFile platfromFile in result.files) {
                                String textData = await sendForPDFExtract(
                                    platfromFile.bytes!, platfromFile.name);
                                requests.add(sendToIExtract(textData));
                              }

                              onFileUploaded(requests, "files");
                            }
                          },
                          label: const Text(
                            'Upload PDF',
                            style: TextStyle(fontSize: 20),
                          ),
                          icon: const Icon(Icons.upload_file, size: 60),
                        ),
                      )
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
