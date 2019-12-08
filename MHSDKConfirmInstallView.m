#import "MHSDKConfirmInstallView.h"

@implementation MHSDKConfirmInstallView
-(BOOL)isActive {
    return _isActive;
}
-(void)setActive:(BOOL)new {
    _isActive = new;
    self.userInteractionEnabled = new;
}
@end