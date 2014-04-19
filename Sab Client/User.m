//
//  User.m
//  Sab Client
//
//  Created by Jonas Anseeuw on 29/09/13.
//  Copyright (c) 2013 Jonas Anseeuw. All rights reserved.
//

#import "User.h"

@implementation User

+(NSString *)getPathToArchive {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [paths objectAtIndex:0];
    return [docsDir stringByAppendingPathComponent:@"user.model"];
}

-(void)addServer:(Server *)aServer{
	NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:self.servers];
	[tempArray addObject:aServer];
	self.servers = [[NSArray alloc] initWithArray:tempArray];
}

-(void)removeServer:(NSUInteger)anIndex{
	NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:self.servers];
	[tempArray removeObjectAtIndex:anIndex];
	self.servers = [[NSArray alloc] initWithArray:tempArray];
}

+(User *)getUser {
	User *user = [NSKeyedUnarchiver unarchiveObjectWithFile:[User getPathToArchive]];
	if(!user){
		user = [[User alloc] init];
	}
	return user;
}

+(void)saveUser:(User *)aUser {
	[NSKeyedArchiver archiveRootObject:aUser toFile:[User getPathToArchive]];
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.servers forKey:@"servers"];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self) {
        _servers = [aDecoder decodeObjectForKey:@"servers"];
    }
    return self;
}

@end
