//
//  DetailViewController.h
//  ACCSports
//
//  Created by Mike_Gazdich_rMBP on 10/6/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"

@interface DetailViewController : UIViewController <UIWebViewDelegate>


@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) NSString *websiteURL;

- (void)revealMenu:(id)sender;

- (void)homeButtonTapped:(id)sender;

@end
