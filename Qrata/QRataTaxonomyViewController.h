//
//  QRataTableViewController.h
//  Qrata
//
//  Created by Samuel Joseph on 3/27/12.
//  Copyright (c) 2012 NeuroGrid Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotatableViewController.h"
#import "InfoViewController.h"

@class QRataTaxonomyViewController;

@interface QRataTaxonomyViewController : RotatableViewController  <UITableViewDataSource, UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *infoButton;
@property (nonatomic, strong) NSArray *qRataCategories;
@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, strong) NSString *categoryID;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UISearchDisplayController *searchDisplayController;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;


@end
