#import "MHHeaderViewController.h"
#define ALERT(str) [[[UIAlertView alloc] initWithTitle:@"Alert" message:str delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil] show]

#define UICOLORMAKE(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
@implementation MHHeaderViewController
-(id)initWithURL:(NSURL *)url {
	if ((self = [super init])) {
		self.url = url;
	}
	return self;
}

-(void)highlightText {
    UIFont *customFont = [UIFont fontWithName:@"RobotoMono-Regular" size:12];
    NSDictionary *attributes = @{ NSFontAttributeName : customFont };
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.textView.text attributes:attributes];
    self.formattedText = [self highlightText:attributedString];
}

/*
Thanks qwertyuiop1379 in AnActuallyGoodFilzaEditor (https://github.com/qwertyuiop1379/AnActuallyGoodFilzaEditor/blob/master/Source/Tweak.xm)

*/
-(NSAttributedString *)highlightText:(NSAttributedString *)attributedString
{
    NSDictionary *syntax = [NSDictionary dictionaryWithContentsOfFile:[MHUtils URLForBundleResource:@"objc_syntax.plist"]];
    if (!syntax) 
        return attributedString;

    NSString *string = attributedString.string;
    NSRange range = NSMakeRange(0, string.length);
    NSMutableAttributedString *coloredString = attributedString.mutableCopy;

    [coloredString addAttribute:NSForegroundColorAttributeName value:UIColor.whiteColor range:range];

    NSMutableArray *keys = syntax.allKeys.mutableCopy;
    if ([keys containsObject:kRegexHighlightViewTypeString]) {
        [keys removeObject:kRegexHighlightViewTypeString];
        [keys addObject:kRegexHighlightViewTypeString];
    }
    if ([keys containsObject:kRegexHighlightViewTypeComment]) {
        [keys removeObject:kRegexHighlightViewTypeComment];
        [keys addObject:kRegexHighlightViewTypeComment];
    }

    for (NSString *key in keys) {
        NSString *expression = syntax[key];
        if (!expression || expression.length <= 0) continue;
        NSArray *matches = [[NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionDotMatchesLineSeparators error:nil] matchesInString:string options:0 range:range];
        for (NSTextCheckingResult *match in matches)
        {
            UIColor *textColor = UICOLORMAKE(255, 112, 226);
            if ([key isEqual: kRegexHighlightViewTypeDocumentationComment] || [key isEqual: kRegexHighlightViewTypeDocumentationCommentKeyword])
                textColor = UICOLORMAKE(166, 166, 166);

            [coloredString addAttribute:NSForegroundColorAttributeName value:textColor range:[match rangeAtIndex:0]];
        }
    }
    return coloredString.copy;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.textView.backgroundColor = [UIColor clearColor];
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:[[self.url absoluteString] stringByReplacingOccurrencesOfString:@"file://" withString:@""] encoding:NSUTF8StringEncoding error:&error];

    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.textView.editable = NO;
    self.textView.text = fileContents;
    [self highlightText];
    self.textView.attributedText = self.formattedText;

    [self.view addSubview: self.textView];
}
@end