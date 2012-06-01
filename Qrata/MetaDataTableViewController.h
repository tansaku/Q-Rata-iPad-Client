//
//  MetaDataTableViewController.h
//  Qrata
//
//  Created by Samuel Joseph on 3/28/12.
//  Copyright (c) 2012 NeuroGrid Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRataFetcher.h"
#import "SplitViewBarButtonItemPresenterProtocol.h"

@interface MetaDataTableViewController : UIViewController <UITableViewDataSource,SplitViewBarButtonItemPresenterProtocol>

@property (nonatomic, strong) NSDictionary *result;
@property (nonatomic, strong) NSDictionary *criteria;
@property (nonatomic, strong) NSArray *ratings;
@property (strong, nonatomic) NSString *desiredTitle;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;

@property (nonatomic, weak) UIBarButtonItem *button;



@end
