#import "MHSDKInstallEntry.h"
#import "MHSDKInstallableView.h"
#import "MHUtils.h"
#import <LzmaSDKObjC/LzmaSDKObjCReader.h>

@class MHSDKInstallerController;
/*
@protocol LzmaSDKObjCReaderDelegate
@required
-(void)onLzmaSDKObjCReader:(LzmaSDKObjCReader *)reader extractProgress:(CGFloat)progress;
@end*/

@interface MHSDKInstallTaskDelegate : NSObject <NSURLSessionDownloadDelegate, LzmaSDKObjCReaderDelegate>
@property (nonatomic, strong) MHSDKInstallEntry *entry;
@property (nonatomic, strong) NSString *fileToDecompress;
@property (nonatomic, weak) MHSDKInstallerController *controller;
@property (nonatomic, strong) LzmaSDKObjCReader *lzmaReader;
-(id)initWithEntry:(MHSDKInstallEntry *)entry controller:(MHSDKInstallerController *)controller;
-(void)decompressFile;
@end