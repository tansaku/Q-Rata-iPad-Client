//
//  RotatableViewController.m
//  Psychologist
//
//  Created by Samuel Joseph on 3/9/12.
//  Copyright (c) 2012 NeuroGrid Ltd. All rights reserved.
//

#import "RotatableViewController.h"
#import "SplitViewBarButtonItemPresenterProtocol.h"

@implementation RotatableViewController

@synthesize popoverController;
@synthesize button;

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

- (id <SplitViewBarButtonItemPresenterProtocol>)splitViewBarButtonItemPresenter
{
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if(![detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenterProtocol)]){
        detailVC = nil;
    }
    return detailVC;
}

- (BOOL)splitViewController:(UISplitViewController *)svc 
   shouldHideViewController:(UIViewController *)vc 
              inOrientation:(UIInterfaceOrientation)orientation
{
    return [self splitViewBarButtonItemPresenter] ? UIInterfaceOrientationIsPortrait(orientation): NO;
}

- (void)splitViewController:(UISplitViewController *)svc 
     willHideViewController:(UIViewController *)aViewController 
          withBarButtonItem:(UIBarButtonItem *)barButtonItem 
       forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = self.title;
    self.popoverController = pc;
    self.button = barButtonItem;
    // tell the detail view to put this button up
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc 
     willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // tell the detail view to take the button away
    self.popoverController = nil;
    self.button = nil;
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)splitViewController:(UISplitViewController*)svc
          popoverController:(UIPopoverController*)pc
  willPresentViewController:(UIViewController *)aViewController{
    if ([pc isPopoverVisible]) {
        [pc dismissPopoverAnimated:YES];
    }
}
@end
