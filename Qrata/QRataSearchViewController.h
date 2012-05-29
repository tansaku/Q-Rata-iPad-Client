//
//  QRataTableViewController.h
//  Qrata
//
//  Created by Samuel Joseph on 3/27/12.
//  Copyright (c) 2012 NeuroGrid Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotatableViewController.h"

@class QRataSearchViewController;

@protocol QRataSearchViewControllerDelegate
@optional
- (void)qRataSearchViewController:(QRataSearchViewController *)sender url:(id)url;
@end

@interface QRataSearchViewController : RotatableViewController  <UITableViewDataSource, UISearchBarDelegate, UISplitViewControllerDelegate>
@property (nonatomic, strong) NSDictionary *selectedRowData;
@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, strong) NSString *categoryID;
@property (nonatomic, strong) NSArray *qRataResults;// of qrata result dictionaries
@property (nonatomic, strong) NSArray *bingResults;// of qrata result dictionaries
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UISearchDisplayController *searchDisplayController;
@property (nonatomic, weak) id <QRataSearchViewControllerDelegate> delegate;
- (NSArray *)whichResults:(NSInteger)section;

@end
