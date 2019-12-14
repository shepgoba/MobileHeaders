#import "MHSDKInstallerController.h"
#include <dlfcn.h>

#define ALERT(str) [[[UIAlertView alloc] initWithTitle:@"Alert" message:str delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil] show]
#define UICOLORMAKE(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
@implementation MHSDKInstallerController
-(id)init {
    if ((self = [super init])) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(installTaskFinished)
                                             name:@"MHSDKWasInstalled" 
                                           object:nil];
    }
    return self;
}
-(void)installTaskFinished {
    static int currentInstallCount = 0;
    currentInstallCount++;
    if (currentInstallCount >= self.installTaskCount) {
        [self allInstallTasksCompleted];
    }
}

-(void)allInstallTasksCompleted {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Complete"
                               message:@"All SDK headers have been successfully downloaded"
                               preferredStyle:UIAlertControllerStyleAlert];
            
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        for (MHSDKInstallEntry *entry in self.allEntriesToDownload)
            [entry.view installFinished];
    });
}

-(void)updateSDKViews {
    NSMutableDictionary *installedSDKs = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"installedSDKs"] mutableCopy];

    if (!installedSDKs) {
        ALERT(@"oof");
        installedSDKs = [[NSMutableDictionary alloc] init];
        for (NSDictionary *dict in self.SDKList[@"versions"]) {
            NSString *key = dict[@"ios-version"];
            installedSDKs[key] = @NO;
        }
        [[NSUserDefaults standardUserDefaults] setObject:installedSDKs forKey:@"installedSDKs"];
    }
    self.installableSDKViews = [[NSMutableArray alloc] init];
    self.installableSDKEntries = [[NSMutableArray alloc] init];
    NSArray *versions = self.SDKList[@"versions"];
    int versionCount = [versions count];
    int i = 0;

    self.installScrollView.contentSize = CGSizeMake(self.installScrollView.frame.size.width, versionCount*65+20);
    for (NSDictionary *dict in versions) {
        if (!dict) {            
            NSLog(@"error");
            return;
        }
        int finalOffset = 20 + i * 65;
        MHSDKInstallEntry *entry = [[MHSDKInstallEntry alloc] initWithDictionary:dict];
        [self.installableSDKEntries addObject: entry];
        if ([installedSDKs[entry.iosVersion] intValue]) {
            entry.installed = YES;
        }
        
        MHSDKInstallableView *installableSDKView = [[MHSDKInstallableView alloc] initWithEntry:entry controller:self];
        [self.installableSDKViews addObject: installableSDKView];
        [self.installScrollView addSubview: installableSDKView];
        
        installableSDKView.translatesAutoresizingMaskIntoConstraints = false;
        [installableSDKView.centerXAnchor constraintEqualToAnchor:self.installScrollView.centerXAnchor].active = YES;

        [NSLayoutConstraint constraintWithItem:installableSDKView
                                    attribute:NSLayoutAttributeWidth
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.installScrollView  
                                    attribute:NSLayoutAttributeWidth
                                    multiplier:0.9f
                                    constant:0.f].active = YES;

        [NSLayoutConstraint constraintWithItem:installableSDKView
                                    attribute:NSLayoutAttributeTop
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.installScrollView  
                                    attribute:NSLayoutAttributeTop
                                    multiplier:1.f
                                    constant:finalOffset].active = YES;
        [installableSDKView setup];
        
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
        self.SDKList = [NSMutableDictionary dictionaryWithContentsOfFile:fileName];
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

    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(confirmInstallSelectedSDKs)];
    [self.confirmInstallButton addGestureRecognizer:singleFingerTap];

    UILabel *confirmInstallButtonText = [[UILabel alloc] init];
    confirmInstallButtonText.translatesAutoresizingMaskIntoConstraints = false;
    confirmInstallButtonText.text = @"Confirm";
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
    //[self.installScrollView addSubview: self.installContainerView];

    self.headerLabel.translatesAutoresizingMaskIntoConstraints = false;
    //self.installContainerView.translatesAutoresizingMaskIntoConstraints = false;
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

    self.installedSDKs = [NSMutableDictionary dictionaryWithContentsOfFile:[MHUtils URLForDocumentsResource:@"installedSDKs.plist"]];
    [self downloadSDKListIfNecessary];
}

- (void) findAllEntriesToDelete {
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    for (MHSDKInstallEntry *entry in self.installableSDKEntries) {
        if (entry && entry.isInstalled && entry.shouldUninstall) {
            [tmp addObject: entry];
        }
    }
    self.allEntriesToDelete = [tmp copy];
}

- (void) findAllEntriesToDownload {
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    for (MHSDKInstallEntry *entry in self.installableSDKEntries) {
        if (entry && entry.shouldInstall && !entry.isInstalled) {
            [tmp addObject: entry];
        }
    }
    self.allEntriesToDownload = [tmp copy];
}
float MB(int bytes) {
    return ((float)bytes / (1024.f * 1024.f));
}
-(void)confirmInstallSelectedSDKs {
    [self.confirmInstallButton setActive:NO];
    self.allEntriesToDownload = [[NSMutableArray alloc] init];

    [self findAllEntriesToDownload];
    [self findAllEntriesToDelete];
    self.installTaskCount = self.allEntriesToDownload.count;
        
    int totalDownloadSize = 0;
    int totalDiskUsage = 0;
    int totalFreeSize = 0;

    for (MHSDKInstallEntry *entry in self.allEntriesToDownload) {
        totalDownloadSize += entry.size;
        totalDiskUsage += entry.installedSize;
    }
    for (MHSDKInstallEntry *entry in self.allEntriesToDelete) {
        totalFreeSize += entry.installedSize;
    }
    NSString *alertString = [NSString stringWithFormat:@"This will download %0.2fMB and take up %0.2fMB on your system. This will free up %0.2fMB", MB(totalDownloadSize), MB(totalDiskUsage), MB(totalFreeSize)];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Are you sure you want to apply these changes?" message:alertString preferredStyle:UIAlertControllerStyleAlert];
 
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
         [self installSelectedSDKs];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    [self.confirmInstallButton setActive:YES];
}

-(void)uninstallSDKsIfNecessary {
    for (MHSDKInstallEntry *entry in self.allEntriesToDelete) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if([[NSFileManager defaultManager] removeItemAtPath:entry.saveLocation error:nil]) {
                for (MHSDKInstallEntry *entry in self.allEntriesToDelete) {
                    [entry.view uninstallFinished];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                 UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Success" message:@"SDK headers have been uninstalled successfully" preferredStyle:UIAlertControllerStyleAlert];
            
                UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
                });
            }
        });

        
        NSMutableDictionary *installedSDKs = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"installedSDKs"] mutableCopy];
        installedSDKs[entry.iosVersion] = @NO;
        [[NSUserDefaults standardUserDefaults] setObject:installedSDKs forKey:@"installedSDKs"];
    }
}

-(void)installSelectedSDKs {
    [self uninstallSDKsIfNecessary];
    self.installTasks = [[NSMutableArray alloc] init];

    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    for (MHSDKInstallEntry *entry in self.allEntriesToDownload) {
        MHSDKInstallTaskDelegate *newTask = [[MHSDKInstallTaskDelegate alloc] initWithEntry:entry controller:self];
        [self.installTasks addObject:newTask];
        [entry.view setupProgressBar];

        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:newTask delegateQueue:nil];
        NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:entry.SDKURL];
        [downloadTask resume];
        
    }
    [self.confirmInstallButton setActive:YES];
}
@end