#import "MHAppDelegate.h"
#import "MHRootViewController.h"
#import "MHSDKInstallerController.h"
#import "MHTabBarController.h"

@implementation MHAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	_window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	_tabBarController = [[MHTabBarController alloc] init];
	_window.rootViewController = _tabBarController;
	[_window makeKeyAndVisible];
}

@end
