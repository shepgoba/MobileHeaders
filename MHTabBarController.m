#import "MHTabBarController.h"
#import "MHExplorerViewController.h"
#import "MHSettingsViewController.h"
#import "MHNavigationController.h"
@implementation MHTabBarController
-(id)init {
    if ((self = [super init])) {

        MHExplorerViewController *homeViewController = [[MHExplorerViewController alloc] initWithURL:nil];
        MHNavigationController *homeViewControllerNav = [[MHNavigationController alloc] initWithRootViewController:homeViewController];
        homeViewControllerNav.title = @"Home";

        MHSettingsViewController *settingsViewController = [[MHSettingsViewController alloc] init];
        MHNavigationController *settingsViewControllerNav = [[MHNavigationController alloc] initWithRootViewController:settingsViewController];
        settingsViewControllerNav.title = @"Settings";

        homeViewController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:0];
        settingsViewController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemDownloads tag:0];
        /*if (@available(iOS 13, *)) {
            UINavigationBarAppearance *barAppearance = [UINavigationBarAppearance new];
            [barAppearance configureWithDefaultBackground];
            settingsViewControllerNav.navigationBar.scrollEdgeAppearance = barAppearance;
            homeViewControllerNav.navigationBar.scrollEdgeAppearance = barAppearance;
        }*/
        NSArray* controllers = [NSArray arrayWithObjects:homeViewControllerNav, settingsViewControllerNav, nil];
        self.viewControllers = controllers;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange) name:@"MHThemeDidChange" object:nil];
    }
    return self;
}

-(void)themeDidChange {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkModeEnabled"]) {
        self.tabBar.barStyle = UIBarStyleBlack;
    } else {
        self.tabBar.barStyle = UIBarStyleDefault;
    }
    [self.tabBar layoutIfNeeded];
    //[self.view layoutIfNeeded];
}
@end