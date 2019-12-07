#import "MHSDKInstallEntry.h"
@implementation MHSDKInstallEntry
-(id)initWithDictionary:(NSDictionary *)dict {
    if ((self = [super init])) {
        self.name = dict[@"name"];
        self.iosVersion = dict[@"ios-version"];
        self.SDKURL = dict[@"url"];
    }

    return self;
}
@end