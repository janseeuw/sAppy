//
//  JobsTableViewController.m
//  Sab Client
//
//  Created by Jonas Anseeuw on 11/10/13.
//  Copyright (c) 2013 Jonas Anseeuw. All rights reserved.
//

#import "JobsTableViewController.h"
#import "JobTableViewCell.h"
#import "Job.h"

@interface JobsTableViewController ()
@property (strong, nonatomic) NSArray *jobs;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *statusButton;

@end

@implementation JobsTableViewController

- (void)reload{
	[self.statusButton setEnabled:NO];
	[self.server loadJSON:^(NSError *error) {
		if(!error){
			self.jobs = self.server.jobs;
			[self.tableView reloadData];
			[self ChangeBarButton:self.server.paused];
			[self.statusButton setEnabled:YES];
			[self.refreshControl endRefreshing];
		}else{
			[self showWithError:error];
			[self.refreshControl endRefreshing];
		}
	}];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	[self.refreshControl addTarget:self
							action:@selector(reload)
				  forControlEvents:UIControlEventValueChanged];
	
	[self reload];
	[self.tableView setBackgroundView:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.jobs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    JobTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(!cell){
		cell = [[JobTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}

	[self updateCell:cell atIndexPath:indexPath];
	
    return cell;
}

/*
	Vertaalt het object model naar de view
 */
-(void)updateCell:(UITableViewCell *)cell
	  atIndexPath:(NSIndexPath *)indexPath{
	if([cell isKindOfClass:[JobTableViewCell class]]){
		JobTableViewCell *jobTableViewCell = (JobTableViewCell *)cell;
		[jobTableViewCell.filenameLabel setText:[NSString stringWithFormat:@"%@", [[self.jobs objectAtIndex:indexPath.row] filename]]];
		[jobTableViewCell.mbLabel setText:[NSString stringWithFormat:@"%u/%lu MB", [[self.jobs objectAtIndex:indexPath.row] mb]-[[self.jobs objectAtIndex:indexPath.row] mbleft], (unsigned long)[[self.jobs objectAtIndex:indexPath.row] mb]]];
		[jobTableViewCell.percentageProgressView setProgress:[[self.jobs objectAtIndex:indexPath.row] percentage]/100];
		[jobTableViewCell.toggleStateButton setSelected:[[self.jobs objectAtIndex:indexPath.row] isPaused]];
	}
}


/*
 * METHODES GEDRAG SERVER
 */

/*
 job verwijderen uit de queue
 */
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
	if(editingStyle == UITableViewCellEditingStyleDelete){
		[self.server deleteJob:[self.jobs objectAtIndex:indexPath.row] :^(NSError *error) {
			if(!error){
				self.jobs = self.server.jobs;
				[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			}else{
				[self showWithError:error];
			}
		}];
	}
}

/*
 job verplaatsen in de queue
 */
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
	return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
	[self.server moveJob:[self.jobs objectAtIndex:sourceIndexPath.row] :destinationIndexPath.row :^(NSError *error) {
		if(!error){
			self.jobs = self.server.jobs;
		}else{
			[self showWithError:error];
		}
	}];
}

/*
 server starten/pauzeren
 */
- (IBAction)toggleStatus:(UIBarButtonItem *)sender {
	[self.server toggleStatus:^(NSUInteger paused, NSError *error) {
		if(!error){
			[self ChangeBarButton:paused];
			sender.enabled=YES;
		}else{
			[self showWithError:error];
			sender.enabled=YES;
		}
	}];
	sender.enabled=NO;
}

/*
 *	METHODES GEDRAG INDIVIDUELE JOBS
 */

- (IBAction)toggleJobStatus:(UIButton *)sender {
	CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
	NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	sender.enabled = NO;
	[[self.jobs objectAtIndex:indexPath.row] toggleJobStatus:^(NSError *error) {
		if(!error){
			[self updateCell:cell atIndexPath:indexPath];
			sender.enabled = YES;
		}else{
			[self showWithError:error];
			sender.enabled=YES;
		}
	}];
}


/*
 * HELPER METHODES
 */

/*
 paused: 0 indien niet gepauzeerd, 1 indien gepauzeerd
 */
-(void)ChangeBarButton:(NSUInteger)paused{
	UIBarButtonItem *button = nil;
	if(paused == 0){
		// Server is niet gepauzeerd
		button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause
															   target:self
															   action:@selector(toggleStatus:)];
	}else{
		// Server is gepauzeerd
		button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
															   target:self
															   action:@selector(toggleStatus:)];
	}
	[button setStyle:UIBarButtonItemStyleBordered];
	NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:self.toolbarItems];
	[temp replaceObjectAtIndex:0 withObject:button];
	self.toolbarItems = (NSArray *)temp;
}

-(void) showWithError:(NSError*) error {
    UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:[error localizedDescription]
						  message:[error localizedRecoverySuggestion]
						  delegate:nil
						  cancelButtonTitle:NSLocalizedString(@"Dismiss", @"")
						  otherButtonTitles:nil];
	
    [alert show];
}
@end
