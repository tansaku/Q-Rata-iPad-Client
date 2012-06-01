//
//  ExpertViewController.h
//  Qrata
//
//  Created by Samuel Joseph on 6/1/12.
//  Copyright (c) 2012 NeuroGrid Ltd. All rights reserved.
//

#import "RotatableViewController.h"
#import "QRataResultViewController.h"

@interface ExpertViewController : RotatableViewController  <UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (strong, nonatomic) NSArray *experts;
@end
