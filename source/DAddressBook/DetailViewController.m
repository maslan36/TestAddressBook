//
//  DetailViewController.h.m
//  AddressBookD
//
//  Created by DHRUPA AMIN PATEL on 2015-08-31.
//  Copyright (c) 2015 dhr. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
/***********************
 * Initialize the UI element on the view.
 ***********************/
- (void)initView {
    NSDictionary *user = self.cntcs[@"user"];
    
    // Contact image
    NSURL *imageURL = [NSURL URLWithString:[user valueForKeyPath:@"picture.thumbnail"]];
    self.prflimg.image = [UIImage imageWithData: [NSData dataWithContentsOfURL:imageURL]];
    
    self.prflimg.hidden=true;
    
    [self.profile setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]] forState:UIControlStateNormal];
    
    // Full name
    self.fName.text = [[NSString stringWithFormat:@"%@ %@",
                                [user valueForKeyPath:@"name.first"],
                                [user valueForKeyPath:@"name.last"]]
                               capitalizedStringWithLocale:[NSLocale currentLocale]];
    
    // Phone
    self.contacNO.text = user[@"phone"];
    
    // Mobile
    self.mobileNo.text = user[@"cell"];
    
    // Email
    self.email_id.text = user[@"email"];
    
    // Address
    NSDictionary *addressDict = user[@"location"];
    self.AddStrt.text = [addressDict[@"street"] capitalizedStringWithLocale:[NSLocale currentLocale]];
    self.city.text = [addressDict[@"city"] capitalizedStringWithLocale:[NSLocale currentLocale]];
    self.state.text = [addressDict[@"state"] capitalizedStringWithLocale:[NSLocale currentLocale]];
    //self.ZipCode.text = addressDict[@"zip"] ;
    
    self.ZipCode.text = [NSString stringWithFormat:@"%@",addressDict[@"zip"] ];
}


- (IBAction)PrflView:(id)sender {
    
    UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:self.fName.text message:@"\n"
                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil ];
   
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(90,40, 100, 200)];
     image.contentMode = UIViewContentModeScaleToFill;

   // image.frame=CGRectMake(90, 40, 100, 200);
    NSDictionary *user = self.cntcs[@"user"];

    NSURL *imageURL = [NSURL URLWithString:[user valueForKeyPath:@"picture.thumbnail"]];
   // self.prflimg.image = [UIImage imageWithData: [NSData dataWithContentsOfURL:imageURL]];
    [image setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]]];
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        [Alert setValue:image forKey:@"accessoryView"];
    }else{
       
        [Alert addSubview:image];
    }
    
    //[Alert addSubview:image];
    [Alert show];

}

@end
