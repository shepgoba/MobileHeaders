@interface MHUtils : NSObject
+ (NSString *)URLForDocumentsResource:(NSString *)file;
+ (NSString *)URLForBundleResource:(NSString *)resource;
+ (void) indexHeadersAndPresentAlertOn:(UIViewController *)controller;
@end