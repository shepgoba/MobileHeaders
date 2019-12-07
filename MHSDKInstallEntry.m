#import "MHSDKInstallEntry.h"
@implementation MHSDKInstallEntry
-(id)initWithDictionary:(NSDictionary *)dict {
    if ((self = [super init])) {
        self.name = dict[@"name"];
        self.iosVersion = dict[@"ios-version"];
        self.SDKURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"https://raw.githubusercontent.com/shepgoba/shepgoba.github.io/master/mobileheaders/", dict[@"url"]]];
    }

    return self;
}
@end