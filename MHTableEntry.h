@interface MHTableEntry : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *extraInfo;
@property (nonatomic, assign) BOOL isDirectory;
-(id)initWithURL:(NSURL *)name;
@end