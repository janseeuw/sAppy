//
//  JobTableViewCell.h
//  Sab Client
//
//  Created by Jonas Anseeuw on 11/10/13.
//  Copyright (c) 2013 Jonas Anseeuw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Job;

@interface JobTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *toggleStateButton;
@property (weak, nonatomic) IBOutlet UILabel *filenameLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *percentageProgressView;
@property (weak, nonatomic) IBOutlet UILabel *mbLabel;
@end