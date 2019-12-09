#import "MHSDKInstallEntry.h"
#import <LzmaSDKObjC/LzmaSDKObjCReader.h>

@protocol MHSDKInstallTaskDelegate
@required
-(void)onLzmaSDKObjCReader:(LzmaSDKObjCReader *)reader extractProgress:(CGFloat)progress;
@end

@interface MHSDKInstallTaskDelegate : NSObject <NSURLSessionDownloadDelegate>
@property (nonatomic, strong) MHSDKInstallEntry *entry;
-(id)initWithEntry:(MHSDKInstallEntry *)entry;
@end