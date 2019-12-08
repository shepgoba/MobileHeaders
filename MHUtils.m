#import "MHUtils.h"
@implementation MHUtils
+ (NSString *)URLForDocumentsResource:(NSString *)file {
   NSURL *documentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
   NSString *URLString = [[NSString stringWithFormat:@"%@%@", documentsDirectory, file] stringByReplacingOccurrencesOfString:@"file://" withString:@""];
   return URLString;
}
@end