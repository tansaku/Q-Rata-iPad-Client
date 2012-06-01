//
//  UIRotatableNavigationController.m
//  Qrata
//
//  Created by Samuel Joseph on 5/31/12.
//  Copyright (c) 2012 NeuroGrid Ltd. All rights reserved.
//

#import "UIRotatableNavigationController.h"
#import "MetaDataTableViewController.h"

@implementation UIRotatableNavigationController

@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize button;

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if(_splitViewBarButtonItem != splitViewBarButtonItem){
        MetaDataTableViewController* mdtvc = [self.viewControllers objectAtIndex:0];
        mdtvc.navigationItem.leftBarButtonItem = splitViewBarButtonItem;
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    if(self.button)
    {
        [self setSplitViewBarButtonItem:self.button];
    }
}

@end
