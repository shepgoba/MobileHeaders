#import "MHSettingsViewController.h"
@implementation MHSettingsViewController
-(id)init {
    if ((self = [super init])) {
        self.title = @"Settings";
    }
    return self;
}
-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}
@end