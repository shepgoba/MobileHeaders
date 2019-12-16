#import "MHSearchViewController.h"

@implementation MHSearchViewController
-(NSMutableArray *)recursiveSearchForFilesWithName:(NSString *)name startingURL:(NSURL *)url {
    NSMutableArray *filteredEntries = [[NSMutableArray alloc] init];

    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{    
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];

        NSDirectoryEnumerator *enumerator = [fileManager
            enumeratorAtURL:url
            includingPropertiesForKeys:keys
            options:0
            errorHandler:^(NSURL *url, NSError *error) {
                // Handle the error.
                // Return YES if the enumeration should continue after the error.
                return YES;
        }];

        for (NSURL *url in enumerator) { 
            NSError *error;
            NSNumber *isDirectory = nil;
            if (! [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error]) {
                // handle error
            }
            else if (! [isDirectory boolValue]) {
                // No error and it’s not a directory; do something with the file
                NSString *fileName = url.absoluteString.lastPathComponent;
                if ([fileName localizedCaseInsensitiveContainsString: name]) {
                    MHTableEntry *entry = [[MHTableEntry alloc] initWithURL:url];
                    [filteredEntries addObject: entry];
                }
            }
        }
    //});
    return filteredEntries;
}
-(NSMutableArray *)contentsOfDirectory:(NSURL *)url {
    NSMutableArray *entries = [NSMutableArray new];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *properties = [NSArray arrayWithObjects: NSURLLocalizedNameKey, nil];
	NSError *error = nil;
	NSMutableArray *URLs = [[fileManager contentsOfDirectoryAtURL:url
								includingPropertiesForKeys:properties
                   				options:(NSDirectoryEnumerationSkipsPackageDescendants)
                   				error:&error] mutableCopy];
	for (NSURL *url in URLs) {
		MHTableEntry *fileObject = [[MHTableEntry alloc] initWithURL:url];
		[entries addObject:fileObject];
	}
	//NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
	//NSArray *entry = [entries sortedArrayUsingDescriptors:@[sortDescriptor]];
	return entries;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.entries.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	MHTableEntry *entry = self.entries[indexPath.row];
	cell.textLabel.text = entry.name;
    cell.detailTextLabel.text = entry.extraInfo;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
	if (!cell || !cell.detailTextLabel) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:_cellIdentifier];
	}
	if (self.darkTheme) {
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    } else {
       cell.textLabel.textColor = [UIColor blackColor];
       cell.detailTextLabel.textColor = [UIColor blackColor];
	}
	cell.backgroundColor = [UIColor clearColor];
	return cell;
}
- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.searchController.searchBar setShowsCancelButton:NO animated:YES];
	[self.searchController dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	NSString *searchText = searchBar.text;
	if (searchText && searchText.length > 0) {
		//NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
		//NSArray *newEntries = [self.entries filteredArrayUsingPredicate:predicate];
		self.entries = [self recursiveSearchForFilesWithName:searchText startingURL:[NSURL fileURLWithPath:[MHUtils URLForDocumentsResource:@"Data"]]];
	} else {
        self.entries = nil;
    }
	[self.tableView reloadData];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
	
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self.searchController resignFirstResponder];
	MHTableEntry *currentObject = [self.entries objectAtIndex:indexPath.row];
	if (currentObject.isDirectory) {
		//MHExplorerViewController *newViewController = [[MHExplorerViewController alloc] initWithURL:currentObject.url];
		//[self.navigationController pushViewController: newViewController animated:YES];
	} else {
		MHHeaderViewController *headerViewController = [[MHHeaderViewController alloc] initWithURL:currentObject.url];
		[self.navigationController pushViewController: headerViewController animated:YES];
	}

}

- (void)didPresentSearchController:(UISearchController *)searchController {
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.searchController.searchBar setShowsCancelButton:YES animated:YES];
	});
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.entries = nil;
    [self.tableView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
		[self.searchController.searchBar setShowsCancelButton:NO animated:YES];
        [self.searchController setActive:NO];
    });
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Search";
    _cellIdentifier = @"SearchCells";

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
	self.tableView.backgroundColor = [UIColor clearColor];
    //self.tableView.alpha = 0;
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:_cellIdentifier];

	self.tableView.delegate = self;
	self.tableView.dataSource = self;

	[self.view addSubview:self.tableView];


	self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
	self.searchController.delegate = self;
	self.searchController.searchBar.barStyle = self.darkTheme ? UIBarStyleBlack : UIBarStyleDefault;
	self.searchController.searchResultsUpdater = self;
	self.searchController.hidesNavigationBarDuringPresentation = NO;
	self.searchController.definesPresentationContext = YES;
	self.searchController.dimsBackgroundDuringPresentation = NO;
	self.searchController.searchBar.delegate = self;

	self.tableView.tableHeaderView = self.searchController.searchBar;

    self.entries = nil;//[self contentsOfDirectory:[NSURL URLWithString:[MHUtils URLForDocumentsResource:@"Data"]]];
}
@end