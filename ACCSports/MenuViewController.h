//
//  MenuViewController.h
//  ACCSports
//
//  Created by Mike_Gazdich_rMBP on 10/6/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlidingViewController.h"
#import "TopNavigationController.h"
#import "DetailViewController.h"

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

/*
 The accSports.plist XML file contains 3 dictionaries embedded into each other:
 
 Dictionary 1: Key = University Name    Value = object reference of Dictionary 2
 Dictionary 2: Key = Sport Category     Value = object reference of Dictionary 3
 Dictionary 3: Key = Sport Name         Value = sport's website URL
 */

@property (strong, nonatomic) NSDictionary *dict1_UniversityName_Dict2;
@property (strong, nonatomic) NSDictionary *dict2_SportCategory_Dict3;
@property (strong, nonatomic) NSDictionary *dict3_SportName_SportURL;

@property (strong, nonatomic) NSArray *universityNames;
@property (strong, nonatomic) NSArray *sportCategoryNames;
@property (strong, nonatomic) NSArray *sportNames;

/*
 The accUniversityLogos.plist XML file contains one dictionary:
 Dictionary: Key = University Name      Value = University Logo File Name
 */

@property (strong, nonatomic) NSDictionary *dict_UniversityName_UniversityLogoFileName;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
