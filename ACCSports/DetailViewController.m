//
//  DetailViewController.m
//  ACCSports
//
//  Created by Mike_Gazdich_rMBP on 10/6/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import "DetailViewController.h"

/*
 If you specify a static variable within a method in the .m file, it can be accessed only in that method and
 it will retain its value throughout all method invocations.
 If you specify a static variable after #import and before @implementation in the .m file, it will be a class variable
 accessible by any method in your class and it will retain its value throughout the entire execution.
 */
static BOOL detailViewIsShownFirstTime = TRUE;     // Class bolean variable with initial value of TRUE.

@interface DetailViewController ()

@end

@implementation DetailViewController


-(void)viewDidLoad
{
#ifdef DEBUG
    NSLog(@"Website URL received in the Website View Controller = %@", self.websiteURL);
#endif
    
    self.title = @"ACC Sports";
    
    // Create the Menu button on the left side of the Navigation Bar
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(revealMenu:)];
    
    // Create the Home button on the right side of the Navigation Bar
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(homeButtonTapped:)];
    
    
    if (detailViewIsShownFirstTime) {
        
        // Obtain the file path to the homePage.html file
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"homePage" ofType:@"html"];
        
        // Display the homePage.html file
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
        
        detailViewIsShownFirstTime = NO;
        
    } else {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.websiteURL]]];
    }
    
    [self.view addSubview:self.webView];
    
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuView"];
        [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// Menu button action
-(void)revealMenu:(id)sender {
    
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (void)homeButtonTapped:(id)sender {
    
    // Obtain the file path to the homePage.html file
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"homePage" ofType:@"html"];
    
    // Display the homePage.html file
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
}


#pragma mark - UIWebView Delegate Methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
    // Starting to load the web page. Show the animated activity indicator in the status bar
    // to indicate to the user that the UIWebVIew object is busy loading the web page.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // Finished loading the web page. Hide the activity indicator in the status bar.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    // Ignore this error if the page is instantly redirected via javascript or in another way
    if([error code] == NSURLErrorCancelled) return;
    
    // An error occurred during the web page load. Hide the activity indicator in the status bar.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // Create the error message in HTML as a character string object pointed to by errorString
    NSString *errorString = [NSString stringWithFormat:
                             @"<html><font size=+2 color='red'><p>An error occurred: %@<br />Possible causes for this error:<br />- No network connection<br />- Wrong URL entered<br />- Server computer is down</p></font></html>",
                             error.localizedDescription];
    
    // Display the error message within the UIWebView object
    [self.webView loadHTMLString:errorString baseURL:nil];
}

@end
