#import "MHSDKInstallableView.h"
@implementation MHSDKInstallableView
-(id)initWithEntry:(MHSDKInstallEntry *)entry {
    if ((self = [super init])) {
        self.entry = entry;
    }

    return self;
}
@end