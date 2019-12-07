#import "MHSDKInstallEntry.h"
@interface MHSDKInstallableView : UIView
@property (nonatomic, strong) MHSDKInstallEntry *entry;
-(id)initWithEntry:(MHSDKInstallEntry *)entry;
@end