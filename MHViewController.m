#import "MHViewController.h"

static BOOL darkTheme = 0;

@implementation MHViewController
-(id)init {
    if ((self = [super init])) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange) name:@"MHThemeDidChange" object:nil];
    }
    return self;
}
-(void)viewDidLoad {
    [super viewDidLoad];
    [self themeDidChange];
}
-(BOOL)darkTheme {
    return darkTheme;
}
-(void)setDarkTheme:(BOOL)new {
    darkTheme = new;
}

-(void)themeDidChange {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkModeEnabled"]) {
        self.view.backgroundColor = [UIColor blackColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    darkTheme = [[NSUserDefaults standardUserDefaults] boolForKey:@"darkModeEnabled"];
}
@end