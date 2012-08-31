//
//  RotatableViewController.m
//  Psychologist
//
//  Created by Samuel Joseph on 3/9/12.
//  Copyright (c) 2012 NeuroGrid Ltd. All rights reserved.
//

#import "RotatableViewController.h"
#import "SplitViewBarButtonItemPresenterProtocol.h"
#import "QRataSearchViewController.h"

@implementation RotatableViewController

@synthesize popoverController;
@synthesize barButton;
@synthesize datasource = _datasource;

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.splitViewController.delegate = self;
    self.datasource = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *titleView = [[UIImageView alloc] initWithImage: [self scale:[UIImage imageNamed:@"type_logo.png"] toSize:CGSizeMake(96, 32)]];
    
    UITapGestureRecognizer *oneFingerOneTap = 
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerOneTap)];
    
    // Set required taps and number of touches
    [oneFingerOneTap setNumberOfTapsRequired:1];
    [oneFingerOneTap setNumberOfTouchesRequired:1];
    
    [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    [titleView setUserInteractionEnabled:YES];
    [titleView addGestureRecognizer:oneFingerOneTap];
    
    self.navigationItem.titleView = titleView;
}

// this is not related to rotating - but pulled up for convenience
- (UIImage *)scale:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
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
    self.barButton = barButtonItem;
    // tell the detail view to put this button up
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc 
     willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // tell the detail view to take the button away
    self.popoverController = nil;
    self.barButton = nil;
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)oneFingerOneTap
{
    NSLog(@"Action: One finger, one tap: %f", self.view.frame.size.width);
    // can we reset detail view to top category level?
    //[self performSegueWithIdentifier:@"Home" sender:self];
    [self.navigationController popToRootViewControllerAnimated: YES];
    
}

@end
