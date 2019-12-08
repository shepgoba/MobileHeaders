@class MHSDKInstallableView;
@interface MHSDKInstallEntry : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *iosVersion;
@property (nonatomic, strong) NSURL *SDKURL;
@property (nonatomic, weak) MHSDKInstallableView *view;
@property (nonatomic, assign) BOOL shouldInstall;
-(id)initWithDictionary:(NSDictionary *)dict;
@end