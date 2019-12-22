#import "MHAppDelegate.h"


@implementation MHAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {

	_window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	_tabBarController = [[MHTabBarController alloc] init];
	_window.rootViewController = _tabBarController;
	[_window makeKeyAndVisible];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MHThemeDidChange" object:nil];
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkModeEnabled"])
        [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];
    else
        [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceLight];

}

@end
