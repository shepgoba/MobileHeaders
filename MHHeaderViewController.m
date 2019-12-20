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
        [self highlightText];
        self.textView.attributedText = self.formattedText;
    }
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
    //NSString *finalContents = [self textWithAddedLineCount:fileContents];

    self.textView = [[UITextView alloc] init];
    self.textView.delegate = self;
    self.textView.editable = NO;
    self.textView.text = fileContents;

    [self highlightText];

    self.textView.attributedText = self.formattedText;
    self.textView.backgroundColor = [UIColor clearColor];

    self.lineNumbersView = [[UIScrollView alloc] init];
    self.lineNumbersView.backgroundColor = [UIColor grayColor];

    [self.view addSubview:self.textView];

    self.textView.translatesAutoresizingMaskIntoConstraints = false;
    if (@available(iOS 11, *)) {
        UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
        [self.textView.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor].active = YES;
        [self.textView.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor].active = YES;
        [self.textView.topAnchor constraintEqualToAnchor:guide.topAnchor].active = YES;
        [self.textView.bottomAnchor constraintEqualToAnchor:guide.bottomAnchor].active = YES;
    } else {
        UILayoutGuide *margins = self.view.layoutMarginsGuide;
        [self.textView.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor].active = YES;
        [self.textView.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor].active = YES;
        [self.textView.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor].active = YES;
        [self.textView.bottomAnchor constraintEqualToAnchor:self.bottomLayoutGuide.topAnchor].active = YES;
    }

}
@end