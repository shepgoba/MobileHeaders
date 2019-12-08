@interface MHSDKConfirmInstallView : UIView {
    BOOL _isActive;
}
@property (nonatomic, strong) CALayer *inactiveLayer;
-(BOOL)isActive;
-(void)setActive:(BOOL)new;
@end