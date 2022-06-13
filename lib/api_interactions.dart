import 'dart:convert';
import 'analysis_data.dart';
import 'package:http/http.dart' as http;

String _mockAPI = "https://mock-api-for-fix-my-english.herokuapp.com";
String _moofiyAPI = "https://aqueous-anchorage-93443.herokuapp.com";

///API call function
Future<AnalyzedText> sendToIExtract(String text) async {
  final uri = Uri.parse("$_mockAPI/FixMyEnglish");
  final headers = {
    "accept": "application/json",
    "Content-Type": "application/json"
  };
  final body = jsonEncode({"text": text});
  final response = await http.post(uri, headers: headers, body: body);
  if (response.statusCode != 200) {
    //Sending request to mock API
    final uri_mock = Uri.parse("$_moofiyAPI/FixMyEnglish");
    final repsonse_mock =
        await http.post(uri_mock, headers: headers, body: body);
    if (response.statusCode != 200) {
      return Future.error("Everything is ruined. No one respond.");
    }
    return AnalyzedText(
        rawText: text,
        analyzedSentences: analyzedSentenceFromJson(response.body));
  }
  return AnalyzedText(
      rawText: text,
      analyzedSentences: analyzedSentenceFromJson(response.body));
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
