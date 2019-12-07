#import "MHRootViewController.h"
#import "MHSDKInstallerController.h"
#import "MHNavigationController.h"
#import "MHTabBarController.h"

@interface MHAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong, readonly) UIWindow *window;
@property (nonatomic, strong, readonly) MHRootViewController *rootViewController;
@property (nonatomic, strong, readonly) MHTabBarController *tabBarController;

@end
