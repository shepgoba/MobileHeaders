#import "MHSDKInstallTaskDelegate.h"

@implementation MHSDKInstallTaskDelegate
-(id)initWithEntry:(MHSDKInstallEntry *)entry {
    if ((self = [super init])) {
        self.entry = entry;
    }
    return self;
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {

    /*float progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
        for (MHSDKInstallEntry *entry in self.allEntriesToDownload) {
            if ([entry.SDKURL.absoluteString isEqualToString: downloadTask.originalRequest.URL.absoluteString])
                [self.entry.view.progressBar setProgress:progress];
        }

    });*/
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {

}
@end