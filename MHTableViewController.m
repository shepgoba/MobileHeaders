#import "MHTableViewController.h"

@implementation MHTableViewController
-(void)themeDidChange {
    [super themeDidChange];
    [self.tableView reloadData];
    self.tableView.indicatorStyle = self.darkTheme ? UIScrollViewIndicatorStyleWhite : UIScrollViewIndicatorStyleBlack;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}
@end