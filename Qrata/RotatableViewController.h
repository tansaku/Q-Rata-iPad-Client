//
//  RotatableViewController.h
//  Psychologist
//
//  Created by Samuel Joseph on 3/9/12.
//  Copyright (c) 2012 NeuroGrid Ltd. All rights reserved.
//



@interface RotatableViewController : UIViewController <UISplitViewControllerDelegate>

@property (weak, nonatomic) UIPopoverController* popoverController;
@property (weak, nonatomic) UIBarButtonItem* button;

@end
