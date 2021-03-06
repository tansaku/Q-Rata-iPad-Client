//
//  QRataTableViewController.h
//  Qrata
//
//  Created by Samuel Joseph on 3/27/12.
//  Copyright (c) 2012 NeuroGrid Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotatableViewController.h"
#import "EvaluationRequestViewController.h"
#import "QRataTaxonomyViewController.h"

@interface QRataSearchViewController : RotatableViewController  <UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic, strong) NSDictionary *selectedRowData;
@property (nonatomic, strong) NSArray *selectedRowCriterionRatings;
@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, strong) NSString *categoryID;
@property (nonatomic, strong) NSArray *qRataResults;// of qrata result dictionaries
@property (nonatomic, strong) NSArray *bingResults;// of qrata result dictionaries
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UISearchDisplayController *searchDisplayController;

- (NSArray *)whichResults:(NSInteger)section;

@end
