//
//  MetaDataTableViewController.m
//  Qrata
//
//  Created by Samuel Joseph on 3/28/12.
//  Copyright (c) 2012 NeuroGrid Ltd. All rights reserved.
//

#import "MetaDataTableViewController.h"

@implementation MetaDataTableViewController
@synthesize result = _result;
@synthesize ratings = _ratings;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize tableView = _tableView;
@synthesize navigationItem;
@synthesize button;
@synthesize criteria = _criteria;
@synthesize desiredTitle = _desiredTitle;

- (NSDictionary *)criteria
{
    if(!_criteria)
    {
        _criteria = [NSDictionary dictionaryWithObjectsAndKeys:@"Scope & Coverage", @"3",@"Accuracy & Consistency", @"4",@"Currency", @"5",@"Richness of Content", @"6",@"Completeness", @"7",@"Site Size", @"8",@"Navigation", @"9",@"Search & Browsing", @"10",@"Internal & External Links", @"11",@"Output Features", @"12",@"Speed & Availability", @"13",@"Privacy", @"14",@"Source", @"15", nil];
    }
    return _criteria;
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if(_splitViewBarButtonItem != splitViewBarButtonItem){
        self.navigationItem.leftBarButtonItem = splitViewBarButtonItem;
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem.title = @"Vote";
    if(self.button)
    {
        [self setSplitViewBarButtonItem:self.button];
    }
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slanted_gradient.png"]];
    [tempImageView setFrame:self.tableView.frame]; 
    self.tableView.backgroundView = tempImageView;
    self.title = self.desiredTitle;
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [self setNavigationItem:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section == 0)
        return 4;
    else
        return [self.ratings count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section == 0 ? @"Review" : @"Ratings";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if (indexPath.row == 0) {
            return 80;
        }
        else if(indexPath.row == 1)
        {
            return 120;
        }
        else if(indexPath.row == 2)
        {
            return 120;
        }
        else if(indexPath.row == 3)
        {
            return 80;
        }
    }

    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"Meta Data";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Reviewed By:";
            NSNumber *reviewer = [self.result objectForKey:QRATA_EXPERT];
            cell.detailTextLabel.text = reviewer != (id)[NSNull null]? [reviewer stringValue] : @"Unknown"; 
        }
        else if(indexPath.row == 1)
        {
            cell.textLabel.text = @"Description:";
            cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
            cell.detailTextLabel.numberOfLines = 3;
            cell.detailTextLabel.text = [self.result objectForKey:QRATA_DESCRIPTION];
        }
        else if(indexPath.row == 2)
        {
            cell.textLabel.text = @"Evaluation:";
            cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
            cell.detailTextLabel.numberOfLines = 3;
            cell.detailTextLabel.text = [self.result objectForKey:QRATA_EVALUATION];
        }
        else if(indexPath.row == 3)
        {
            cell.textLabel.text = @"Caveats:";
            cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
            cell.detailTextLabel.numberOfLines = 2;
            cell.detailTextLabel.text = [self.result objectForKey:QRATA_CAVEATS];
        }
    }
    else
    {
        static NSString *CellIdentifier = @"Meta Data 2";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        NSDictionary *rating = [self.ratings objectAtIndex:indexPath.row];
        cell.textLabel.text = [self.criteria objectForKey:[[rating objectForKey:@"criterion_id"] stringValue]];
        cell.detailTextLabel.text = [[rating objectForKey:@"score"] stringValue];        
    }
    
   //[self subTitleValue:indexPath.section forResult:result];
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 3;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    if (section ==0)
        return NO;
    return YES;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    if (editing) {
        self.navigationItem.rightBarButtonItem.title = @"Done";
        self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleDone;
    }
    else {
        self.navigationItem.rightBarButtonItem.title = @"Vote";
        self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleBordered;
    }
    
    [self.tableView setEditing:editing animated:animated];
    [self.tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Agree";
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
