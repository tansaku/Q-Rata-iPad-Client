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

@interface MetaDataTableViewController : UITableViewController <SplitViewBarButtonItemPresenterProtocol>

@property (nonatomic, strong) NSDictionary *result;
@property (nonatomic, strong) NSArray *ratings;

@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;
@property (nonatomic, weak) UIBarButtonItem *button;


@end
