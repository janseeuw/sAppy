//
//  Server.m
//  Sab Client
//
//  Created by Jonas Anseeuw on 29/09/13.
//  Copyright (c) 2013 Jonas Anseeuw. All rights reserved.
//

#import "Server.h"
#import "Job.h"
#import "AFHTTPRequestOperation.h"

@implementation Server

-(id)initWithName:(NSString *)aName
		 WithHost:(NSString *)aHost
		 WithPort:(NSString *)aPort
	   WithApiKey:(NSString *)anApiKey;
{
	self = [super init];
	if(self){
		_name = aName;
		_host = aHost;
		_port = aPort;
		_apiKey = anApiKey;
	}
	return self;
}

#define QUEUE "queue"
#define SLOTS "slots"
#define FILENAME "filename"
#define NZO_ID "nzo_id"
#define PAUSED "paused"
#define MB "mb"
#define MBLEFT "mbleft"
#define PERCENTAGE "percentage"
#define STATUS "status"

/*
	Laad alle gegevens in van de server en zijn queueu
 */
-(void)loadJSON:(void (^)(NSError *error))block {
	NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@:%@/api?mode=queue&start=START&limit=LIMIT&output=json&apikey=%@", self.host, self.port, self.apiKey]];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	operation.responseSerializer = [AFJSONResponseSerializer serializer];
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		// Process data
		NSLog(@"%@", responseObject);
		// Jobs
		NSMutableArray *tmp = [[NSMutableArray alloc] init];
		for(NSDictionary *jobEntry in responseObject[@QUEUE][@SLOTS]){
			Job *job = [[Job alloc] init];
			job.server = self;
			job.filename = jobEntry[@FILENAME];
			job.nzo_id = jobEntry[@NZO_ID];
			job.mb = [jobEntry[@MB] integerValue];
			job.mbleft = [jobEntry[@MBLEFT] integerValue];
			job.percentage = [jobEntry[@PERCENTAGE] floatValue];
			job.isPaused = [jobEntry[@STATUS] isEqualToString:@"Paused"];
			[tmp addObject:job];
		}
		self.jobs = (NSArray *)tmp;
		
		// Paused
		self.paused = [responseObject[@QUEUE][@PAUSED] intValue];
		
		if(block){
			block(nil);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if(block){
			block(error);
		}
	}];
	[operation start];
}

/*
	paused: 0 als niet gepauzeerd is, 1 als het gepauzeerd is
	error: nil als er geen fout opgetreden is
 */
-(void)toggleStatus:(void (^)(NSUInteger paused, NSError *error))block {
	if(self.paused == 0){
		// pauzeer
		NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@:%@/api?mode=pause&output=json&apikey=%@", self.host, self.port, self.apiKey]];
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
		AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
		operation.responseSerializer = [AFJSONResponseSerializer serializer];
		[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
			self.paused = 1;
			if(block){
				block(1, nil);
			}
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			if(block){
				block(0, error);
			}
		}];
		[operation start];
	}else{
		// start
		NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@:%@/api?mode=resume&output=json&apikey=%@", self.host, self.port, self.apiKey]];
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
		AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
		operation.responseSerializer = [AFJSONResponseSerializer serializer];
		[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
			self.paused = 0;
			if(block){
				block(0, nil);
			}
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			if(block){
				block(1, error);
			}
		}];
		[operation start];
	}
}

/*
	aJob: job object dat verwijdert moet worden
	error: nil indien geen fout opgetreden is
 */
-(void)deleteJob:(Job *)aJob :(void (^)(NSError *error))block{
	NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@:%@/api?mode=queue&name=delete&value=%@&output=json&apikey=%@", self.host, self.port, aJob.nzo_id,self.apiKey]];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	operation.responseSerializer = [AFJSONResponseSerializer serializer];
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:self.jobs];
		[tempArray removeObject:aJob];
		self.jobs = [[NSArray alloc] initWithArray:tempArray];
		if(block){
			block(nil);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if(block){
			block(error);
		}
	}];
	[operation start];
}

-(void)moveJob:(Job *)aJob :(NSUInteger)aDestinationIndex :(void (^)(NSError *))block{
	NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@:%@/api?mode=switch&value=%@&value2=%lu&output=json&apikey=%@", self.host, self.port, aJob.nzo_id, (unsigned long)aDestinationIndex , self.apiKey]];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	operation.responseSerializer = [AFJSONResponseSerializer serializer];
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:self.jobs];
		[tempArray removeObject:aJob];
		[tempArray insertObject:aJob atIndex:aDestinationIndex];
		self.jobs = [[NSArray alloc] initWithArray:tempArray];
		if(block){
			block(nil);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if(block){
			block(error);
		}
	}];
	[operation start];
}

- (void)encodeWithCoder:(NSCoder *)anEncoder {
	[anEncoder encodeObject:self.name forKey:@"name"];
	[anEncoder encodeObject:self.host forKey:@"host"];
	[anEncoder encodeObject:self.port forKey:@"port"];
	[anEncoder encodeObject:self.apiKey forKey:@"apiKey"];
}

- (Server *)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	if(self){
		self.name = [aDecoder decodeObjectForKey:@"name"];
		self.host = [aDecoder decodeObjectForKey:@"host"];
		self.port = [aDecoder decodeObjectForKey:@"port"];
		self.apiKey = [aDecoder decodeObjectForKey:@"apiKey"];
	}
	return self;
}

@end
