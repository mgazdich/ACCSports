//
//  ViewController.m
//  ACCSports
//
//  Created by Mike_Gazdich_rMBP on 10/6/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import "InitialViewController.h"

@interface InitialViewController ()

@end


@implementation InitialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIStoryboard *storyboard;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {    // The iOS device = iPhone or iPod Touch
        
        // Obtain the screen size of the iOS device so that we can determine which device it is
        CGSize screen = [[UIScreen mainScreen] bounds].size;
        
        if (screen.height == 480)
        {
            // iPhone 3GS, 4, and 4S and iPod Touch 3rd and 4th generation: 3.5 inch screen
            
            // Set the Storyboard to Main_iPhone
            storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        }
        
        if (screen.height == 568)
        {
            // iPhone 5, 5S, 5C and iPod Touch 5th generation: 4 inch retina screen
            
            // Set the Storyboard to Main_iPhone
            storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        }
        
    } else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        
    {   // The iOS device = iPad or iPad Mini
        
        // Set the Storyboard to Main_iPad
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    }
    
    if (storyboard)
    {
        // Instantiate and set the top view controller
        self.topViewController = [storyboard instantiateViewControllerWithIdentifier:@"TopView"];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


// Initially, the device orientation should be set to Portrait
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
