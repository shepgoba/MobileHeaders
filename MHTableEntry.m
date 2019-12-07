#import "MHTableEntry.h"
#define ALERT(str) [[[UIAlertView alloc] initWithTitle:str message:@"" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil] show]

@implementation MHTableEntry
-(id)initWithURL:(NSURL *)directoryURL {
    if ((self = [super init])) {
        self.url = [NSURL URLWithString:[[directoryURL absoluteString] stringByReplacingOccurrencesOfString:@"file://" withString:@""]];
        //ALERT([self.url absoluteString]);
        self.name = [[directoryURL absoluteString] lastPathComponent];
        BOOL isDirectoryBool;
        [[NSFileManager defaultManager] fileExistsAtPath:[self.url absoluteString] isDirectory:&isDirectoryBool];
        self.isDirectory = isDirectoryBool;
    }
    return self;
}
@end