#import "MHDownloadTaskDelegate.h"

@implementation MHDownloadTaskDelegate
-(id)initWithEntry:(MHSDKInstallEntry *)entry {
    if ((self = [super init])) {
        self.entry = entry;
    }
    return self;
}
@end