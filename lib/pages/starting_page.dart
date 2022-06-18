import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swp/widgets/logo_widget.dart';
import '../utils/analysis_data.dart';
import '../utils/api_interactions.dart';
import '../utils/moofiy_color.dart';

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
        body: SafeArea(
      child: Stack(children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: SvgPicture.asset(
            fit: BoxFit.cover,
            "assets/clouds_2.svg",
            color: const Color.fromARGB(255, 222, 207, 180),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.2,
              right: MediaQuery.of(context).size.width * 0.2,
              bottom: MediaQuery.of(context).size.height * 0.025,
            ),
            child: Column(
              children: [
                const Expanded(
                    flex: 2,
                    child: Center(
                      child: IExtractLogo(),
                    )),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: TextFormField(
                    expands: true,
                    maxLines: null,
                    minLines: null,
                    controller: textEditingController,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    MoofiyColors.colorPrimaryRedCaramelDark)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    MoofiyColors.colorPrimaryRedCaramelDark)),
                        hintText: "Enter the text for analysis..."),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.24,
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: ElevatedButton.icon(
                        onPressed: () {
                          if (textEditingController.text != "") {
                            onFileUploaded(
                                [sendToIExtract(textEditingController.text)],
                                "text");
                          }
                        },
                        icon: const Icon(
                          Icons.send,
                          size: 40,
                        ),
                        label: const Text(
                          "Analyze",
                          style: TextStyle(fontSize: 20),
                        ))),
                const BeautifulDelimiter(),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.24,
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: ElevatedButton.icon(
                        onPressed: () async {
                          onFileUploaded(await sendFilesToIExtract(), "files");
                        },
                        icon: const Icon(
                          Icons.picture_as_pdf_sharp,
                          size: 40,
                        ),
                        label: const Text(
                          "Upload PDF",
                          style: TextStyle(fontSize: 20),
                        ))),
              ],
            )),
      ]),
    ));
  }
}

class BeautifulDelimiter extends StatelessWidget {
  const BeautifulDelimiter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
              margin: const EdgeInsets.only(left: 10.0, right: 20.0),
              child: Divider(
                color: Colors.black,
                height: MediaQuery.of(context).size.height * 0.05,
              )),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.06,
          child: const Center(
              child: Text(
            "OR",
            style: TextStyle(fontSize: 18),
          )),
        ),
        Expanded(
          child: Container(
              margin: const EdgeInsets.only(left: 20.0, right: 10.0),
              child: Divider(
                color: Colors.black,
                height: MediaQuery.of(context).size.height * 0.06,
              )),
        ),
      ],
    );
  }
}
