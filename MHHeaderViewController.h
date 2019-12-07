#import "MHViewController.h"
#import "MHTableEntry.h"

@interface MHHeaderViewController : MHViewController
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) UITextView *textView;
-(id)initWithURL:(NSURL *)url;
@end