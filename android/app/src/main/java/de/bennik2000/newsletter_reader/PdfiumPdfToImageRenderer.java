package de.bennik2000.newsletter_reader;

import android.content.Context;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.ParcelFileDescriptor;

import com.shockwave.pdfium.PdfDocument;
import com.shockwave.pdfium.PdfiumCore;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

public class PdfiumPdfToImageRenderer {
    private static PdfiumCore pdfiumCore;
    private Context context;

    public PdfiumPdfToImageRenderer(Context context) {
        this.context = context;

        if(pdfiumCore == null){
            pdfiumCore = new PdfiumCore(context);
        }
    }

    public void renderPdfToImage(String file, String outputPath, int pageIndex) {
        File outputFile = new File(outputPath);

        Bitmap bitmap = null;

        try {
            outputFile.getParentFile().mkdirs();
            outputFile.createNewFile();

            bitmap = renderPdfToBitmap(file, pageIndex);
            saveBitmapToFile(outputFile, bitmap);
        } catch (IOException e) {
            outputFile.delete();
        } finally {
            if(bitmap != null && !bitmap.isRecycled()){
                bitmap.recycle();
            }
        }
    }

    private Bitmap renderPdfToBitmap(String path, int pageIndex) throws IOException {
        ParcelFileDescriptor fd =  context.getContentResolver().openFileDescriptor(Uri.fromFile(new File(path)), "r");
        PdfDocument pdfDocument = pdfiumCore.newDocument(fd);

        pdfiumCore.openPage(pdfDocument, pageIndex);

        int width = pdfiumCore.getPageWidthPoint(pdfDocument, pageIndex);
        int height = pdfiumCore.getPageHeightPoint(pdfDocument, pageIndex);

        Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
        pdfiumCore.renderPageBitmap(pdfDocument, bitmap, pageIndex, 0, 0, width, height);

        pdfiumCore.closeDocument(pdfDocument);

        return bitmap;
    }

    private void saveBitmapToFile(File fileOfPreviewImage, Bitmap pageBitmap) throws IOException {
        fileOfPreviewImage.getParentFile().mkdirs();

        FileOutputStream fileOutputStream = new FileOutputStream(fileOfPreviewImage);
        pageBitmap.compress(Bitmap.CompressFormat.PNG, 50, fileOutputStream);
        fileOutputStream.close();
    }
}
