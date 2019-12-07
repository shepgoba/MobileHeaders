#import "MHAppDelegate.h"
#import "MHRootViewController.h"
#import "MHSDKInstallerController.h"
#import "MHNavigationController.h"

@implementation MHAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	_window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

	_rootViewController = [[MHRootViewController alloc] initWithURL:nil];
	_navigationController = [[MHNavigationController alloc] initWithRootViewController:_rootViewController];
	_window.rootViewController = _navigationController;
	[_window makeKeyAndVisible];
	//if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    //{
       // [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        //[[NSUserDefaults standardUserDefaults] synchronize];
    //}
}

@end
