//
//  TopNavigationController.h
//  ACCSports
//
//  Created by Mike_Gazdich_rMBP on 10/6/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlidingViewController.h"
#import "MenuViewController.h"

@interface TopNavigationController : UINavigationController

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) UIButton *menu;

@end