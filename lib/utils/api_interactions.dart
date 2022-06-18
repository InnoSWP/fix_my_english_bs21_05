import 'dart:convert';
import 'analysis_data.dart';
import 'package:http/http.dart' as http;
import '../utils/pdf_reader.dart';
import 'package:file_picker/file_picker.dart';

String _mockAPI = "https://mock-api-for-fix-my-english.herokuapp.com";
String _moofiyAPI = "https://aqueous-anchorage-93443.herokuapp.com";

///API call function
Future<AnalyzedText> sendToIExtract(String text, [String? filename]) async {
  final uri = Uri.parse("$_mockAPI/FixMyEnglish");
  final headers = {
    "accept": "application/json",
    "Content-Type": "application/json"
  };
  final body = jsonEncode({"text": text});
  final response = await http.post(uri, headers: headers, body: body);
  if (response.statusCode != 200) {
    //Sending request to mock API
    final uriMock = Uri.parse("$_moofiyAPI/FixMyEnglish");
    final responseMock = await http.post(uriMock, headers: headers, body: body);
    if (responseMock.statusCode != 200) {
      return Future.error("Everything is ruined. No one respond.");
    }
    return AnalyzedText(
        filename: filename,
        rawText: text,
        analyzedSentences: analyzedSentenceFromJson(response.body));
  }
  return AnalyzedText(
      filename: filename,
      rawText: text,
      analyzedSentences: analyzedSentenceFromJson(response.body));
}

Future<List<Future<AnalyzedText>>> sendFilesToIExtract() async {
  List<Future<AnalyzedText>> sequentialFutures = [];
  //Pick pdf files from device
  FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true, type: FileType.custom, allowedExtensions: ['pdf']);

  if (result != null) {
    //If user picked something, then extract text and send to IExtract API, then call callback
    Future<AnalyzedText> prevText = sendToIExtract(
        PDFToRawTextConverter(result.files[0].bytes!).result,
        result.files[0].name);
    sequentialFutures.add(prevText);
    for (int i = 1; i < result.files.length; i++) {
      sequentialFutures.add(connectFuture(
          prevText,
          PDFToRawTextConverter(result.files[i].bytes!).result,
          result.files[i].name));
    }
    return sequentialFutures;
  }
  return [];
}

Future<AnalyzedText> connectFuture(
    Future<AnalyzedText> future, String text, String filename) async {
  await future;
  return await sendToIExtract(text, filename);
}

///Get readed pdf from web
Future<String> sendForPDFExtract(List<int> bytes, String filename) async {
  final uri = Uri.parse("$_mockAPI/PDFReader");
  var request = http.MultipartRequest("POST", uri);

  request.files
      .add(http.MultipartFile.fromBytes("file1", bytes, filename: filename));

  final response = await request.send();
  if (response.statusCode == 200) {
    return await response.stream.bytesToString();
  }
  return Future.error("Failed to parse");
}
