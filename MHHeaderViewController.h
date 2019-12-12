#import "MHViewController.h"
#import "MHUtils.h"
#import "MHTableEntry.h"

#define kRegexHighlightViewTypeText @"text"
#define kRegexHighlightViewTypeBackground @"background"
#define kRegexHighlightViewTypeComment @"comment"
#define kRegexHighlightViewTypeDocumentationComment @"documentation_comment"
#define kRegexHighlightViewTypeDocumentationCommentKeyword @"documentation_comment_keyword"
#define kRegexHighlightViewTypeString @"string"
#define kRegexHighlightViewTypeCharacter @"character"
#define kRegexHighlightViewTypeNumber @"number"
#define kRegexHighlightViewTypeKeyword @"keyword"
#define kRegexHighlightViewTypePreprocessor @"preprocessor"
#define kRegexHighlightViewTypeURL @"url"
#define kRegexHighlightViewTypeAttribute @"attribute"
#define kRegexHighlightViewTypeProject @"project"
#define kRegexHighlightViewTypeOther @"other"

@interface MHHeaderViewController : MHViewController
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSAttributedString *formattedText;

//Thanks qwertyuiop1379
-(id)initWithURL:(NSURL *)url;
-(NSAttributedString *)highlightText:(NSAttributedString *)attributedString;
@end