//
//  ServerTableViewController.h
//  Sab Client
//
//  Created by Jonas Anseeuw on 6/10/13.
//  Copyright (c) 2013 Jonas Anseeuw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServerTableViewController : UITableViewController <UITextFieldDelegate>
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *host;
@property(strong, nonatomic) NSString *port;
@property(strong, nonatomic) NSString *apiKey;
@end
