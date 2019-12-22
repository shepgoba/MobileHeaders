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

-(NSString *)textWithAddedLineCount:(NSString *)str {
    NSArray *data = [str componentsSeparatedByString:@"\n"];
    NSMutableArray *newData = [[NSMutableArray alloc] init];
    int index = 0;
    for (NSString *line in data) {
        NSString *newStr = [NSString stringWithFormat:@"%d %@", index, line];
        [newData addObject:newStr];
        index++;
    }
    NSString *finalString = [newData componentsJoinedByString:@"\n"];
    return finalString;
}

-(void)updateWebViewContent {
    NSString *css = [NSString stringWithFormat:@"<head>"
                        "<link rel=\"stylesheet\" type=\"text/css\" href=\"headerView.css\">"
                        "</head>"];
    NSDictionary *documentAttributes = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};    
    NSData *htmlData = [self.formattedText dataFromRange:NSMakeRange(0, self.formattedText.length) documentAttributes:documentAttributes error:NULL];
    NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    NSString *finalHeaderString = [NSString stringWithFormat:@"%@%@", css, htmlString];
    [self.headerView loadHTMLString:finalHeaderString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"headerView" ofType:@"css"]]];
}

-(void)themeDidChange {
    [super themeDidChange];
    if (self.headerView) {
        [self formatText];
        [self updateWebViewContent];
        self.headerView.scrollView.indicatorStyle = self.darkTheme ? UIScrollViewIndicatorStyleWhite : UIScrollViewIndicatorStyleBlack;
    }
}

-(void)formatText {
    NSString *str = self.rawText;
    UIFont *customFont = [UIFont fontWithName:@"RobotoMono-Regular" size:18];
    NSDictionary *attributes = @{ NSFontAttributeName : customFont };
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str attributes:attributes];
    self.formattedText = [self highlightText:attributedString];
}

/*
Thanks qwertyuiop1379 in AnActuallyGoodFilzaEditor (https://github.com/qwertyuiop1379/AnActuallyGoodFilzaEditor/blob/master/Source/Tweak.xm)

*/
-(NSAttributedString *)highlightText:(NSAttributedString *)attributedString {
    NSDictionary *syntax = [NSDictionary dictionaryWithContentsOfFile:[MHUtils URLForBundleResource:@"objc_syntax.plist"]];
    if (!syntax) 
        return attributedString;

    NSString *string = attributedString.string;
    NSRange range = NSMakeRange(0, string.length);
    NSMutableAttributedString *coloredString = attributedString.mutableCopy;

    [coloredString addAttribute:NSForegroundColorAttributeName value:(self.darkTheme ? [UIColor whiteColor] : [UIColor blackColor]) range:range];

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
            UIColor *textColor;
            if ([key isEqual: kRegexHighlightViewTypeDocumentationComment] || [key isEqual: kRegexHighlightViewTypeDocumentationCommentKeyword] || [key isEqual: kRegexHighlightViewTypeComment])
                textColor = UICOLORMAKE(166, 166, 166);
            else if ([key isEqual: kRegexHighlightViewTypePreprocessor])
                textColor = UICOLORMAKE(139, 175, 105);
            else
                textColor = UICOLORMAKE(255, 112, 226);

            [coloredString addAttribute:NSForegroundColorAttributeName value:textColor range:[match rangeAtIndex:0]];
        }
    }
    return coloredString.copy;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.url.absoluteString.lastPathComponent;
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:[[self.url absoluteString] stringByReplacingOccurrencesOfString:@"file://" withString:@""] encoding:NSUTF8StringEncoding error:&error];
    self.rawText = fileContents;
    [self formatText];

    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    self.headerView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    //[self.headerView loadHTMLString:finalHeaderString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"headerView" ofType:@"css"]]];
    self.headerView.scrollView.backgroundColor = [UIColor clearColor];
    self.headerView.opaque = NO;
    self.headerView.backgroundColor = [UIColor clearColor];
    self.headerView.scrollView.indicatorStyle = self.darkTheme ? UIScrollViewIndicatorStyleWhite : UIScrollViewIndicatorStyleBlack;
    [self updateWebViewContent];
    [self.view addSubview:self.headerView];

}
@end