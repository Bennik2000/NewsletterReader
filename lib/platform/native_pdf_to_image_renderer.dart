import 'package:flutter/services.dart';
import 'package:newsletter_reader/business/pdf/pdf_to_image_renderer.dart';

class NativePdfToImageRenderer extends PdfToImageRenderer {
  final MethodChannel _platform;

  NativePdfToImageRenderer() : _platform = new MethodChannel("native/NativePdfToImageRenderer");

  @override
  Future renderPdfToImage(String file, String outputFile, int pageIndex) async {
    try {
      await _platform.invokeMethod('renderPdfToImage', {"file": file, "outputFile": outputFile, "pageIndex": pageIndex});
    } catch (e) {
      print(e);
    }
  }
}
