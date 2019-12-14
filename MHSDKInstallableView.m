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
    self.entry.shouldInstall = self.shouldInstallSwitch.on;
}
-(void)updateForDecompression {
    [self.progressBar setProgress:0];
    self.statusLabel.text = @"Extracting... (2/2)";
    self.progressBar.progressTintColor = UICOLORMAKE(54, 232, 42);
}
@end