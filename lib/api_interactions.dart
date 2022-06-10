import 'dart:convert';
import 'analysis_data.dart';
import 'package:http/http.dart' as http;

//Api call function
Future<AnalyzedText> sendToIExtract(String text) async {
  final uri =
      Uri.parse('https://aqueous-anchorage-93443.herokuapp.com/FixMyEnglish');
  final headers = {
    "accept": "application/json",
    "Content-Type": "application/json"
  };
  final body = jsonEncode({"text": text});
  final response = await http.post(uri, headers: headers, body: body);
  if (response.statusCode != 200) {
    // do something
  }
  return AnalyzedText(
      rawText: text,
      analyzedSentences: analyzedSentenceFromJson(response.body));
}
