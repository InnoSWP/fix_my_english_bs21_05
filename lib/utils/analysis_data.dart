import 'dart:convert';

///Parse JSON to list of analyzed texts
List<AnalyzedSentence> analyzedSentenceFromJson(String str) =>
    List<AnalyzedSentence>.from(
        json.decode(str).map((x) => AnalyzedSentence.fromJson(x)));

String analyzedSentenceToJson(List<AnalyzedSentence> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AnalyzedSentence {
  AnalyzedSentence({
    required this.match,
    required this.sentence,
    required this.label,
    required this.description,
  });

  String match;
  String sentence;
  String label;
  String description;

  factory AnalyzedSentence.fromJson(Map<String, dynamic> json) =>
      AnalyzedSentence(
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

  List<String> splitOnThree() {
    String part1 = "";
    String part2 = "";
    String part3 = "";

    int beginPos = sentence.indexOf(match);
    int endPos = beginPos + match.length;
    for (int i = 0; i < sentence.length; i++) {
      if (i < beginPos) {
        part1 += sentence[i];
      } else if (i >= beginPos && i < endPos) {
        part2 += sentence[i];
      } else {
        part3 += sentence[i];
      }
    }

    return [part1, part2, part3];
  }
}

class AnalyzedText {
  final String rawText;
  final List<AnalyzedSentence> analyzedSentences;

  AnalyzedText({required this.rawText, required this.analyzedSentences});
}
