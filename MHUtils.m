#import "MHUtils.h"
@implementation MHUtils
+ (void) indexHeadersAndPresentAlertOn:(UIViewController *)controller {    
    NSMutableArray *files = [[NSMutableArray alloc] init];
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];
    NSString *urlString = [MHUtils URLForDocumentsResource:@"HeaderData"];
    NSDirectoryEnumerator *enumerator = [fileManager
        enumeratorAtURL:[NSURL URLWithString:urlString]
        includingPropertiesForKeys:keys
        options:0
        errorHandler:nil];

    for (NSURL *url in enumerator) { 
        NSError *error;
        NSNumber *isDirectory = nil;
        if (![url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error]) {
			UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Files could not be searched. Try again" preferredStyle:UIAlertControllerStyleAlert];
			UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
			[errorAlert addAction:defaultAction];
			[controller presentViewController:errorAlert animated:YES completion:nil];
        } else if (![isDirectory boolValue]) {
            //NSString *fileName = url.absoluteString.lastPathComponent;
            NSString *path = url.absoluteString;
            NSUInteger index = [path rangeOfString:@"HeaderData"].location;
            NSString *finalPath = [path substringFromIndex:index];
            [files addObject:finalPath];
        }
    }
   if ([files writeToFile:[MHUtils URLForDocumentsResource:@"indexedFiles.dat"] atomically:NO]) {
      UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:@"Success" message:@"All headers have been successfully indexed. (Much faster search)" preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
		[successAlert addAction:defaultAction];
		[controller presentViewController:successAlert animated:YES completion:nil];
   }
}

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