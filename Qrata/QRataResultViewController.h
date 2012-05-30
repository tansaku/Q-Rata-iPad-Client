//
//  QRataResultViewController.h
//  Qrata
//
//  Created by Samuel Joseph on 3/27/12.
//  Copyright (c) 2012 NeuroGrid Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRataSearchViewController.h"
#import "SplitViewBarButtonItemPresenterProtocol.h"

@interface QRataResultViewController : UIViewController <QRataSearchViewControllerDelegate, UIWebViewDelegate, SplitViewBarButtonItemPresenterProtocol>
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSString* url;
- (void)loadUrl:(NSString *)urlString;

@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;
@property (nonatomic, weak) UIBarButtonItem *button;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@end
