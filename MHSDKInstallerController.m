#import "MHSDKInstallerController.h"

#define UICOLORMAKE(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
@implementation MHSDKInstallerController
-(id)init {
    if ((self = [super init])) {
       [self downloadSDKList];
    }
    return self;
}

-(void)downloadSDKList {
    if ([NSURL URLForResource:@"sdklist"]) {

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

    self.installSDKs = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.installSDKs.backgroundColor = UICOLORMAKE(235, 235, 235);
    self.installSDKs.layer.cornerRadius = 20;
    
    [self.view addSubview: self.headerLabel];
    [self.view addSubview: self.installSDKs];
    self.headerLabel.translatesAutoresizingMaskIntoConstraints = false;
    self.installSDKs.translatesAutoresizingMaskIntoConstraints = false;

    [self.headerLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [NSLayoutConstraint constraintWithItem:self.headerLabel
                                attribute:NSLayoutAttributeCenterY
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view  
                                attribute:NSLayoutAttributeCenterY
                                multiplier:0.5f
                                constant:0.f].active = YES;

    [self.installSDKs.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [NSLayoutConstraint constraintWithItem:self.installSDKs
                                attribute:NSLayoutAttributeCenterY
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view  
                                attribute:NSLayoutAttributeCenterY
                                multiplier:1.0f
                                constant:0.f].active = YES;

    [NSLayoutConstraint constraintWithItem:self.installSDKs
                                attribute:NSLayoutAttributeWidth
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view  
                                attribute:NSLayoutAttributeWidth
                                multiplier:0.66f
                                constant:0.f].active = YES;

    [NSLayoutConstraint constraintWithItem:self.installSDKs
                                attribute:NSLayoutAttributeHeight
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view  
                                attribute:NSLayoutAttributeHeight
                                multiplier:0.33f
                                constant:0.f].active = YES;
}
@end