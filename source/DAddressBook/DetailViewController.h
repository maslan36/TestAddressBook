//
//  DetailViewController.h
//  AddressBookD
//
//  Created by DHRUPA AMIN PATEL on 2015-08-31.
//  Copyright (c) 2015 dhr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

// The contact detail to display.
@property (strong, nonatomic) NSDictionary *cntcs;

@property (weak, nonatomic) IBOutlet UIImageView *prflimg;
@property (weak, nonatomic) IBOutlet UILabel *fName;
@property (weak, nonatomic) IBOutlet UILabel *contacNO;
@property (weak, nonatomic) IBOutlet UILabel *mobileNo;
@property (weak, nonatomic) IBOutlet UILabel *email_id;
@property (weak, nonatomic) IBOutlet UILabel *AddStrt;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UILabel *ZipCode;
@property (strong, nonatomic) IBOutlet UIButton *profile;
- (IBAction)PrflView:(id)sender;

@end
