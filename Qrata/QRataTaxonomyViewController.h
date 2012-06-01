//
//  QRataTableViewController.h
//  Qrata
//
//  Created by Samuel Joseph on 3/27/12.
//  Copyright (c) 2012 NeuroGrid Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotatableViewController.h"

@class QRataTaxonomyViewController;

@protocol QRataTaxonomyViewControllerDelegate
@optional
- (void)qRataTaxonomyViewController:(QRataTaxonomyViewController *)sender url:(id)url;
@end

@interface QRataTaxonomyViewController : RotatableViewController  <UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic, strong) NSArray *qRataCategories;
@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, strong) NSString *categoryID;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UISearchDisplayController *searchDisplayController;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (nonatomic, weak) id <QRataTaxonomyViewControllerDelegate> delegate;


- (UIImage *)scale:(UIImage *)image toSize:(CGSize)size;


@end
