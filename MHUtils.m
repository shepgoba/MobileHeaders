#import "MHUtils.h"
@implementation MHUtils
+ (NSString *)URLForBundleResource:(NSString *)resource {
   NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
   NSString *bundleResource = [NSString stringWithFormat:@"%@/%@", bundlePath, resource];
   return bundleResource;
}
+ (NSString *)URLForDocumentsResource:(NSString *)file {
   NSURL *documentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
   NSString *URLString = [[NSString stringWithFormat:@"%@%@", documentsDirectory, file] stringByReplacingOccurrencesOfString:@"file://" withString:@""];
   return URLString;
}
@end