import 'dart:convert';

List<AnalysisData> analysisDataFromJson(String str) => List<AnalysisData>.from(json.decode(str).map((x) => AnalysisData.fromJson(x)));

String analysisDataToJson(List<AnalysisData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AnalysisData {
  AnalysisData({
    this.match,
    this.sentence,
    this.label,
    this.description,
  });

  String? match;
  String? sentence;
  String? label;
  String? description;

  factory AnalysisData.fromJson(Map<String, dynamic> json) => AnalysisData(
    match: json["match"],
    sentence: json["sentence"],
    label: json["label"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "match": match,
    "sentence": sentence,
    "label": label,
    "description": description,
  };
}
