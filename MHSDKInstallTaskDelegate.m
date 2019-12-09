#import "MHSDKInstallTaskDelegate.h"

@implementation MHSDKInstallTaskDelegate
-(id)initWithEntry:(MHSDKInstallEntry *)entry {
    if ((self = [super init])) {
        self.entry = entry;
    }
    return self;
}
@end