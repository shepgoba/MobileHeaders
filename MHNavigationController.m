#import "MHNavigationController.h"
@implementation MHNavigationController
-(id)initWithRootViewController:(UIViewController *)rootViewController {
    if ((self = [super initWithRootViewController:rootViewController])) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange) name:@"MHThemeDidChange" object:nil];
    }
    return self;
}

-(void)themeDidChange {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkModeEnabled"]) {
        self.navigationBar.barStyle = UIBarStyleBlack;
    } else {
        self.navigationBar.barStyle = UIBarStyleDefault;
    }
}
@end