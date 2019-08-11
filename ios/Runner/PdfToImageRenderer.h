#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PdfToImageRenderer : NSObject

+ (void) renderPdfToImage:(NSString *) file to:(NSString *) outputFile withPage:(NSInteger) pageIndex;

@end

NS_ASSUME_NONNULL_END
