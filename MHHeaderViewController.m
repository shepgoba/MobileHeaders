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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    static CGFloat previousOffset;
    CGRect rect = self.lineNumbersView.frame;
    rect.origin.y += previousOffset - scrollView.contentOffset.y;
    previousOffset = scrollView.contentOffset.y;
    self.lineNumbersView.frame = rect;
}

-(void)getLineCountForString:(NSString *)str {
	int numberOfLines, index, stringLength = [str length];

	for (index = 0, numberOfLines = 0; index < stringLength; numberOfLines++)
    	index = NSMaxRange([str lineRangeForRange:NSMakeRange(index, 0)]);
	
	self.lineCount = numberOfLines;
}

-(void)themeDidChange {
    [super themeDidChange];
    if (self.textView) {
        [self highlightText];
        self.textView.attributedText = self.formattedText;
    }
}

-(void)setupLineNumbers {
    //int numLines = self.textView.contentSize.height / self.textView.font.lineHeight;   
    UIFont *lineNumberFont = [UIFont fontWithName:@"RobotoMono-Regular" size:12];
    for (int i = 0; i < self.lineCount; i++) { 
        UILabel *lineNumberLabel = [[UILabel alloc] init];
        lineNumberLabel.text = [NSString stringWithFormat:@"%d", i+1];
        lineNumberLabel.textColor = [UIColor whiteColor];
        lineNumberLabel.textAlignment = NSTextAlignmentCenter;
        lineNumberLabel.center = CGPointMake(self.lineNumbersView.center.x, self.textView.font.lineHeight * i);
        lineNumberLabel.font = lineNumberFont;
        [lineNumberLabel sizeToFit];
        [self.lineNumbersView addSubview: lineNumberLabel];
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
-(NSAttributedString *)highlightText:(NSAttributedString *)attributedString
{
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
            if ([key isEqual: kRegexHighlightViewTypeDocumentationComment] || [key isEqual: kRegexHighlightViewTypeDocumentationCommentKeyword])
                textColor = UICOLORMAKE(166, 166, 166);
            else
                textColor = UICOLORMAKE(255, 112, 226);

            [coloredString addAttribute:NSForegroundColorAttributeName value:textColor range:[match rangeAtIndex:0]];
        }
    }
    return coloredString.copy;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:[[self.url absoluteString] stringByReplacingOccurrencesOfString:@"file://" withString:@""] encoding:NSUTF8StringEncoding error:&error];
    [self getLineCountForString:fileContents];
    self.contentLines = [fileContents componentsSeparatedByString:@"\n"];

    self.textView = [[UITextView alloc] init];
    //self.textView.bounces = NO;
    self.textView.delegate = self;
    self.textView.editable = NO;
    self.textView.text = fileContents;

    [self highlightText];

    self.textView.attributedText = self.formattedText;
    self.textView.backgroundColor = [UIColor clearColor];

    self.lineNumbersView = [[UIScrollView alloc] init];
    self.lineNumbersView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.lineNumbersView];
    [self.view addSubview:self.textView];

    self.textView.translatesAutoresizingMaskIntoConstraints = false;
    [self.textView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:0.0].active = YES;
    [self.textView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:0.0].active = YES;
    [self.textView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:30.0].active = YES;
    [self.textView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0.0].active = YES;

    self.lineNumbersView.translatesAutoresizingMaskIntoConstraints = false;
    [self.lineNumbersView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:0.0].active = YES;
    [self.lineNumbersView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:0.0].active = YES;
    [self.lineNumbersView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0.0].active = YES;
    [self.lineNumbersView.trailingAnchor constraintEqualToAnchor:self.view.leadingAnchor  constant:30.0].active = YES;

    [self setupLineNumbers];
}
@end