//
//  ViewController.m
//  DAddressBook
//
//  Created by DHRUPA AMIN PATEL on 2015-08-31.
//  Copyright (c) 2015 dhr. All rights reserved.
//
#import "ViewController.h"
#import "DetailViewController.h"
#import "ContactManager.h"

@interface ViewController ()

@property (strong, nonatomic) NSArray * arrangedcontacs;

// A loading scrollview.
@property (strong, nonatomic) UIActivityIndicatorView *scrollview;


@end

@implementation ViewController


- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder: coder];
    if (self == nil) {
        return nil;
    }
    
    [self viewload_];
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // Show the loading spinner.
    self.scrollview.center = self.view.center;
    [self.scrollview startAnimating];
    [self.view addSubview:self.scrollview];
    
    
    // Set the navigation bar title.
    self.title = @"cnames";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    // Retrieve the select contact and pass it to the DetailViewController.h.
    
    NSDictionary *contact = self.arrangedcontacs[indexPath.section][indexPath.row];
    DetailViewController *contactDetailVC = (DetailViewController*)segue.destinationViewController;
    contactDetailVC.cntcs = contact;
    
    // Delselect the cell in table view.
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewload_ {
    _scrollview = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [self loadcnames];
}

- (NSArray*)sortcnames:(NSArray*)cnames {
    // Sort the contacs by first and last name.
    NSArray *arrangedcontacs = [cnames sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        // Compare two names by first name.
        NSComparisonResult result = [[obj1 valueForKeyPath:@"user.name.first"] caseInsensitiveCompare:[obj2 valueForKeyPath:@"user.name.first"]];
        
        // If it's the same first name, return the result by last name.
        if (result == NSOrderedSame) {
            result = [[obj1 valueForKeyPath:@"user.name.last"] caseInsensitiveCompare:[obj2 valueForKeyPath:@"user.name.last"]];
        }
        return result;
    }];
    
   
    NSMutableArray *sapretedcontacs = [NSMutableArray array];
    NSMutableArray *temp = [NSMutableArray array];
    [sapretedcontacs addObject:temp];
    
    
    unichar firstLetterReference = [((NSString*)[arrangedcontacs[0] valueForKeyPath:@"user.name.first"]) characterAtIndex:0];
    unichar firstLetter;
    NSDictionary *cntcs;
    NSInteger cnamesCount = [arrangedcontacs count];
    
   
    for (int i=0; i<cnamesCount; i++) {
        cntcs = arrangedcontacs[i];
        firstLetter = [((NSString*)[cntcs valueForKeyPath:@"user.name.first"]) characterAtIndex:0];
        
            if (firstLetterReference != firstLetter) {
            firstLetterReference = firstLetter;
            temp = [NSMutableArray array];
            [sapretedcontacs addObject:temp];
        }
        
        [temp addObject:cntcs];
    }
    
    return sapretedcontacs;
}

/*---------------------------------------------------------------------------------------------------
 * Load the contacs from the ContactManager. If it retrieves successfully it inserts in to the table view. If it fails to retrieve shows a alert.
 ---------------------------------------------------------------------------------------------------*/
- (void)loadcnames {
    [[ContactManager sharedInstance] retrieveDataWithHandler:^(NSArray *cnames, NSError *connectionError) {
        // Check an error
        if (!connectionError) { // Successfully retrieves the cnames.
            self.arrangedcontacs = [self sortcnames:cnames];
            
            // Update the UI .
            dispatch_async(dispatch_get_main_queue(), ^{
                // Hide the loading spinner.
                [self.scrollview stopAnimating];
                self.scrollview.hidden = true;
                
                // Insert the contacs to the table view .
                [self.tableView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.arrangedcontacs count])]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
            });
        } else {    // Failed to retrieve the contacs.
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Hide the loading spinner.
                [self.scrollview stopAnimating];
                self.scrollview.hidden = true;
                
               
                [[[UIAlertView alloc] initWithTitle:@"Error"
                                            message:[connectionError localizedDescription]
                                           delegate:self
                                  cancelButtonTitle:@"Close"
                                  otherButtonTitles:@"Try Again", nil] show];
            });
        }
    }];
}



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.arrangedcontacs count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.arrangedcontacs[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contact" forIndexPath:indexPath];
    
    NSDictionary *cntcs = self.arrangedcontacs[indexPath.section][indexPath.row];
    
    // Set the cell name text.
    cell.textLabel.text = [[NSString stringWithFormat:@"%@ %@",
                            [cntcs valueForKeyPath:@"user.name.first"],
                            [cntcs valueForKeyPath:@"user.name.last"]]
                           capitalizedString];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // Return the first alphabet letter from the first name as the section title.
    return [[[self.arrangedcontacs[section][0] valueForKeyPath:@"user.name.first"] substringToIndex:1] uppercaseString];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *titles = [NSMutableArray array];
    
    // Loop through the arrangedcontacs first dimension to get the first name first alphabet for
    // index on the right hand side of the table view.
    for (NSArray *array in self.arrangedcontacs) {
        [titles addObject:[[array[0] valueForKeyPath:@"user.name.first"] substringToIndex:1]];
    }
    
    return titles;
}

- (NSInteger)tableView:(UITableView *)tableView
sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index {
    return index;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // If the user taps the try again button, load the cnames again.
    if (buttonIndex == 1) {
        self.scrollview.hidden = false;
        [self.scrollview startAnimating];
        
        [self loadcnames];
    }
}



@end
