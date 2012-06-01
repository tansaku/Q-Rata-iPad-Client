//
//  CriteriaViewController.m
//  Qrata
//
//  Created by Samuel Joseph on 6/1/12.
//  Copyright (c) 2012 NeuroGrid Ltd. All rights reserved.
//

#import "CriteriaViewController.h"
#import "QRataFetcher.h"
@implementation CriteriaViewController

@synthesize navigationItem;
@synthesize tableView = _tableView;
@synthesize criteria = _criteria;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slanted_gradient.png"]];
    [tempImageView setFrame:self.tableView.frame]; 
    self.tableView.backgroundView = tempImageView;
    /*
     UIImageView* subView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slant.png"]];
     subView.alpha = 0.5;
     [subView setFrame:self.tableView.frame];
     [tempImageView addSubview:subView];
     */
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage: [self scale:[UIImage imageNamed:@"type_logo.png"] toSize:CGSizeMake(96, 32)]];
    
    
    //self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"slanted_gradient.png"]];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t qRataDownloadQueue = dispatch_queue_create("experts qrata downloader", NULL);
    dispatch_async(qRataDownloadQueue, ^(void){
        self.criteria = [QRataFetcher criteria];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            self.navigationItem.rightBarButtonItem = nil; 
            [self.tableView reloadData];
        });
    });
    dispatch_release(qRataDownloadQueue);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setNavigationItem:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section == 0 ? @"Content" : @"Access";
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    NSPredicate *p1 = [NSPredicate predicateWithFormat:@"parent_id == %@",[NSNumber numberWithInteger:1]];
    NSPredicate *p2 = [NSPredicate predicateWithFormat:@"parent_id == %@",[NSNumber numberWithInteger:2]];
    NSArray *parent1 = [self.criteria filteredArrayUsingPredicate:p1];
    NSArray *parent2 = [self.criteria filteredArrayUsingPredicate:p2];
    return section == 0 ? [parent1 count] : [parent2 count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"QRata Criteria Result";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSPredicate *p1 = [NSPredicate predicateWithFormat:@"parent_id == %@",[NSNumber numberWithInteger:1]];
    NSPredicate *p2 = [NSPredicate predicateWithFormat:@"parent_id == %@",[NSNumber numberWithInteger:2]];
    NSArray *parent1 = [self.criteria filteredArrayUsingPredicate:p1];
    NSArray *parent2 = [self.criteria filteredArrayUsingPredicate:p2];
     
    NSDictionary *criterion;
    if(indexPath.section == 0)
        criterion = [parent1 objectAtIndex:indexPath.row];
    else
        criterion = [parent2 objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [criterion objectForKey:QRATA_NAME];
    
    
    return cell;
}


#pragma mark - Table view delegate

// key trick with these segues is to use a replace segue
// in the storyboard from the master view to the detail view
// and then select the segue option to have the result shown
// in the detail view

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self performSegueWithIdentifier:@"Criterion" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%@", NSStringFromClass([[segue destinationViewController] class]));
    NSIndexPath *indexPath = [[sender tableView] indexPathForSelectedRow];
    
    NSLog(@"Segue about to be performed %@", segue.identifier);
    
    if([segue.identifier isEqualToString:@"Criterion"])
    {
        QRataResultViewController *qrvc = segue.destinationViewController;
        
        NSDictionary *criterion = [self.criteria objectAtIndex:indexPath.row];
        qrvc.content =  [criterion objectForKey:QRATA_EXPLANATION];
        // if we are seguing and we are in popover we should hide popover, and ensure button is showing detail view
        if (self.datasource.popoverController) {
            [self.datasource.popoverController dismissPopoverAnimated:YES];
            // also need to ensure BarButton is displayed
            [segue.destinationViewController setButton:self.datasource.barButton];
        }
    }
}

@end
