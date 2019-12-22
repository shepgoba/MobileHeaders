#import "MHTabBarController.h"
#import "MHExplorerViewController.h"
#import "MHSettingsViewController.h"
#import "MHSearchViewController.h"
#import "MHNavigationController.h"
@implementation MHTabBarController
-(id)init {
    if ((self = [super init])) {

        MHExplorerViewController *homeViewController = [[MHExplorerViewController alloc] initWithURL:nil];
        MHNavigationController *homeViewControllerNav = [[MHNavigationController alloc] initWithRootViewController:homeViewController];
        homeViewControllerNav.title = @"Home";

        MHSearchViewController *searchViewController = [[MHSearchViewController alloc] init];
        MHNavigationController *searchViewControllerNav = [[MHNavigationController alloc] initWithRootViewController:searchViewController];

        MHSettingsViewController *settingsViewController = [[MHSettingsViewController alloc] init];
        MHNavigationController *settingsViewControllerNav = [[MHNavigationController alloc] initWithRootViewController:settingsViewController];
        settingsViewControllerNav.title = @"Settings";

        homeViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Explore" image:[UIImage imageNamed:@"ExploreIcon.png"] tag:0];
        searchViewControllerNav.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:0];
        settingsViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:[UIImage imageNamed:@"SettingsIcon.png"] tag:0];

        NSArray *controllers = [NSArray arrayWithObjects:homeViewControllerNav, searchViewControllerNav, settingsViewControllerNav, nil];
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
    [self.view layoutIfNeeded];
}
@end