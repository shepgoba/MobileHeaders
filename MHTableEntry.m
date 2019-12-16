#import "MHTableEntry.h"
#define ALERT(str) [[[UIAlertView alloc] initWithTitle:str message:@"" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil] show]
NSString *iOSVersionFromString(NSString *str) {
   for (NSString *substr in [str componentsSeparatedByString:@"/"]) {
       if ([substr containsString:@"iOS"]) {
           return substr;
       }
   }
   return nil;
}
@implementation MHTableEntry
-(id)initWithURL:(NSURL *)directoryURL {
    if ((self = [super init])) {
        self.url = [NSURL URLWithString:[[directoryURL absoluteString] stringByReplacingOccurrencesOfString:@"file://" withString:@""]];
        self.extraInfo = [NSString stringWithFormat:@"%@ - %@", directoryURL.URLByDeletingLastPathComponent.absoluteString.lastPathComponent, iOSVersionFromString(directoryURL.URLByDeletingLastPathComponent.absoluteString)];
        self.name = [[directoryURL absoluteString] lastPathComponent];
        BOOL isDirectoryBool;
        [[NSFileManager defaultManager] fileExistsAtPath:[self.url absoluteString] isDirectory:&isDirectoryBool];
        self.isDirectory = isDirectoryBool;
    }
    return self;
}
@end