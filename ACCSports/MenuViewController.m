//
//  MenuViewController.m
//  ACCSports
//
//  Created by Mike_Gazdich_rMBP on 10/6/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import "MenuViewController.h"


@interface MenuViewController ()

/*
 When a table view row is expanded, new rows are inserted after it into the table view.
 When a table view row is shrunk, the rows expanded under it are deleted.
 
 These insertions and deletions will change to table view content. We define
 tableViewContent as a changeable array to hold the current rows of the table view.
 */
@property (strong, nonatomic) NSMutableArray *tableViewContent;

@property (strong, nonatomic) NSString *urlOfWebsite;

@property (nonatomic, strong) NSIndexPath *selectedIndex;
@property (nonatomic, strong) NSIndexPath *selectedIndexPrevious;

@end


static BOOL sportNameSelected = NO;
static int selectedRowNumber;


@implementation MenuViewController

- (void)viewDidLoad {
    
    // set the sliding view parameters
    [self.slidingViewController setAnchorRightRevealAmount:255.0f];
    
    //set the menuView size = left layout width instead of full screen size
    self.slidingViewController.underLeftWidthLayout = ECFixedRevealWidth;
    
    //---------------------------------------------------------------------------------------------------
    
    // filePath is declared as a local variable of character string type
    NSString *filePath;   // File path to the plist file in the application's main bundle (project folder)
    
    //---------------------------------------------------------------------------------------------------
    // Obtain the file path to the accSports.plist file
    filePath = [[NSBundle mainBundle] pathForResource:@"accSports" ofType:@"plist"];
    
    // Instantiate a static dictionary object and initialize it with the content of the accSports.plist file
    self.dict1_UniversityName_Dict2 = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    
    // Obtain an array of university names sorted in alphabetical order
    self.universityNames  = [[self.dict1_UniversityName_Dict2 allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    //---------------------------------------------------------------------------------------------------
    
    // Obtain the file path to the accUniversityLogos.plist file
    filePath = [[NSBundle mainBundle] pathForResource:@"accUniversityLogos" ofType:@"plist"];
    
    // Instantiate a static dictionary object and initialize it with the content of the accUniversityLogos.plist file
    self.dict_UniversityName_UniversityLogoFileName = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    
    //---------------------------------------------------------------------------------------------------
    
    // Obtain the file path to the sportNames.plist file
    filePath = [[NSBundle mainBundle] pathForResource:@"sportNames" ofType:@"plist"];
    
    // Instantiate a static array object and initialize it with the content of the sportNames.plist file
    self.sportNames = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    //---------------------------------------------------------------------------------------------------
    
    // Instantiate a dynamic (changable) array to hold the current rows of the table view
    self.tableViewContent = [[NSMutableArray alloc] init];
    
    // Set the current rows to be the list of the university names
    [self.tableViewContent addObjectsFromArray:self.universityNames];
    
    [super viewDidLoad];   // Inform super
}


// Prepare the view before it appears to the user.
-(void)viewWillAppear:(BOOL)animated
{
#ifdef DEBUG
    NSLog(@"viewWillAppear method entered! sportNameSelected = %@", (sportNameSelected ? @"YES" : @"NO"));
#endif
    
    if (sportNameSelected) {
        
        UITableViewCell *peviousCell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:self.selectedIndexPrevious];
        peviousCell.textLabel.textColor = [UIColor blackColor]; // Change previously selected sport name row's color to black
        
        UITableViewCell *currentCell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:self.selectedIndex];
        currentCell.textLabel.textColor = [UIColor blueColor]; // Change currently selected sport name row's color to blue
        
        // Set the selected row to the saved selected index and position it to appear in the middle of the table view
        [self.tableView selectRowAtIndexPath:self.selectedIndex animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View Data Source Methods

// Asks the data source to return the number of sections in the table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

// Asks the data source to return the number of rows in a section, the number of which is given
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableViewContent count];
}

// Asks the data source to return a cell to insert in a particular table view location
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger rowNumber = [indexPath row];          // Identify the row number
    
    // Obtain the object reference of the UITableViewCell object instantiated with respect to
    // the identifier TableViewCellReuseID
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCellReuseID"];
    
    NSString *rowName = [self.tableViewContent objectAtIndex:rowNumber];
    cell.textLabel.text = rowName;
    
    cell.indentationWidth = 10.0;         // 10.0 points is the default value
    
    if ([self.universityNames containsObject:rowName]) {        // Level=0
        
        cell.indentationLevel = 0;
        
        NSString *universityLogoFileName = [self.dict_UniversityName_UniversityLogoFileName objectForKey:rowName];
        cell.imageView.image = [UIImage imageNamed:universityLogoFileName];
        
    } else if ([rowName isEqualToString:@"Men's Sports"]) {     // Level=1
        
        cell.indentationLevel = 1;
        cell.imageView.image = [UIImage imageNamed:@"MenSportIcon"];
        
    } else if ([rowName isEqualToString:@"Women's Sports"]) {   // Level=1
        
        cell.indentationLevel = 1;
        cell.imageView.image = [UIImage imageNamed:@"WomenSportIcon"];
        
    } else {   // Level=2
        
        cell.indentationLevel = 2;
        
        // Row name = image name for Level 2
        cell.imageView.image = [UIImage imageNamed:rowName];
    }
    
    return cell;
}


