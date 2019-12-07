#import "MHSDKInstallEntry.h"
@interface MHSDKInstallableView : UIView
@property (nonatomic, strong) MHSDKInstallEntry *entry;
@property (nonatomic, strong) UILabel *versionLabel;

-(id)initWithEntry:(MHSDKInstallEntry *)entry;
-(void)setup;
@end