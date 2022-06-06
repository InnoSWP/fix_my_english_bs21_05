import 'analysis_data.dart';

//Will be API call function. Now it is just fake :)
Future<AnalysisData> sendToIExtract(String text) async {
  await Future.delayed(const Duration(seconds: 3));
  return AnalysisData(rawText: text);
}