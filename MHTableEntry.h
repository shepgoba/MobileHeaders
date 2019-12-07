@interface MHTableEntry : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, assign) BOOL isDirectory;
-(id)initWithURL:(NSURL *)name;
@end