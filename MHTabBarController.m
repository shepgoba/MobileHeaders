#import "MHTabBarController.h"
#import "MHRootViewController.h"
#import "MHSettingsViewController.h"
@implementation MHTabBarController
-(id)init {
    if ((self = [super init])) {
        MHRootViewController *homeViewController = [[MHRootViewController alloc] initWithURL:nil];
        UINavigationController *homeViewControllerNav = [[UINavigationController alloc] initWithRootViewController:homeViewController];
        homeViewControllerNav.title = @"Home";

        MHSettingsViewController *settingsViewController = [[MHSettingsViewController alloc] init];
        UINavigationController *settingsViewControllerNav = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
        settingsViewControllerNav.title = @"Settings";
        NSArray* controllers = [NSArray arrayWithObjects:homeViewControllerNav, settingsViewControllerNav, nil];
        self.viewControllers = controllers;
    }
    return self;
}
@end