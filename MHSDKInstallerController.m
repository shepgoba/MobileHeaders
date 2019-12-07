#import "MHSDKInstallerController.h"

#define UICOLORMAKE(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]

@implementation MHSDKInstallerController
-(void)updateSDKViews {
    self.installableSDKEntries = [[NSMutableArray alloc] init];
    NSArray *versions = self.SDKList[@"versions"];
    int i = 0;
    for (NSDictionary *dict in versions) {
        MHSDKInstallEntry *entry = [[MHSDKInstallEntry alloc] initWithDictionary:dict];
        [self.installableSDKEntries addObject: entry];

        MHSDKInstallableView *installableSDKView = [[MHSDKInstallableView alloc] initWithEntry:entry];
        [self.installContainerView addSubview: installableSDKView];
        [installableSDKView.centerXAnchor constraintEqualToAnchor:self.installContainerView.centerXAnchor].active = YES;
        [NSLayoutConstraint constraintWithItem:installableSDKView
                                    attribute:NSLayoutAttributeWidth
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.view  
                                    attribute:NSLayoutAttributeWidth
                                    multiplier:0.9f
                                    constant:0.f].active = YES;
        [NSLayoutConstraint constraintWithItem:installableSDKView
                                    attribute:NSLayoutAttributeHeight
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.view  
                                    attribute:NSLayoutAttributeHeight
                                    multiplier:0.33f
                                    constant:0.f].active = YES;
        [NSLayoutConstraint constraintWithItem:installableSDKView
                                    attribute:NSLayoutAttributeCenterY
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.view  
                                    attribute:NSLayoutAttributeCenterY
                                    multiplier:0.f
                                    constant:(20.f+i*20.0f)].active = YES;

        [self.installableSDKViews addObject: installableSDKView];
        i++;
    }
}

-(void)downloadSDKListIfNecessary {
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
    self.view.backgroundColor = [UIColor whiteColor];

    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.headerLabel.text = @"Install SDK Headers";
    self.headerLabel.textColor = [UIColor blackColor];
    self.headerLabel.font = [UIFont boldSystemFontOfSize:30];
    [self.headerLabel sizeToFit];

    self.installContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.installContainerView.backgroundColor = UICOLORMAKE(235, 235, 235);
    self.installContainerView.layer.cornerRadius = 20;

    self.installScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.installContainerView.layer.cornerRadius = 20;
    self.installScrollView.minimumZoomScale = 1;
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
                                multiplier:0.5f
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
                                multiplier:0.66f
                                constant:0.f].active = YES;
    [NSLayoutConstraint constraintWithItem:self.installScrollView
                                attribute:NSLayoutAttributeHeight
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view  
                                attribute:NSLayoutAttributeHeight
                                multiplier:0.33f
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