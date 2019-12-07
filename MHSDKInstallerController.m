#import "MHSDKInstallerController.h"

#define UICOLORMAKE(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]

@implementation MHSDKInstallerController
-(void)updateSDKViews {
    self.installableSDKEntries = [[NSMutableArray alloc] init];
    NSArray *versions = self.SDKList[@"versions"];
    for (NSDictionary *dict in versions) {
        MHSDKInstallEntry *entry = [[MHSDKInstallEntry alloc] initWithDictionary:dict];

        [self.installableSDKEntries addObject: entry];
        MHSDKInstallableView *view = [[MHSDKInstallableView alloc] initWithEntry:entry];
        [self.installableSDKViews addObject: view];
    }
}

-(void)downloadSDKList {
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/SDKList.plist", documentsDirectory];

    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName isDirectory:0])
        return;

    NSString *stringURL = @"https://raw.githubusercontent.com/shepgoba/shepgoba.github.io/master/mobileheaders/sdks.plist";
    NSURL *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if (urlData) {
    
        if ([urlData writeToFile:fileName atomically:YES]) {
            self.SDKList = [NSDictionary dictionaryWithContentsOfFile:fileName];
            [self updateSDKViews];
        } else {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                               message:@"An error occured and the SDK list could not saved."
                               preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                               message:@"An error occured and the SDK list could not be downloaded"
                               preferredStyle:UIAlertControllerStyleAlert];
            
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
            
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self downloadSDKList];
    self.view.backgroundColor = [UIColor whiteColor];

    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.headerLabel.text = @"Install SDK Headers";
    self.headerLabel.textColor = [UIColor blackColor];
    self.headerLabel.font = [UIFont boldSystemFontOfSize:30];
    [self.headerLabel sizeToFit];

    self.installContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.installContainerView.backgroundColor = UICOLORMAKE(235, 235, 235);
    self.installContainerView.layer.cornerRadius = 20;
    
    [self.view addSubview: self.headerLabel];
    [self.view addSubview: self.installContainerView];
    self.headerLabel.translatesAutoresizingMaskIntoConstraints = false;
    self.installContainerView.translatesAutoresizingMaskIntoConstraints = false;

    [self.headerLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [NSLayoutConstraint constraintWithItem:self.headerLabel
                                attribute:NSLayoutAttributeCenterY
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view  
                                attribute:NSLayoutAttributeCenterY
                                multiplier:0.5f
                                constant:0.f].active = YES;

    [self.installContainerView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [NSLayoutConstraint constraintWithItem:self.installContainerView
                                attribute:NSLayoutAttributeCenterY
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view  
                                attribute:NSLayoutAttributeCenterY
                                multiplier:1.0f
                                constant:0.f].active = YES;

    [NSLayoutConstraint constraintWithItem:self.installContainerView
                                attribute:NSLayoutAttributeWidth
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view  
                                attribute:NSLayoutAttributeWidth
                                multiplier:0.66f
                                constant:0.f].active = YES;

    [NSLayoutConstraint constraintWithItem:self.installContainerView
                                attribute:NSLayoutAttributeHeight
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view  
                                attribute:NSLayoutAttributeHeight
                                multiplier:0.33f
                                constant:0.f].active = YES;
}
@end