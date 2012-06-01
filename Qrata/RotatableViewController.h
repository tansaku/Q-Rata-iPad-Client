//
//  RotatableViewController.h
//  Psychologist
//
//  Created by Samuel Joseph on 3/9/12.
//  Copyright (c) 2012 NeuroGrid Ltd. All rights reserved.
//


@protocol PopoverDatasource
@required
- (UIPopoverController *)popoverController;
- (UIBarButtonItem *)barButton;
@end

@interface RotatableViewController : UIViewController <UISplitViewControllerDelegate, PopoverDatasource>

@property (weak, nonatomic) UIPopoverController* popoverController;
@property (weak, nonatomic) UIBarButtonItem* barButton;
@property (nonatomic, weak) id <PopoverDatasource> datasource;

- (UIImage *)scale:(UIImage *)image toSize:(CGSize)size;


@end
