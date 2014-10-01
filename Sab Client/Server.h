//
//  Server.h
//  Sab Client
//
//  Created by Jonas Anseeuw on 29/09/13.
//  Copyright (c) 2013 Jonas Anseeuw. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Job;

@interface Server : NSObject

@property NSString *name;
@property NSString *host;
@property NSString *port;
@property NSString *apiKey;

@property (nonatomic) NSUInteger paused;

@property (strong, nonatomic) NSArray *jobs;

-(id)initWithName:(NSString *)aName
		 WithHost:(NSString *)aHost
		 WithPort:(NSString *)aPort
	   WithApiKey:(NSString *)anApiKey;

-(void)loadJSON:(void(^)(NSError *error))block;
-(void)toggleStatus:(void(^)(NSUInteger paused, NSError *error))block;
-(void)deleteJob:(Job *)aJob
				:(void(^)(NSError *error))block;
-(void)moveJob:(Job *)aJob
			  :(NSUInteger)aDestinationIndex
			  :(void(^)(NSError *error))block;

@end
