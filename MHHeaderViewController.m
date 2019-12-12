#import "MHHeaderViewController.h"

@implementation MHHeaderViewController
-(id)initWithURL:(NSURL *)url {
	if ((self = [super init])) {
		self.url = url;
	}
	return self;
}
-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:[[self.url absoluteString] stringByReplacingOccurrencesOfString:@"file://" withString:@""] encoding:NSUTF8StringEncoding error:&error];
/*
    NSArray *listArray = [fileContents componentsSeparatedByString:@"\n"];
    NSMutableArray *mut = [listArray mutableCopy];
    NSMutableArray *final = [[NSMutableArray alloc] init];
    ///NSLog(@"items = %d", [listArray count]);
    for (int i = 0; i < listArray.count; i++) {
        NSString *lineNumber = [NSString stringWithFormat:@"%d ", i];
        NSMutableString *content = [mut[i] mutableCopy];
        [content insertString:lineNumber atIndex:0];
        [final addObject:content];
    }  
    NSString *result = [final componentsJoinedByString:@"\n"];*/

    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.textView.font = [UIFont fontWithName:@"RobotoMono-Regular" size:10];
    self.textView.editable = NO;
    self.textView.text = fileContents;

    [self.view addSubview: self.textView];
}
@end