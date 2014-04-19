//
//  JobsTableViewController.h
//  Sab Client
//
//  Created by Jonas Anseeuw on 11/10/13.
//  Copyright (c) 2013 Jonas Anseeuw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Server.h"

@interface JobsTableViewController : UITableViewController
@property (strong, nonatomic) Server* server;
@end
