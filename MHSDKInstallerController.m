#import "MHSDKInstallerController.h"
#define ALERT(str) [[[UIAlertView alloc] initWithTitle:@"cummy" message:str delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil] show]
#define UICOLORMAKE(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
@implementation MHSDKInstallerController
-(void)updateSDKViews {
    self.installableSDKViews = [[NSMutableArray alloc] init];
    self.installableSDKEntries = [[NSMutableArray alloc] init];
    NSArray *versions = self.SDKList[@"versions"];
    int versionCount = [versions count];
    int i = 0;
    self.installScrollView.contentSize = CGSizeMake(self.installScrollView.frame.size.width, versionCount*100);
    for (NSDictionary *dict in versions) {
        if (!dict) {            
            NSLog(@"error");
            return;
        }
        int final = 20 + (i*65);
        MHSDKInstallEntry *entry = [[MHSDKInstallEntry alloc] initWithDictionary:dict];
        [self.installableSDKEntries addObject: entry];
        
        MHSDKInstallableView *installableSDKView = [[MHSDKInstallableView alloc] initWithEntry:entry];
        [self.installableSDKViews addObject: installableSDKView];
        [self.installContainerView addSubview: installableSDKView];
        
        installableSDKView.translatesAutoresizingMaskIntoConstraints = false;
        [installableSDKView.centerXAnchor constraintEqualToAnchor:self.installContainerView.centerXAnchor].active = YES;

        [NSLayoutConstraint constraintWithItem:installableSDKView
                                    attribute:NSLayoutAttributeWidth
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.installContainerView  
                                    attribute:NSLayoutAttributeWidth
                                    multiplier:0.9f
                                    constant:0.f].active = YES;

        [NSLayoutConstraint constraintWithItem:installableSDKView
                                    attribute:NSLayoutAttributeTop
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.installContainerView  
                                    attribute:NSLayoutAttributeTop
                                    multiplier:1.f
                                    constant:final].active = YES;
        [installableSDKView setup];

        installableSDKView.versionLabel.translatesAutoresizingMaskIntoConstraints = false;
        [NSLayoutConstraint constraintWithItem:installableSDKView.versionLabel
                                        attribute:NSLayoutAttributeCenterY
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:installableSDKView  
                                        attribute:NSLayoutAttributeCenterY
                                        multiplier:1.f
                                        constant:0.f].active = YES;
        [NSLayoutConstraint constraintWithItem:installableSDKView.versionLabel
                                        attribute:NSLayoutAttributeLeading
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:installableSDKView  
                                        attribute:NSLayoutAttributeLeading
                                        multiplier:1.f
                                        constant:15.f].active = YES;
        installableSDKView.shouldInstallSwitch.translatesAutoresizingMaskIntoConstraints = false;
        [NSLayoutConstraint constraintWithItem:installableSDKView.shouldInstallSwitch
                                        attribute:NSLayoutAttributeCenterY
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:installableSDKView  
                                        attribute:NSLayoutAttributeCenterY
                                        multiplier:1.f
                                        constant:0.f].active = YES;
        [NSLayoutConstraint constraintWithItem:installableSDKView.shouldInstallSwitch
                                        attribute:NSLayoutAttributeTrailing
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:installableSDKView  
                                        attribute:NSLayoutAttributeTrailing
                                        multiplier:1.f
                                        constant:-15.f].active = YES;
        i++;
    }
}

