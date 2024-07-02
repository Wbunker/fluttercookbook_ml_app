import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class MLHelper {
  Future<String> textFromImage(File image) async {
    final InputImage inputImage = InputImage.fromFile(image);
    final textDetector = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textDetector.processImage(inputImage);
    textDetector.close();
    return recognizedText.text;
  }
}
