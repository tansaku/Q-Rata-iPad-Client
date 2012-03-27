//
//  QRataResultViewController.h
//  Qrata
//
//  Created by Samuel Joseph on 3/27/12.
//  Copyright (c) 2012 NeuroGrid Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotatableViewController.h"
#import "QRataSearchViewController.h"

@interface QRataResultViewController : RotatableViewController <QRataSearchViewControllerDelegate, UIWebViewDelegate>
@property (nonatomic, weak) IBOutlet UIWebView *webView;
- (void)loadUrl:(NSString *)urlString;
@end
