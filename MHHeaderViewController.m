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
    NSString *fileContents = [NSString stringWithContentsOfFile:self.url encoding:NSUTF8StringEncoding error:&error];

    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.textView.editable = NO;
    self.textView.text = fileContents;

    [self.view addSubview: self.textView];
}
@end