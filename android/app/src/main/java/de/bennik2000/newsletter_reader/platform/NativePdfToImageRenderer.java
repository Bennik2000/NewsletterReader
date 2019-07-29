package de.bennik2000.newsletter_reader.platform;

import android.content.Context;

import de.bennik2000.newsletter_reader.PdfiumPdfToImageRenderer;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class NativePdfToImageRenderer {
    private static final String NativePdfToImageRendererChannel = "native/NativePdfToImageRenderer";

    private Context context;

    public NativePdfToImageRenderer(Context context) {
        this.context = context;
    }


    public void setupMethodChannel(BinaryMessenger messenger) {
        new MethodChannel(messenger, NativePdfToImageRendererChannel)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("renderPdfToImage")) {
                                renderPdfToImage(call, result);
                            }
                        });
    }

    private void renderPdfToImage(
            MethodCall call,
            MethodChannel.Result result) {

        String file = call.argument("file");
        String outputFile = call.argument("outputFile");
        Integer pageIndexInteger = call.argument("pageIndex");

        if(pageIndexInteger == null) throw new IllegalArgumentException();
        int pageIndex = pageIndexInteger;

        new PdfiumPdfToImageRenderer(context).renderPdfToImage(file, outputFile,pageIndex);

        result.success(null);
    }
}