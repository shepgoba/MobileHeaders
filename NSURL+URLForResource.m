@interface NSURL (NSURLResource)
+ (NSURL *)URLForResource:(NSString *)resource;
@end

@implementation NSURL (NSURLResource)

+ (NSURL *)URLForResource:(NSString *)resource
{
   NSString *name = [resource stringByDeletingPathExtension];
   NSString *extension = [resource pathExtension];

   return [[NSBundle mainBundle] URLForResource:name withExtension:extension];
}

@end