-(void)downloadSDKListIfNecessary {
    NSString *fileName = [MHUtils URLForDocumentsResource:@"SDKList.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName isDirectory:0]) {
        self.SDKList = [NSDictionary dictionaryWithContentsOfFile:fileName];
        [self updateSDKViews];
        return;
    }
    [self downloadSDKList];
}
-(void)downloadSDKList {
    static NSString *stringURL = @"https://raw.githubusercontent.com/shepgoba/shepgoba.github.io/master/mobileheaders/sdks.plist";
    NSString *fileName = [MHUtils URLForDocumentsResource:@"SDKList.plist"];
    NSURL *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if (urlData) {
        if ([urlData writeToFile:fileName atomically:YES]) {
            self.SDKList = [NSDictionary dictionaryWithContentsOfFile:fileName];
            [self updateSDKViews];
        } else {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                               message:@"An error occured and the SDK list could not saved."
                               preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                               message:@"An error occured and the SDK list could not be downloaded"
                               preferredStyle:UIAlertControllerStyleAlert];
            
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
            
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
-(void)viewDidLoad {
    [super viewDidLoad];
    [self themeDidChange];

    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.headerLabel.text = @"Download SDK Headers";
    self.headerLabel.textColor = self.darkTheme ? [UIColor whiteColor] : [UIColor blackColor];
    self.headerLabel.font = [UIFont boldSystemFontOfSize:30];
    [self.headerLabel sizeToFit];

    self.installContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.installContainerView.layer.cornerRadius = 20;

    self.installScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.installScrollView.backgroundColor = self.darkTheme ? UICOLORMAKE(50, 50, 50) : UICOLORMAKE(235, 235, 235);
    self.installScrollView.layer.cornerRadius = 20;
    self.installScrollView.minimumZoomScale = 1;
    self.installScrollView.scrollEnabled = YES;
    self.installScrollView.showsHorizontalScrollIndicator = YES;

    self.confirmInstallButton = [[MHSDKConfirmInstallView alloc] init];
    self.confirmInstallButton.layer.cornerRadius = 15;
    self.confirmInstallButton.translatesAutoresizingMaskIntoConstraints = false;
    self.confirmInstallButton.backgroundColor = UICOLORMAKE(22, 219, 22);

    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(installSelectedSDKs)];
    [self.confirmInstallButton addGestureRecognizer:singleFingerTap];

    UILabel *confirmInstallButtonText = [[UILabel alloc] init];
    confirmInstallButtonText.translatesAutoresizingMaskIntoConstraints = false;
    confirmInstallButtonText.text = @"Install";
    confirmInstallButtonText.font = [UIFont boldSystemFontOfSize:18];
    [confirmInstallButtonText sizeToFit];

    [self.view addSubview:self.confirmInstallButton];
    [self.confirmInstallButton addSubview:confirmInstallButtonText];

    [confirmInstallButtonText.centerXAnchor constraintEqualToAnchor:self.confirmInstallButton.centerXAnchor].active = YES;
    [confirmInstallButtonText.centerYAnchor constraintEqualToAnchor:self.confirmInstallButton.centerYAnchor].active = YES;

    [self.confirmInstallButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [NSLayoutConstraint constraintWithItem:self.confirmInstallButton
                                attribute:NSLayoutAttributeHeight
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view  
                                attribute:NSLayoutAttributeHeight
                                multiplier:0.05f
                                constant:0.f].active = YES;

    [NSLayoutConstraint constraintWithItem:self.confirmInstallButton
                                attribute:NSLayoutAttributeWidth
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view  
                                attribute:NSLayoutAttributeWidth
                                multiplier:0.5f
                                constant:0.f].active = YES;

    [NSLayoutConstraint constraintWithItem:self.confirmInstallButton
                                attribute:NSLayoutAttributeCenterY
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view  
                                attribute:NSLayoutAttributeCenterY
                                multiplier:1.6f
                                constant:0.f].active = YES;



    [self.view addSubview: self.headerLabel];
    [self.view addSubview: self.installScrollView];
    [self.installScrollView addSubview: self.installContainerView];

    self.headerLabel.translatesAutoresizingMaskIntoConstraints = false;
    self.installContainerView.translatesAutoresizingMaskIntoConstraints = false;
    self.installScrollView.translatesAutoresizingMaskIntoConstraints = false;

    [self.headerLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [NSLayoutConstraint constraintWithItem:self.headerLabel
                                attribute:NSLayoutAttributeCenterY
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view  
                                attribute:NSLayoutAttributeCenterY
                                multiplier:0.4f
                                constant:0.f].active = YES;


    [self.installScrollView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [NSLayoutConstraint constraintWithItem:self.installScrollView
                                attribute:NSLayoutAttributeCenterY
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view  
                                attribute:NSLayoutAttributeCenterY
                                multiplier:1.0f
                                constant:0.f].active = YES;

    [NSLayoutConstraint constraintWithItem:self.installScrollView
                                attribute:NSLayoutAttributeWidth
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view  
                                attribute:NSLayoutAttributeWidth
                                multiplier:0.75f
                                constant:0.f].active = YES;      
    [NSLayoutConstraint constraintWithItem:self.installScrollView
                                attribute:NSLayoutAttributeHeight
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view  
                                attribute:NSLayoutAttributeHeight
                                multiplier:0.4f
                                constant:0.f].active = YES;                      

    [self.installContainerView.centerXAnchor constraintEqualToAnchor:self.installScrollView.centerXAnchor].active = YES;
    [NSLayoutConstraint constraintWithItem:self.installContainerView
                                attribute:NSLayoutAttributeCenterY
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.installScrollView  
                                attribute:NSLayoutAttributeCenterY
                                multiplier:1.0f
                                constant:0.f].active = YES;

    [NSLayoutConstraint constraintWithItem:self.installContainerView
                                attribute:NSLayoutAttributeWidth
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.installScrollView 
                                attribute:NSLayoutAttributeWidth
                                multiplier:1.0f
                                constant:0.f].active = YES;

    [NSLayoutConstraint constraintWithItem:self.installContainerView
                                attribute:NSLayoutAttributeHeight
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.installScrollView  
                                attribute:NSLayoutAttributeHeight
                                multiplier:1.0f
                                constant:0.f].active = YES;


    

    [self downloadSDKListIfNecessary];
}

- (void) findAllEntriesToDownload {
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    for (MHSDKInstallEntry *entry in self.installableSDKEntries) {
        if (entry && entry.shouldInstall) {
            [tmp addObject: entry];
        }
    }
    self.allEntriesToDownload = [tmp copy];
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSString *fileName = [downloadTask.originalRequest.URL.absoluteString lastPathComponent];
    NSData *data = [NSData dataWithContentsOfURL:location];
    dispatch_async(dispatch_get_main_queue(), ^{
        [data writeToFile:[MHUtils URLForDocumentsResource:fileName] atomically:NO];
    });
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {

    float progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{

        for (MHSDKInstallEntry *entry in self.allEntriesToDownload) {
            if ([entry.SDKURL.absoluteString isEqualToString: downloadTask.originalRequest.URL.absoluteString])
                [entry.view.progressBar setProgress:progress];
        }

    });
}
-(void)installSelectedSDKs {
    [self.confirmInstallButton setActive:NO];
    self.allEntriesToDownload = [NSMutableArray new];
    [self findAllEntriesToDownload];

    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];

    for (MHSDKInstallEntry *entry in self.allEntriesToDownload) {
        [entry.view setupProgressBar];
        NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:entry.SDKURL];
        [downloadTask resume];
        
    }
}
@end