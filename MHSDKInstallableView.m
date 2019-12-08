#import "MHSDKInstallableView.h"

#define UICOLORMAKE(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]

@implementation MHSDKInstallableView
-(id)initWithEntry:(MHSDKInstallEntry *)entry {
    if ((self = [super init])) {
        self.entry = entry;
        self.backgroundColor = UICOLORMAKE(220, 220, 220);
        self.layer.cornerRadius = 20;
    }

    return self;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(UIViewNoIntrinsicMetric, 55);
}

-(void)setup {
    self.versionLabel = [[UILabel alloc] init];
    self.versionLabel.textColor = [UIColor blackColor];
    self.versionLabel.font = [UIFont boldSystemFontOfSize:15];
    self.versionLabel.text = self.entry.name;
    [self.versionLabel sizeToFit];

    self.shouldInstallSwitch = [[UISwitch alloc] init];
    self.shouldInstallSwitch.on = NO;

    [self addSubview:self.shouldInstallSwitch];
    [self addSubview:self.versionLabel];
    
}
@end