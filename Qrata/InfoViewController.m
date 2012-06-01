//
//  InfoViewController.m
//  Qrata
//
//  Created by Samuel Joseph on 6/1/12.
//  Copyright (c) 2012 NeuroGrid Ltd. All rights reserved.
//

#import "InfoViewController.h"
#import "QRataFetcher.h"

@implementation InfoViewController

@synthesize navigationItem;
@synthesize tableView = _tableView;
@synthesize pages = _pages;

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
    
    dispatch_queue_t qRataDownloadQueue = dispatch_queue_create("pages qrata downloader", NULL);
    dispatch_async(qRataDownloadQueue, ^(void){
        self.pages = [QRataFetcher pages];
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
    return 1;
}
/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.navigationItem.backBarButtonItem ? self.navigationItem.backBarButtonItem.title : @"Q-Rata";
}
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.pages count] + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"QRata Page Result";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    if(indexPath.row < self.pages.count){
        NSDictionary *page = [self.pages objectAtIndex:indexPath.row];
        NSString *raw = [page objectForKey:QRATA_TITLE];
        NSString *spaced = [raw stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        cell.textLabel.text = [@"Q/" stringByAppendingString:[spaced capitalizedString]];
    }
    else if(indexPath.row == self.pages.count)
    {
        cell.textLabel.text = @"Q/Experts";
    }
    else
    {
        cell.textLabel.text = @"Q/Criteria";
    }
        
    return cell;
}


#pragma mark - Table view delegate

// key trick with these segues is to use a replace segue
// in the storyboard from the master view to the detail view
// and then select the segue option to have the result shown
// in the detail view

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < self.pages.count){
        //NSDictionary *page = [self.pages objectAtIndex:indexPath.row];
        //self.body = [page objectForKey:QRATA_BODY];
        
        [self performSegueWithIdentifier:@"Pages" sender:self];
    }
    else if(indexPath.row == self.pages.count)
    {
        // need to push experts table view
    }
    else
    {
        // need to push criteria table view
    }
        
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%@", NSStringFromClass([[segue destinationViewController] class]));
    NSIndexPath *indexPath = [[sender tableView] indexPathForSelectedRow];

    
    NSLog(@"Segue about to be performed %@", segue.identifier);
    
    if([segue.identifier isEqualToString:@"Pages"])
    {
        QRataResultViewController *qrvc = segue.destinationViewController;
        
        NSDictionary *page = [self.pages objectAtIndex:indexPath.row];
        qrvc.content =  [page objectForKey:QRATA_BODY];
    }
}


@end
