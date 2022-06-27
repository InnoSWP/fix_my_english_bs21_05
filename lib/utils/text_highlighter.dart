import 'package:swp/utils/analysis_data.dart';

class HighlighCharacter {
  final bool isHighligh;
  final AnalyzedSentence? analysisSentence;

  HighlighCharacter(this.isHighligh, this.analysisSentence);
}

List<HighlighCharacter> getHighlightMap(AnalyzedText analysisData) {
  List<HighlighCharacter> highlighCharacters = [];
  String initialText = analysisData.rawText;
  for (int i = 0; i < initialText.length; i++) {
    highlighCharacters.add(HighlighCharacter(false, null));
  }

  for (var s in analysisData.analyzedSentences) {
    String realMatch = s.match.compareTo('') == 0 ? s.sentence : s.match;
    RegExp regExpSentence = RegExp(RegExp.escape(realMatch));
    Iterable<RegExpMatch> matchesSentence =
        regExpSentence.allMatches(initialText);
    for (RegExpMatch matchSentence in matchesSentence) {
      String issueSentence =
          initialText.substring(matchSentence.start, matchSentence.end);
      RegExp regExpIssue = RegExp(RegExp.escape(realMatch));
      Iterable<RegExpMatch> matchesIssue =
          regExpIssue.allMatches(issueSentence);
      for (RegExpMatch matchIssue in matchesIssue) {
        highlighCharacters.fillRange(matchSentence.start + matchIssue.start,
            matchSentence.start + matchIssue.end, HighlighCharacter(true, s));
      }
    }
  }
  return highlighCharacters;
}
