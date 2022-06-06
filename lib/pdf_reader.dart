import 'package:syncfusion_flutter_pdf/pdf.dart';

///Class to convert PDF (in bytes format) to solid text
///Usage: PDFToRawTextConverter(bytes).result -> returns String
class PDFToRawTextConverter {
  final List<int> bytes;
  late final String result;

  ///Constructs PDF to text converter. Requires pdf data in byte format [bytes].
  ///Text can be extracted by
  ///
  ///```dart
  ///String text = PDFToRawTextConverter(bytes).result;
  ///```
  PDFToRawTextConverter(this.bytes) {
    //Load the PDF document by bytes
    PdfDocument document = PdfDocument(inputBytes: bytes);

    //Create the new instance of the PdfTextExtractor.
    PdfTextExtractor extractor = PdfTextExtractor(document);

    //Extract all the text from the document.
    List<TextLine> textLines = extractor.extractTextLines();

    TextLine previousLine = textLines[0];
    String tempText = "";

    //Hard logic, will be changed and documented soon.
    //It is required because pdf is strange thing
    const int lineSpacingDeltaMax = 5;
    const int lineSpacingDeltaMin = 3;

    const int wordSpacingDeltaMax = 12;

    TextWord previousTextWord = previousLine.wordCollection[0];
    tempText += previousTextWord.text;
    for (int i = 1; i < previousLine.wordCollection.length; i++) {
      String spaceChar = "";
      if (previousLine.wordCollection[i].bounds.topLeft.dx -
              previousTextWord.bounds.topLeft.dx >
          wordSpacingDeltaMax) {
        spaceChar = " ";
      }
      tempText += spaceChar + previousLine.wordCollection[i].text;
      previousTextWord = previousLine.wordCollection[i];
    }

    for (int i = 1; i < textLines.length; i++) {
      String nextLine = "\n";
      if (textLines[i].bounds.topLeft.dy - previousLine.bounds.bottomRight.dy >
          lineSpacingDeltaMax) {
        nextLine = "\n\n";
      } else if (textLines[i].bounds.topLeft.dy -
              previousLine.bounds.bottomRight.dy <
          lineSpacingDeltaMin) {
        nextLine = "";
      }
      tempText += nextLine;
      previousTextWord = textLines[i].wordCollection[0];
      tempText += previousTextWord.text;
      for (int j = 1; j < textLines[i].wordCollection.length; j++) {
        String spaceChar = "";
        if (textLines[i].wordCollection[j].bounds.topLeft.dx -
                previousTextWord.bounds.topLeft.dx >
            wordSpacingDeltaMax) {
          spaceChar = " ";
        }
        tempText += spaceChar + textLines[i].wordCollection[j].text;
        previousTextWord = textLines[i].wordCollection[j];
      }
      previousLine = textLines[i];
    }

    result = tempText;
    //Dispose document
    document.dispose();
  }
}
