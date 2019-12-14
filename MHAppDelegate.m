#import "MHAppDelegate.h"


@implementation MHAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {

	_window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	_tabBarController = [[MHTabBarController alloc] init];
	_window.rootViewController = _tabBarController;
	[_window makeKeyAndVisible];
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"HasLaunchedOnce"];
    }
	if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
		
		//NSFileManager *defaultManager = [NSFileManager defaultManager];
		//[defaultManager createFileAtPath:[MHUtils URLForDocumentsResource:@"installedSDKs.plist"] contents:nil attributes:nil];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MHThemeDidChange" object:nil];
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkModeEnabled"])
        [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];
    else
        [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceLight];

}

@end
