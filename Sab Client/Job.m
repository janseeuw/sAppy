//
//  Job.m
//  Sab Client
//
//  Created by Jonas Anseeuw on 29/09/13.
//  Copyright (c) 2013 Jonas Anseeuw. All rights reserved.
//

#import "Job.h"
#import "Server.h"
#import "AFHTTPRequestOperation.h"

@interface Job()

@end

@implementation Job


-(void)toggleJobStatus:(void (^)(NSError *))block{
	if(self.isPaused){
		// start
		NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@:%@/api?mode=queue&name=resume&value=%@&output=json&apikey=%@", self.server.host, self.server.port, self.nzo_id, self.server.apiKey]];
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
		AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
		operation.responseSerializer = [AFJSONResponseSerializer serializer];
		[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
			self.isPaused = NO;
			if(block){
				block(nil);
			}
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			if(block){
				block(error);
			}
		}];
		[operation start];
	}else{
		// pauzeer
		NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@:%@/api?mode=queue&name=pause&value=%@&output=json&apikey=%@", self.server.host, self.server.port, self.nzo_id, self.server.apiKey]];
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
		AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
		operation.responseSerializer = [AFJSONResponseSerializer serializer];
		[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
			self.isPaused = YES;
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
}

@end
