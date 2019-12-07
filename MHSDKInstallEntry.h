@interface MHSDKInstallEntry : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *iosVersion;
@property (nonatomic, strong) NSURL *SDKURL;
@property (nonatomic, assign) BOOL shouldInstall;
-(id)initWithDictionary:(NSDictionary *)dict;
@end