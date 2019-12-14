#import "MHSDKInstallableView.h"

#define UICOLORMAKE(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]

@implementation MHSDKInstallableView
-(id)initWithEntry:(MHSDKInstallEntry *)entry controller:(MHSDKInstallerController *)controller {
    if ((self = [super init])) {
        self.entry = entry;
        self.controller = controller;
        self.entry.view = self;
        self.backgroundColor = [[NSUserDefaults standardUserDefaults] boolForKey:@"darkModeEnabled"] ? UICOLORMAKE(80, 80 ,80) : UICOLORMAKE(220, 220, 220);
        self.layer.cornerRadius = 20;
    }

    return self;
}

-(void)uninstallFinished {
    //NSDictionary *installedSDKs = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"installedSDKs"];
    self.entry.installed = NO;
    self.installedLabel.hidden = YES;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(UIViewNoIntrinsicMetric, 55);
}

-(void)setupInstalled {
    [self addSubview:self.statusLabel];
    if (self.entry.isInstalled) {
        self.installedLabel = [[UILabel alloc] init];
        self.installedLabel.textColor = [[NSUserDefaults standardUserDefaults] boolForKey:@"darkModeEnabled"] ? [UIColor whiteColor] : [UIColor blackColor];
        self.installedLabel.font = [UIFont boldSystemFontOfSize:12];
        self.installedLabel.text = self.entry.isInstalled ? @"Installed" : nil;
        [self.installedLabel sizeToFit];
        self.installedLabel.translatesAutoresizingMaskIntoConstraints = false;

        [self addSubview:self.installedLabel];

        [NSLayoutConstraint constraintWithItem:self.installedLabel
                                        attribute:NSLayoutAttributeCenterX
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:self  
                                        attribute:NSLayoutAttributeCenterX
                                        multiplier:1.f
                                        constant:0.f].active = YES;
        [NSLayoutConstraint constraintWithItem:self.installedLabel
                                        attribute:NSLayoutAttributeCenterY
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:self  
                                        attribute:NSLayoutAttributeCenterY
                                        multiplier:1.f
                                        constant:0.f].active = YES;
    }
}
-(void)setup {
    self.versionLabel = [[UILabel alloc] init];
    self.versionLabel.textColor = [[NSUserDefaults standardUserDefaults] boolForKey:@"darkModeEnabled"] ? [UIColor whiteColor] : [UIColor blackColor];
    self.versionLabel.font = [UIFont boldSystemFontOfSize:15];
    self.versionLabel.text = self.entry.name;
    [self.versionLabel sizeToFit];

    self.shouldInstallSwitch = [[UISwitch alloc] init];
    self.shouldInstallSwitch.on = self.entry.isInstalled;
    [self.shouldInstallSwitch addTarget:self action:@selector(switchValueChanged) forControlEvents:UIControlEventValueChanged];

    [self addSubview:self.shouldInstallSwitch];
    [self addSubview:self.versionLabel];

    [self setupInstalled];


    self.versionLabel.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint constraintWithItem:self.versionLabel
                                        attribute:NSLayoutAttributeCenterY
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:self  
                                        attribute:NSLayoutAttributeCenterY
                                        multiplier:1.f
                                        constant:0.f].active = YES;
    [NSLayoutConstraint constraintWithItem:self.versionLabel
                                        attribute:NSLayoutAttributeLeading
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:self  
                                        attribute:NSLayoutAttributeLeading
                                        multiplier:1.f
                                        constant:15.f].active = YES;
    
}
-(void)setupProgressBar {
    if (self.entry.isInstalled)
        return;
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.textColor = [[NSUserDefaults standardUserDefaults] boolForKey:@"darkModeEnabled"] ? [UIColor whiteColor] : [UIColor blackColor];
    self.statusLabel.font = [UIFont boldSystemFontOfSize:10];
    self.statusLabel.text = @"Downloading... (1/2)";

    self.progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressBar.progressTintColor = UICOLORMAKE(61, 255, 236);
    self.progressBar.trackTintColor = [[NSUserDefaults standardUserDefaults] boolForKey:@"darkModeEnabled"] ? UICOLORMAKE(150, 150, 150) : UICOLORMAKE(38, 38, 38); 
    self.progressBar.translatesAutoresizingMaskIntoConstraints = false;
    [self addSubview:self.progressBar];
    [self addSubview:self.statusLabel];
    [self.progressBar.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [NSLayoutConstraint constraintWithItem:self.progressBar
                                attribute:NSLayoutAttributeCenterY
                                relatedBy:NSLayoutRelationEqual
                                toItem:self
                                attribute:NSLayoutAttributeCenterY
                                multiplier:2.0f
                                constant:-2.f].active = YES;
    [NSLayoutConstraint constraintWithItem:self.progressBar
                                attribute:NSLayoutAttributeWidth
                                relatedBy:NSLayoutRelationEqual
                                toItem:self 
                                attribute:NSLayoutAttributeWidth
                                multiplier:1.f
                                constant:-25.f].active = YES;
    
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint constraintWithItem:self.statusLabel
                                        attribute:NSLayoutAttributeCenterY
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:self  
                                        attribute:NSLayoutAttributeCenterY
                                        multiplier:1.f
                                        constant:10.f].active = YES;
    [NSLayoutConstraint constraintWithItem:self.statusLabel
                                        attribute:NSLayoutAttributeCenterX
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:self  
                                        attribute:NSLayoutAttributeCenterX
                                        multiplier:1.f
                                        constant:0.f].active = YES;
}
-(void)switchValueChanged {
    if (self.shouldInstallSwitch.on)
        self.entry.shouldUninstall = NO;
    if (!self.shouldInstallSwitch.on) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirmation" message:@"Are you sure you want to delete this SDK? (This will take effect after you hit confirm)" preferredStyle:UIAlertControllerStyleAlert];
 
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
            self.entry.shouldUninstall = YES;
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            self.shouldInstallSwitch.on = YES;
            self.entry.shouldUninstall = NO;
        }];

        [alert addAction:defaultAction];
        [alert addAction:cancelAction];
        [(UIViewController *)self.controller presentViewController:alert animated:YES completion:nil];
    }
    self.entry.shouldInstall = self.shouldInstallSwitch.on;
}
-(void)updateForDecompression {
    [self.progressBar setProgress:0];
    self.statusLabel.text = @"Extracting... (2/2)";
    self.progressBar.progressTintColor = UICOLORMAKE(54, 232, 42);
}
-(void)installFinished {
    self.progressBar.hidden = YES;
    self.statusLabel.hidden = YES;
    NSDictionary *installedSDKs = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"installedSDKs"];
    if ([installedSDKs[self.entry.iosVersion] intValue]) {
        self.entry.installed = YES;
    } else {
        self.entry.installed = NO;
        self.installedLabel.hidden = YES;
    }
    [self setupInstalled];
}
@end