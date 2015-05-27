//
//  TopNavigationController.m
//  ACCSports
//
//  Created by Mike_Gazdich_rMBP on 10/6/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import "TopNavigationController.h"

@interface TopNavigationController ()

@end

@implementation TopNavigationController

- (void)viewDidLoad {
    
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuView"];
        [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    }
    
    [super viewDidLoad];
    
}

// catch the view will appear when panning or revealing the menu
-(void)viewWillAppear:(BOOL)animated
{
    // Set shadow
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
