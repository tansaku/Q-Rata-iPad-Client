//
//  UIRotatableNavigationController.h
//  Qrata
//
//  Created by Samuel Joseph on 5/31/12.
//  Copyright (c) 2012 NeuroGrid Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonItemPresenterProtocol.h"

@interface UIRotatableNavigationController : UINavigationController <SplitViewBarButtonItemPresenterProtocol>

@property (nonatomic, weak) UIBarButtonItem *button;

@end