// Prepare the table view cell before it is displayed to the user
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.textLabel.numberOfLines = 2;       // Set the number of lines to be displayed in each table row (cell) to 2
    cell.textLabel.lineBreakMode = 0;       // Set the line break mode to 0 so that the text wraps around on the next line
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];   // Set the row name text to use system font of size 14 pts
    
    int indentationLevel = (int)cell.indentationLevel;
    
    if (sportNameSelected && selectedRowNumber == indexPath.row) {
        cell.textLabel.textColor = [UIColor blueColor];     // Set the row name color to blue to indicate its selection
    } else {
        cell.textLabel.textColor = [UIColor blackColor];    // Set the row name color to black otherwise
    }
    
    switch (indentationLevel) {    // For color selection, consult with http://www.w3schools.com/html/html_colornames.asp
        case 0:
            // Set level 1 row background color to Lavendar (#E6E6FA)
            cell.backgroundColor = [UIColor colorWithRed:230.0/255.0f green:230.0f/255.0f blue:250.0f/255.0f alpha:1.0f];
            break;
            
        case 1:
            // Set level 2 row background color to Ivory (#FFFFF0)
            cell.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
            break;
            
        case 2:
            // Set level 3 row background color to PeachPuff (#FFDAB9)
            cell.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:218.0f/255.0f blue:185.0f/255.0f alpha:1.0f];
            break;
            
        default:
            break;
    }
    
    NSString *rowName = cell.textLabel.text;
    
    if ([self.sportNames containsObject:rowName]) {  // Show the right arrow icon as disclosure indicator
        
        UIImage *rightArrow = [UIImage imageNamed:@"RightArrow"];
        // Set the cell's accessory view to show the RightArrow image
        cell.accessoryView = [[UIImageView alloc] initWithImage:rightArrow];
        
    } else {  // Show the down arrow icon to indicate that the row has child rows
        
        UIImage *downArrow = [UIImage imageNamed:@"DownArrow"];
        // Set the cell's accessory view to show the DownArrow image
        cell.accessoryView = [[UIImageView alloc] initWithImage:downArrow];
    }
    
    // Set the cell's selected background view
    UIView *cellBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView = cellBackgroundView;
}


#pragma mark - Table View Delegate Methods

// Tells the delegate (=self) that the row specified under indexPath is now selected.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger rowNumber = [indexPath row];
    NSString *nameOfSelectedRow = [self.tableViewContent objectAtIndex:rowNumber];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    int indentationLevelSelected = (int)cell.indentationLevel;
    
#ifdef DEBUG
    NSLog(@"indentationLevelSelected = %d", indentationLevelSelected);
