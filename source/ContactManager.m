//
//  ContactManager.m
//  AddressBookD
//
//  Created by DHRUPA AMIN PATEL on 2015-08-31.
//  Copyright (c) 2015 dhr. All rights reserved.
//

#import "ContactManager.h"


static ContactManager *sharedInstance_ = nil;

static NSString * const ServerURL = @"http://api.randomuser.me/";
static NSString * const APIKey = @"ABCD-1234-EFGH-5678";
static NSInteger NoOfDatarcv = 50;
static NSInteger StatusCode = 200;
static NSString * const ErrorSrvr = @"Server";


@interface ContactManager ()
@end



#pragma mark -
//-----------------------------------------------
// A class to manage data retrieval and parsing.
//-----------------------------------------------


@implementation ContactManager

#pragma mark - Cllass Methods
+ (ContactManager*)sharedInstance {
    static dispatch_once_t queue;
    
    dispatch_once(&queue, ^{
        sharedInstance_ = [[self alloc] init];
    });
    
    return sharedInstance_;
}

#pragma mark - Constructors
- (id)init {
    // Stop the program if this class is being initialized again.
    NSAssert(!sharedInstance_, @"%@ is a singleton and it has been initialized. It is being init again which it should NOT be.", NSStringFromClass([self class]));
    
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    [self viewload_];
    return self;
}



/*--------------------------------------------------------------------------------
 * Download data and return an array of cnames in the completion handler block.
 *--------------------------------------------------------------------------------*/
- (void)retrieveDataWithHandler:(void (^)(NSArray *cnames, NSError *connectionError))handler {
    
   
    void (^requestHandler)(NSURLResponse*, NSData*, NSError*) = ^void(NSURLResponse *response, NSData *data, NSError *connectionError) {
        // Check to see if there's a connection error.
        if (connectionError) {
            handler(nil, connectionError);
        }
        else {
            // Check for the response status code.
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            if (httpResponse.statusCode == StatusCode) {
                NSError *aJSONError;
                
                // parse the JSON data to an object.
                id aJSONObj = [NSJSONSerialization JSONObjectWithData:data
                                                              options:0
                                                                error:&aJSONError];
                
                // Check for JSON parsing error.
                if (aJSONError) {
                    handler(nil, aJSONError);
                }
                else {
                    // Check for the object structure. It should be an NSDictionary at the root.
                    if ([aJSONObj isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *resultsDict = (NSDictionary*)aJSONObj;
                        NSArray *results = resultsDict[@"results"];
                        
                        // Check to see if the dictionary contain the "results" key.
                        if (results == nil) {
                            NSString *description = @"Server's not contant the key 'results'.";
                            if (resultsDict[@"error"]) {
                                description = resultsDict[@"error"];
                            }
                            
                            NSError *error = [NSError errorWithDomain:ErrorSrvr
                                                                 code:-1
                                                             userInfo:@{NSLocalizedDescriptionKey:description}];
                            handler(nil, error);
                        }
                        else {    // Got the results successfully.
                            handler(results, nil);
                        }
                    }
                    else {    // The object returned is not an NSDictionary.
                        NSString *description = @"response is not in a format.";
                        NSError *error = [NSError errorWithDomain:ErrorSrvr
                                                             code:-2
                                                         userInfo:@{NSLocalizedDescriptionKey:description}];
                        handler(nil, error);
                    }
                }
            }
            else {
                NSString *description = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSError *error = [NSError errorWithDomain:ErrorSrvr
                                                     code:httpResponse.statusCode
                                                 userInfo:@{NSLocalizedDescriptionKey:description}];
                handler(nil, error);
            }
        }
    };
    
    // Send the request to get the cnames.
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[self getURLWithNumberOfcnames:NoOfDatarcv]]
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:requestHandler];
}



- (void)viewload_ {
}

- (NSURL*)getURLWithNumberOfcnames:(NSInteger)numberOfcnames {
    NSString *requestURLString = [NSString stringWithFormat:@"%@?results=%ld&key=%@", ServerURL, (long)numberOfcnames, APIKey];
    return [NSURL URLWithString:requestURLString];
}

@end
