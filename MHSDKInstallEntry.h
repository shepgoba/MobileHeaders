#import "MHUtils.h"

@class MHSDKInstallableView;

@interface MHSDKInstallEntry : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *iosVersion;
@property (nonatomic, strong) NSString *saveLocation;
@property (nonatomic, strong) NSURL *SDKURL;
@property (nonatomic, weak) MHSDKInstallableView *view;
@property (nonatomic, assign) BOOL shouldUninstall;
@property (nonatomic, assign) BOOL shouldInstall;
@property (nonatomic, assign, getter=isInstalled) BOOL installed;
@property (nonatomic, assign) int size;
@property (nonatomic, assign) int installedSize;
-(id)initWithDictionary:(NSDictionary *)dict;
@end