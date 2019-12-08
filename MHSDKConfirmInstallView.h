@interface MHSDKConfirmInstallView : UIView {
    BOOL _isActive;
}
@property (nonatomic, strong) CALayer *inactiveLayer;
-(BOOL)isActive;
-(BOOL)setActive:(BOOL)new;
@end