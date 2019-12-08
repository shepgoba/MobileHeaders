#import "MHExplorerViewController.h"
#import "MHSDKInstallerController.h"
#import "MHNavigationController.h"
#import "MHTabBarController.h"
#import "MHUtils.h"
@interface MHAppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong, readonly) MHTabBarController *tabBarController;
@end
