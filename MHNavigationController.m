#import "MHNavigationController.h"
@implementation MHNavigationController
-(id)init {
    if ((self = [super init])) {
        self.navigationBar.barStyle = UIBarStyleBlack;
    }
    return self;
}
@end