#import "MHSDKInstallerController.h"

#define UICOLORMAKE(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
#define ALERT(str) [[[UIAlertView alloc] initWithTitle:str message:@"" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil] show]

@implementation MHSDKInstallerController
-(void)updateSDKViews {
    self.installableSDKViews = [[NSMutableArray alloc] init];
    self.installableSDKEntries = [[NSMutableArray alloc] init];
    NSArray *versions = self.SDKList[@"versions"];
    CGFloat offset = 1;
    for (NSDictionary *dict in versions) {
        CGFloat finalOffset = offset*20.f;
        MHSDKInstallEntry *entry = [[MHSDKInstallEntry alloc] initWithDictionary:dict];
        [self.installableSDKEntries addObject: entry];
        
        MHSDKInstallableView *installableSDKView = [[MHSDKInstallableView alloc] initWithEntry:entry];
        [self.installableSDKViews addObject: installableSDKView];
        [self.installContainerView addSubview: installableSDKView];
        
        installableSDKView.translatesAutoresizingMaskIntoConstraints = false;
        [installableSDKView.centerXAnchor constraintEqualToAnchor:self.installContainerView.centerXAnchor].active = YES;
        [installableSDKView.centerYAnchor constraintEqualToAnchor:self.installContainerView.centerYAnchor].active = YES;

        [NSLayoutConstraint constraintWithItem:installableSDKView
                                    attribute:NSLayoutAttributeWidth
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.installContainerView  
                                    attribute:NSLayoutAttributeWidth
                                    multiplier:0.9f
                                    constant:0.f].active = YES;
        [NSLayoutConstraint constraintWithItem:installableSDKView
                                    attribute:NSLayoutAttributeHeight
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.installContainerView  
                                    attribute:NSLayoutAttributeHeight
                                    multiplier:0.2f
                                    constant:0.f].active = YES;

        [NSLayoutConstraint constraintWithItem:installableSDKView
                                    attribute:NSLayoutAttributeTop
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.installContainerView  
                                    attribute:NSLayoutAttributeTop
                                    multiplier:1.f
                                    constant:(offset*installableSDKView.frame.size.height)].active = YES;
        [installableSDKView setup];
        installableSDKView.versionLabel.translatesAutoresizingMaskIntoConstraints = false;
        [NSLayoutConstraint constraintWithItem:installableSDKView.versionLabel
                                        attribute:NSLayoutAttributeCenterY
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:installableSDKView  
                                        attribute:NSLayoutAttributeCenterY
                                        multiplier:1.f
                                        constant:0.f].active = YES;
        [NSLayoutConstraint constraintWithItem:installableSDKView.versionLabel
                                        attribute:NSLayoutAttributeLeading
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:installableSDKView  
                                        attribute:NSLayoutAttributeLeading
                                        multiplier:1.f
                                        constant:15.f].active = YES;
    }
}

-(void)downloadSDKListIfNecessary {
    NSString *fileName = [MHUtils URLForDocumentsResource:@"SDKList.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName isDirectory:0]) {
        self.SDKList = [NSDictionary dictionaryWithContentsOfFile:fileName];
        [self updateSDKViews];
        return;
    }
    [self downloadSDKList];
}
-(void)downloadSDKList {
    NSString *fileName = [MHUtils URLForDocumentsResource:@"SDKList.plist"];
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
    self.view.backgroundColor = [UIColor whiteColor];

    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.headerLabel.text = @"Download SDK Headers";
    self.headerLabel.textColor = [UIColor blackColor];
    self.headerLabel.font = [UIFont boldSystemFontOfSize:30];
    [self.headerLabel sizeToFit];

    self.installContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.installContainerView.layer.cornerRadius = 20;

    self.installScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.installScrollView.backgroundColor = UICOLORMAKE(235, 235, 235);
    self.installScrollView.layer.cornerRadius = 20;
    self.installScrollView.minimumZoomScale = 1;
    self.installScrollView.scrollEnabled = YES;

    [self.view addSubview: self.headerLabel];
    [self.view addSubview: self.installScrollView];
    [self.installScrollView addSubview: self.installContainerView];

    self.headerLabel.translatesAutoresizingMaskIntoConstraints = false;
    self.installContainerView.translatesAutoresizingMaskIntoConstraints = false;
    self.installScrollView.translatesAutoresizingMaskIntoConstraints = false;

    [self.headerLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [NSLayoutConstraint constraintWithItem:self.headerLabel
                                attribute:NSLayoutAttributeCenterY
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view  
                                attribute:NSLayoutAttributeCenterY
                                multiplier:0.4f
                                constant:0.f].active = YES;


    [self.installScrollView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [NSLayoutConstraint constraintWithItem:self.installScrollView
                                attribute:NSLayoutAttributeCenterY
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view  
                                attribute:NSLayoutAttributeCenterY
                                multiplier:1.0f
                                constant:0.f].active = YES;

    [NSLayoutConstraint constraintWithItem:self.installScrollView
                                attribute:NSLayoutAttributeWidth
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view  
                                attribute:NSLayoutAttributeWidth
                                multiplier:0.75f
                                constant:0.f].active = YES;      
    [NSLayoutConstraint constraintWithItem:self.installScrollView
                                attribute:NSLayoutAttributeHeight
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view  
                                attribute:NSLayoutAttributeHeight
                                multiplier:0.4f
                                constant:0.f].active = YES;                      

    [self.installContainerView.centerXAnchor constraintEqualToAnchor:self.installScrollView.centerXAnchor].active = YES;
    [NSLayoutConstraint constraintWithItem:self.installContainerView
                                attribute:NSLayoutAttributeCenterY
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.installScrollView  
                                attribute:NSLayoutAttributeCenterY
                                multiplier:1.0f
                                constant:0.f].active = YES;

    [NSLayoutConstraint constraintWithItem:self.installContainerView
                                attribute:NSLayoutAttributeWidth
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.installScrollView 
                                attribute:NSLayoutAttributeWidth
                                multiplier:1.0f
                                constant:0.f].active = YES;

    [NSLayoutConstraint constraintWithItem:self.installContainerView
                                attribute:NSLayoutAttributeHeight
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.installScrollView  
                                attribute:NSLayoutAttributeHeight
                                multiplier:1.0f
                                constant:0.f].active = YES;


    

    [self downloadSDKListIfNecessary];
}
@end