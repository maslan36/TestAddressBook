//
//  ContactManager.h
//  AddressBookD
//
//  Created by DHRUPA AMIN PATEL on 2015-08-31.
//  Copyright (c) 2015 dhr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactManager : NSObject
+ (ContactManager*)sharedInstance;

- (void)retrieveDataWithHandler:(void (^)(NSArray *cnames, NSError *connectionError))handler;

@end
