#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
    
    FlutterMethodChannel* pdfToImageChannel = [FlutterMethodChannel methodChannelWithName:@"native/NativePdfToImageRenderer"
        binaryMessenger:controller];
    
    [pdfToImageChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        if ([@"renderPdfToImage" isEqualToString:call.method]) {
            
            NSString* file = call.arguments [@"file"];
            NSString* outputFile = call.arguments [@"outputFile"];
            NSInteger pageIndex = [call.arguments [@"pageIndex"] integerValue];
            
            [PdfToImageRenderer renderPdfToImage:file to:outputFile withPage:pageIndex];
            
            result(nil);
        } else {
            result(FlutterMethodNotImplemented);
        }
    }];
    
    [GeneratedPluginRegistrant registerWithRegistry:self];
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}


@end
