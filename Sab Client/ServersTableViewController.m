//
//  ServersTableViewController.m
//  Sab Client
//
//  Created by Jonas Anseeuw on 6/10/13.
//  Copyright (c) 2013 Jonas Anseeuw. All rights reserved.
//

#import "ServersTableViewController.h"
#import "ServerTableViewController.h"
#import "JobsTableViewController.h"
#import "User.h"

@interface ServersTableViewController ()
@property (strong, nonatomic) User* user;
@property (strong, nonatomic) NSArray* servers;
@end

@implementation ServersTableViewController

#define SERVERS "servers"

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Toont de edit knop
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
	
	// Haalt de gebruiker op
	self.user = [User getUser];
	[self.user addObserver:self
				forKeyPath:@SERVERS
				   options:NSKeyValueObservingOptionNew
				   context:nil];
	
	self.servers = self.user.servers;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.servers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(!cell){
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	}
	// Configure the cell
	cell.textLabel.text = [[self.servers objectAtIndex:indexPath.row] name];
	cell.detailTextLabel.text = [[self.servers objectAtIndex:indexPath.row] host];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(editingStyle == UITableViewCellEditingStyleDelete){
		[self.user removeServer:indexPath.row];
	}
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
	if ([keyPath isEqualToString:@SERVERS]) {
		[User saveUser:self.user]; // Later ergens anders zetten
		self.servers = self.user.servers;
		[self.tableView reloadData];
	}
}

/* Method to save the new server to the User */
-(IBAction)save:(UIStoryboardSegue *)segue
{
	ServerTableViewController *serverTVC = segue.sourceViewController;
	Server *newServer = [[Server alloc] initWithName:serverTVC.name WithHost:serverTVC.host WithPort:serverTVC.port WithApiKey:serverTVC.apiKey];
	[self.user addServer:newServer];
}

-(IBAction)cancel:(UIStoryboardSegue *)segue
{
	// Do nothing
}

#define SHOWSERVER "showServer"

/* Bij overgang naar de jobstableview moet de server meegegeven worden */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	if([segue.identifier isEqualToString:@SHOWSERVER]){
		JobsTableViewController *jobsTVC = (JobsTableViewController *)segue.destinationViewController;
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		jobsTVC.server = [self.servers objectAtIndex:indexPath.row];
		jobsTVC.title = [[self.servers objectAtIndex:indexPath.row] name];
	}
}


@end
