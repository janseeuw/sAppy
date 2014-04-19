//
//  User.h
//  Sab Client
//
//  Created by Jonas Anseeuw on 29/09/13.
//  Copyright (c) 2013 Jonas Anseeuw. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Server;

@interface User : NSObject
@property (strong, nonatomic) NSArray *servers;

+(NSString *)getPathToArchive;
+(User *)getUser;
+(void)saveUser:(User *)aUser;

-(void)addServer:(Server *)aServer;
-(void)removeServer:(NSUInteger)anIndex;

@end
