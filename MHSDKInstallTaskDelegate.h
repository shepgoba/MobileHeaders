#import "MHSDKInstallEntry.h"

@interface MHSDKInstallTaskDelegate : NSObject //<NSURLSessionDelegate, NSURLSessionDownloadDelegate>
@property (nonatomic, strong) MHSDKInstallEntry *entry;
-(id)initWithEntry:(MHSDKInstallEntry *)entry;
@end