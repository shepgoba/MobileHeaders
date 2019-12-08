#import "MHSDKInstallableView.h"

#define UICOLORMAKE(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]

@implementation MHSDKInstallableView
-(id)initWithEntry:(MHSDKInstallEntry *)entry {
    if ((self = [super init])) {
        self.entry = entry;
        self.entry.view = self;
        self.backgroundColor = [[NSUserDefaults standardUserDefaults] boolForKey:@"darkModeEnabled"] ? UICOLORMAKE(80, 80 ,80) : UICOLORMAKE(220, 220, 220);
        self.layer.cornerRadius = 20;
    }

    return self;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(UIViewNoIntrinsicMetric, 55);
}

-(void)setup {
    self.versionLabel = [[UILabel alloc] init];
    self.versionLabel.textColor = [[NSUserDefaults standardUserDefaults] boolForKey:@"darkModeEnabled"] ? [UIColor whiteColor] : [UIColor blackColor];
    self.versionLabel.font = [UIFont boldSystemFontOfSize:15];
    self.versionLabel.text = self.entry.name;
    [self.versionLabel sizeToFit];

    self.shouldInstallSwitch = [[UISwitch alloc] init];
    self.shouldInstallSwitch.on = NO;
    [self.shouldInstallSwitch addTarget:self action:@selector(switchValueChanged) forControlEvents:UIControlEventValueChanged];

    [self addSubview:self.shouldInstallSwitch];
    [self addSubview:self.versionLabel];
    
}
-(void)setupProgressBar {
    self.progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressBar.progressTintColor = UICOLORMAKE(61, 255, 236);
    self.progressBar.trackTintColor = [[NSUserDefaults standardUserDefaults] boolForKey:@"darkModeEnabled"] ? UICOLORMAKE(150, 150, 150) : UICOLORMAKE(38, 38, 38); 
    self.progressBar.translatesAutoresizingMaskIntoConstraints = false;
    [self addSubview:self.progressBar];
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
}
-(void)switchValueChanged {
    self.entry.shouldInstall = self.shouldInstallSwitch.on;
}
@end