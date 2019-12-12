#import "MHSDKInstallTaskDelegate.h"
#define ALERT(str) [[[UIAlertView alloc] initWithTitle:@"Alert" message:str delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil] show]

@implementation MHSDKInstallTaskDelegate
-(id)initWithEntry:(MHSDKInstallEntry *)entry controller:(MHSDKInstallerController *)controller {
    if ((self = [super init])) {
        self.entry = entry;
        self.controller = controller;
    }
    return self;
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {

    float progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.entry.view.progressBar setProgress:progress];
    });
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSString *fileName = [downloadTask.originalRequest.URL.absoluteString lastPathComponent];
    NSData *data = [NSData dataWithContentsOfURL:location];
    dispatch_async(dispatch_get_main_queue(), ^{
        [data writeToFile:[MHUtils URLForDocumentsResource:fileName] atomically:NO];
        [self.entry.view updateForDecompression];
    });
    [self decompressFile];
}

-(void)onLzmaSDKObjCReader:(LzmaSDKObjCReader *)reader extractProgress:(float)progress {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.entry.view.progressBar setProgress:progress];
    });
}
-(void)decompressFile {
    NSString *fileName = [self.entry.SDKURL.absoluteString lastPathComponent];
    self.lzmaReader = [[LzmaSDKObjCReader alloc] initWithFileURL:[NSURL fileURLWithPath:[MHUtils URLForDocumentsResource:fileName]] andType:LzmaSDKObjCFileType7z];
    self.lzmaReader.delegate = self;
    NSError *error;
    if(![self.lzmaReader open:&error]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                message:[error description]
                                preferredStyle:UIAlertControllerStyleAlert];
                
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
                    
            [alert addAction:defaultAction];
            [(UIViewController *)(self.controller)presentViewController:alert animated:YES completion:nil];
        });
    }
    NSMutableArray *items = [[NSMutableArray alloc] init];

    [self.lzmaReader iterateWithHandler:^BOOL(LzmaSDKObjCItem * item, NSError * error){
        if (item) {
            [items addObject:item];
        }
        return YES;
    }];
    [self.lzmaReader extract:items toPath:[MHUtils URLForDocumentsResource:@"Data"] withFullPaths:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MHSDKWasInstalled" object:nil];

    [[NSFileManager defaultManager] removeItemAtPath:[MHUtils URLForDocumentsResource:fileName] error:nil];

    self.controller.installedSDKs[self.entry.iosVersion] = @YES;
}
@end