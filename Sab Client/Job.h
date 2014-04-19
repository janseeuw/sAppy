//
//  Job.h
//  Sab Client
//
//  Created by Jonas Anseeuw on 29/09/13.
//  Copyright (c) 2013 Jonas Anseeuw. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Server;

@interface Job : NSObject

@property (strong, nonatomic) Server *server;
@property (strong, nonatomic) NSString *filename;
@property (strong, nonatomic) NSString *nzo_id;
@property (nonatomic) NSUInteger mb;
@property (nonatomic) NSUInteger mbleft;
@property (nonatomic) CGFloat percentage;

@property (nonatomic) BOOL isPaused;

-(void)toggleJobStatus:(void(^)(NSError *error))block;

@end
