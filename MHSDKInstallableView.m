#import "MHSDKInstallableView.h"

#define UICOLORMAKE(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]

@implementation MHSDKInstallableView
-(id)initWithEntry:(MHSDKInstallEntry *)entry {
    if ((self = [super init])) {
        self.entry = entry;

        self.versionLabel = [[UILabel alloc] init];

        self.backgroundColor = UICOLORMAKE(220, 220, 220);
        self.layer.cornerRadius = 20;
        
    }

    return self;
}
@end