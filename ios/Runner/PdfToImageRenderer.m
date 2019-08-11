#import "PdfToImageRenderer.h"

@implementation PdfToImageRenderer

+ (void) renderPdfToImage:(NSString *) file to:(NSString *) outputFile withPage:(NSInteger) pageIndex{
    
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:file];
    
    CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef) url);
    CGPDFPageRef pageRef = CGPDFDocumentGetPage(pdf, pageIndex + 1);
    
    CGRect pageRect = CGPDFPageGetBoxRect(pageRef, kCGPDFMediaBox);
    CGSize pageSize = pageRect.size;
    
    UIGraphicsBeginImageContextWithOptions(pageSize, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    CGContextTranslateCTM(context, 0.0, pageSize.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSaveGState(context);
    
    CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(pageRef, kCGPDFCropBox, CGRectMake(0, 0, pageSize.width, pageSize.height), 0, true);
    CGContextConcatCTM(context, pdfTransform);
    
    CGContextDrawPDFPage(context, pageRef);
    CGContextRestoreGState(context);
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [UIImagePNGRepresentation(resultingImage) writeToFile:outputFile atomically:YES];
}

@end
