#import "MHSDKInstallEntry.h"

@interface MHDownloadTaskDelegate : NSObject //<NSURLSessionDelegate, NSURLSessionDownloadDelegate>
@property (nonatomic, strong) MHSDKInstallEntry *entry;
-(id)initWithEntry:(MHSDKInstallEntry *)entry;
@end