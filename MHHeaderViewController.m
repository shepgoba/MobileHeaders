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

-(void)themeDidChange {
    [super themeDidChange];
    if (self.textView) {
        //[self formatText:self.formattedText];
        //self.textView.attributedText = self.formattedText;
    }
}

-(void)formatText:(NSString *)str {
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
    [self formatText:fileContents];

    NSString *css = [NSString stringWithFormat:@"<head>"
                        "<link rel=\"stylesheet\" type=\"text/css\" href=\"headerView.css\">"
                        "</head>"];
    NSDictionary *documentAttributes = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};    
    NSData *htmlData = [self.formattedText dataFromRange:NSMakeRange(0, self.formattedText.length) documentAttributes:documentAttributes error:NULL];
    NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    NSString *finalHeaderString = [NSString stringWithFormat:@"%@%@", css, htmlString];
    /*self.textView = [[UITextView alloc] init];
    self.textView.delegate = self;
    self.textView.scrollEnabled = NO;
    self.textView.editable = NO;
    self.textView.text = fileContents;

    self.textView.attributedText = self.formattedText;
    self.textView.backgroundColor = [UIColor clearColor];

    self.textContainerView = [[UIScrollView alloc] init];
    self.textContainerView.backgroundColor = [UIColor clearColor];*/

    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    self.headerView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    [self.headerView loadHTMLString:finalHeaderString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"headerView" ofType:@"css"]]];
    self.headerView.scrollView.backgroundColor = [UIColor clearColor];
    self.headerView.opaque = NO;
    self.headerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.headerView];
    //UIFont *customFont = [UIFont fontWithName:@"RobotoMono-Regular" size:12];
    /*CGRect textRect = [self.textView.text boundingRectWithSize:CGSizeMake(9999,9999)   
                         options:NSStringDrawingUsesLineFragmentOrigin
                         attributes:@{NSFontAttributeName:customFont}
                         context:nil];*/

    //self.textView.contentSize = CGSizeMake(textRect.size.width + 20, textRect.size.height + 20);
    /*[self.view addSubview:self.textContainerView];
    [self.textContainerView addSubview:self.textView];

        self.textContainerView.contentSize = CGSizeMake(textRect.size.width, textRect.size.height);

    self.textContainerView.translatesAutoresizingMaskIntoConstraints = false;
    self.textView.translatesAutoresizingMaskIntoConstraints = false;

    if (@available(iOS 11, *)) {
        UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
        [self.textContainerView.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor].active = YES;
        [self.textContainerView.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor].active = YES;
        [self.textContainerView.topAnchor constraintEqualToAnchor:guide.topAnchor].active = YES;
        [self.textContainerView.bottomAnchor constraintEqualToAnchor:guide.bottomAnchor].active = YES;

    } else {
        UILayoutGuide *margins = self.view.layoutMarginsGuide;
        [self.textContainerView.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor].active = YES;
        [self.textContainerView.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor].active = YES;
        [self.textContainerView.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor].active = YES;
        [self.textContainerView.bottomAnchor constraintEqualToAnchor:self.bottomLayoutGuide.topAnchor].active = YES;
    }
    [self.textView.leadingAnchor constraintEqualToAnchor:self.textContainerView.leadingAnchor].active = YES;
    [self.textView.trailingAnchor constraintEqualToAnchor:self.textContainerView.trailingAnchor].active = YES;
    [self.textView.topAnchor constraintEqualToAnchor:self.textContainerView.topAnchor].active = YES;
    [self.textView.bottomAnchor constraintEqualToAnchor:self.textContainerView.bottomAnchor].active = YES;*/

}
@end