//
//  EvaluationRequestViewController.h
//  Qrata
//
//  Created by Samuel Joseph on 5/29/12.
//  Copyright (c) 2012 NeuroGrid Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonItemPresenterProtocol.h"

@interface EvaluationRequestViewController : UIViewController <SplitViewBarButtonItemPresenterProtocol>

@property (nonatomic, weak) UIBarButtonItem *button;
@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;

@end
