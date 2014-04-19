//
//  ServerTableViewController.m
//  Sab Client
//
//  Created by Jonas Anseeuw on 6/10/13.
//  Copyright (c) 2013 Jonas Anseeuw. All rights reserved.
//

#import "ServerTableViewController.h"

@interface ServerTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *hostTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
@property (weak, nonatomic) IBOutlet UITextField *apiKeyTextField;
@end

@implementation ServerTableViewController

-(void)viewDidLoad
{
	[super viewDidLoad];
	self.hostTextField.delegate = self;
	self.portTextField.delegate = self;
	self.apiKeyTextField.delegate = self;
	self.nameTextField.delegate = self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return YES;
}

-(NSString *)name{
	return [self.nameTextField text];
}

-(NSString *)host{
	return [self.hostTextField text];
}

-(NSString *)port{
	return [self.portTextField text];
}

-(NSString *)apiKey{
	return [self.apiKeyTextField text];
}

@end