#endif
    
    switch (indentationLevelSelected) {
            
        case 0:   // University name is selected
        {
            sportNameSelected = NO;
            
            if (rowNumber == [self.tableViewContent count] - 1 || [self.universityNames containsObject:[self.tableViewContent objectAtIndex:rowNumber+1]]) {
                // Expand the row
                
                self.dict2_SportCategory_Dict3 = [self.dict1_UniversityName_Dict2 objectForKey:nameOfSelectedRow];
                
                // Obtain an array of sport categories sorted in alphabetical order
                NSArray *sportCategories = [[self.dict2_SportCategory_Dict3 allKeys] sortedArrayUsingSelector:@selector(compare:)];
                
                int count = (int)[sportCategories count];
                for (int i=0; i < count; i++) {
                    
                    [self.tableViewContent insertObject:[sportCategories objectAtIndex:i] atIndex:++rowNumber];
                }
                
                [tableView reloadData];
                
            } else {    // Shrink the row
                // As long as the next row is not a university name, delete that row from the table view
                while (![self.universityNames containsObject:[self.tableViewContent objectAtIndex:rowNumber+1]]) {
                    
                    [self.tableViewContent removeObjectAtIndex:rowNumber+1];
                    if (rowNumber+1 > [self.tableViewContent count] - 1) break;
                }
                
                [tableView reloadData];
            }
        }
            break;
            
        case 1:   // Sport category name is selected
        {
#ifdef DEBUG
            NSLog(@"indentationLevelSelected = %d, Row Number = %lu, nameOfSelectedRow = %@", indentationLevelSelected, (unsigned long)rowNumber, nameOfSelectedRow);
#endif
            
            sportNameSelected = NO;
            
            // Special case: Selected sport category name is the last row of the table view content
            if (rowNumber == [self.tableViewContent count]-1) {   // Expand the selected sport category row
                
                for (int j = (int)rowNumber-1; j >= 0; j--) {
                    
                    NSString *previousRowName = [self.tableViewContent objectAtIndex:j];
                    
#ifdef DEBUG
                    NSLog(@"Index j = Row Number = %d, previousRowName = %@", j, previousRowName);
#endif
                    
                    if ([self.universityNames containsObject:previousRowName]) {
                        
                        NSString *universityNameOfSelectedRow = previousRowName;
                        
                        self.dict2_SportCategory_Dict3 = [self.dict1_UniversityName_Dict2 objectForKey:universityNameOfSelectedRow];
                        
                        self.dict3_SportName_SportURL = [self.dict2_SportCategory_Dict3 objectForKey:nameOfSelectedRow];
                        
                        // Obtain an array of sport names sorted in alphabetical order
                        NSArray *sportNamesOfSelectedCategory = [[self.dict3_SportName_SportURL allKeys] sortedArrayUsingSelector:@selector(compare:)];
                        
                        int count = (int)[sportNamesOfSelectedCategory count];
                        for (int k=0; k < count; k++) {
                            
                            [self.tableViewContent insertObject:[sportNamesOfSelectedCategory objectAtIndex:k] atIndex:++rowNumber];
                        }
                        
                        [tableView reloadData];
                        
                        break;
                    }
                }
                
            } else if ([self.sportNames containsObject:[self.tableViewContent objectAtIndex:rowNumber+1]]) {  // Shrink the selected sport category row
                
                if ([nameOfSelectedRow isEqualToString:@"Men's Sports"]) {
                    
                    // As long as the next row is not "Women's Sports", delete that row from the table view
                    while (![[self.tableViewContent objectAtIndex:rowNumber+1] isEqualToString:@"Women's Sports"]) {
                        
#ifdef DEBUG
                        NSLog(@"objectAtIndex:rowNumber+1 = %@", [self.tableViewContent objectAtIndex:rowNumber+1]);
#endif
                        
                        [self.tableViewContent removeObjectAtIndex:rowNumber+1];
                        if (rowNumber+1 > [self.tableViewContent count] - 1) break;
                    }
                    
                } else {
                    
                    // As long as the next row is not a university name, delete that row from the table view
                    while (![self.universityNames containsObject:[self.tableViewContent objectAtIndex:rowNumber+1]]) {
                        
#ifdef DEBUG
                        NSLog(@"objectAtIndex:rowNumber+1 = %@", [self.tableViewContent objectAtIndex:rowNumber+1]);
#endif
                        
                        [self.tableViewContent removeObjectAtIndex:rowNumber+1];
                        if (rowNumber+1 > [self.tableViewContent count] - 1) break;
                    }
                }
                
                [tableView reloadData];
                
            } else {   // Expand the selected sport category row
                
                for (int j = (int)rowNumber-1; j >= 0; j--) {
                    
                    NSString *previousRowName = [self.tableViewContent objectAtIndex:j];
                    
#ifdef DEBUG
                    NSLog(@"Index j = Row Number = %d, previousRowName = %@", j, previousRowName);
#endif
                    
                    if ([self.universityNames containsObject:previousRowName]) {
                        
                        NSString *universityNameOfSelectedRow = previousRowName;
                        
                        self.dict2_SportCategory_Dict3 = [self.dict1_UniversityName_Dict2 objectForKey:universityNameOfSelectedRow];
                        
                        self.dict3_SportName_SportURL = [self.dict2_SportCategory_Dict3 objectForKey:nameOfSelectedRow];
                        
                        // Obtain an array of sport names sorted in alphabetical order
                        NSArray *sportNamesOfSelectedCategory  = [[self.dict3_SportName_SportURL allKeys] sortedArrayUsingSelector:@selector(compare:)];
                        
                        int count = (int)[sportNamesOfSelectedCategory count];
                        for (int k=0; k < count; k++) {
                            
                            [self.tableViewContent insertObject:[sportNamesOfSelectedCategory objectAtIndex:k] atIndex:++rowNumber];
                        }
                        
                        [tableView reloadData];
                        
                        break;
                    }
                }
            }
        }
            break;
            
        case 2:   // Sport name is selected
        {
#ifdef DEBUG
            NSLog(@"indentationLevelSelected = %d, Number of Row Selected = %lu, nameOfSelectedRow = %@", indentationLevelSelected, (unsigned long)rowNumber, nameOfSelectedRow);
#endif
            
            sportNameSelected = YES;
            
            self.selectedIndexPrevious = self.selectedIndex;
            
            self.selectedIndex = indexPath;
            selectedRowNumber = (int)indexPath.row;
            
            BOOL sportCategoryNameOfSelectedRowIdentified = NO;
            
            NSString *sportCategoryNameOfSelectedRow;
            
            for (int n = (int)rowNumber-1; n >= 0; n--) {
                
                NSString *previousRowName = [self.tableViewContent objectAtIndex:n];
                
#ifdef DEBUG
                NSLog(@"Index n = Row Number = %d, previousRowName = %@", n, previousRowName);
#endif
                
                if ([previousRowName isEqualToString:@"Men's Sports"] || [previousRowName isEqualToString:@"Women's Sports"]) {
                    
                    if (!sportCategoryNameOfSelectedRowIdentified) {
                        sportCategoryNameOfSelectedRow = [[NSString alloc] initWithString:previousRowName];
                        sportCategoryNameOfSelectedRowIdentified = YES;
                    }
                    
                } else if ([self.universityNames containsObject:previousRowName]) {
                    
                    NSString *universityNameOfSelectedRow = previousRowName;
                    
                    self.dict2_SportCategory_Dict3 = [self.dict1_UniversityName_Dict2 objectForKey:universityNameOfSelectedRow];
                    
                    self.dict3_SportName_SportURL = [self.dict2_SportCategory_Dict3 objectForKey:sportCategoryNameOfSelectedRow];
                    
                    self.urlOfWebsite = [self.dict3_SportName_SportURL objectForKey:nameOfSelectedRow];
                    
#ifdef DEBUG
                    NSLog(@"Website URL = %@", self.urlOfWebsite);
#endif
                    
                    // Show the Detail View
                    
                    DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailView"];
                    
                    detailViewController.title = nameOfSelectedRow;    // Set the title of the destination DetailViewController object
                    
                    detailViewController.websiteURL = self.urlOfWebsite;
                    
                    TopNavigationController *topNavigationController = (TopNavigationController *) self.slidingViewController.topViewController;
                    
                    [topNavigationController pushViewController:detailViewController animated:NO];
                    [self.slidingViewController resetTopView];
                    
                    break;
                }
            }
        }
            break;
            
        default:
#ifdef DEBUG
            NSLog(@"Unexpected default case!");
#endif
            break;
    }
}

@end
