#import "MHAppDelegate.h"


@implementation MHAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	_window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	_tabBarController = [[MHTabBarController alloc] init];
	_window.rootViewController = _tabBarController;
	[_window makeKeyAndVisible];
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
	if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
		NSFileManager *defaultManager = [NSFileManager defaultManager];
		[defaultManager createFileAtPath:[MHUtils URLForDocumentsResource:@"installedSDKs.plist"] contents:nil attributes:nil];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MHThemeDidChange" object:nil];

}

@end
