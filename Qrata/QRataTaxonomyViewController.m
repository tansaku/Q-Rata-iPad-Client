//
//  QRataTableViewController.m
//  Qrata
//
//  Created by Samuel Joseph on 3/27/12.
//  Copyright (c) 2012 NeuroGrid Ltd. All rights reserved.
//

#import "QRataTaxonomyViewController.h"
#import "QRataFetcher.h"
#import "BingFetcher.h"
#import "QRataResultViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MetaDataTableViewController.h"

@implementation QRataTaxonomyViewController

@synthesize infoButton = _infoButton;
@synthesize qRataCategories = _qRataCategories;
@synthesize tableView = _tableView;
@synthesize searchDisplayController;
@synthesize navigationItem;
@synthesize searchText = _searchText;
@synthesize categoryID = _categoryID;
@synthesize categoryName = _categoryName;
@synthesize datasource = _datasource;

-(void)setQRataCategories:(NSArray *)qRataCategories
{
    if(_qRataCategories != qRataCategories) {
        _qRataCategories = qRataCategories;
        [self.tableView reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.searchText = searchBar.text;
    //could initiate network search here and then push over search
    // results to avoid displaying empty table while waiting for results 
    [self performSegueWithIdentifier:@"Search" sender:self];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.splitViewController.delegate = self;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slanted_gradient_plus_black_transparent_small.png"]];
    //[tempImageView setFrame:self.tableView.frame]; 
    tempImageView.contentMode = UIViewContentModeTopLeft;
    self.tableView.backgroundView = tempImageView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
    self.tableView.tableHeaderView = headerView;
        
    // this worked but interfered
    //CGRect frame = CGRectMake(self.view.frame.size.width/10, 0, self.view.frame.size.width/5, 44);
    //UIView *navBarTapView = [[UIView alloc] initWithFrame:frame];
    //[self.navigationController.navigationBar addSubview:navBarTapView];
    //navBarTapView.backgroundColor = [UIColor clearColor];
    //[navBarTapView setUserInteractionEnabled:YES];
    //[self.navigationController.navigationBar setUserInteractionEnabled:YES];
    //[navBarTapView addGestureRecognizer:oneFingerOneTap];
     
    // this didn't work
    //[[self.navigationController.navigationBar.subviews objectAtIndex:1] setUserInteractionEnabled:YES];
    //[[self.navigationController.navigationBar.subviews objectAtIndex:1] addGestureRecognizer:oneFingerOneTap];
    
    // this works but will screw up all nav buttons
    //[self.navigationController.navigationBar addGestureRecognizer:oneFingerOneTap];
    
    
    //self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"slanted_gradient.png"]];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];

    dispatch_queue_t qRataDownloadQueue = dispatch_queue_create("another qrata downloader", NULL);
    dispatch_async(qRataDownloadQueue, ^(void){
        NSArray *categories = nil;
        if(!self.categoryID){
            categories = [QRataFetcher categories];
        }else{
            categories = [QRataFetcher categoryChildren:self.categoryID];
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            self.navigationItem.rightBarButtonItem = self.infoButton;
            self.qRataCategories = categories;
            [self.searchDisplayController setActive:NO];
            // comment these two lines out to avoid auto search
            //self.searchText = @"test"; 
            //[self performSegueWithIdentifier:@"Search" sender:self];

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
    [self setInfoButton:nil];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 24;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.navigationItem.backBarButtonItem ? self.navigationItem.backBarButtonItem.title : @"Explore";
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, 18)];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.qRataCategories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"QRata Result";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    NSDictionary *category = [self.qRataCategories objectAtIndex:indexPath.row];
    cell.textLabel.text = [category objectForKey:QRATA_CATEGORY_NAME];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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

// key trick with these segues is to use a replace segue
// in the storyboard from the master view to the detail view
// and then select the segue option to have the result shown
// in the detail view

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // do an async query here to find number of children for current category node
    // and then segue on that basis ...
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];

    NSDictionary *childCategory = [self.qRataCategories objectAtIndex:indexPath.row];
    
    dispatch_queue_t qRataDownloadQueue = dispatch_queue_create("qrata downloader", NULL);
    dispatch_async(qRataDownloadQueue, ^(void){
        NSArray *categories = [QRataFetcher categoryChildren:[childCategory objectForKey:QRATA_CATEGORY_ID]];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            self.navigationItem.rightBarButtonItem = self.infoButton;
            if(categories.count > 0)
            {
                [self performSegueWithIdentifier:@"Children" sender:self];
            }
            else
            {
                self.searchText = self.categoryName;
                [self performSegueWithIdentifier:@"Sites" sender:self];
            }
        });
    });
    dispatch_release(qRataDownloadQueue);

}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"MetaData" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%@", NSStringFromClass([[segue destinationViewController] class]));
    if([segue.identifier isEqualToString:@"Pages"])
    {
        InfoViewController *ivc = segue.destinationViewController;
        ivc.datasource = self.datasource;
    }
    else if([segue.identifier isEqualToString:@"Home"])
    {
        QRataResultViewController* q = segue.destinationViewController;
        q.url = nil;
        if (self.datasource.popoverController) {
            [self.datasource.popoverController dismissPopoverAnimated:YES];
            // also need to ensure BarButton is displayed
            [segue.destinationViewController setButton:self.datasource.barButton];
        }
    }
    else
    {
        NSIndexPath *indexPath = [[sender tableView] indexPathForSelectedRow];
        NSDictionary *childCategory = [[sender qRataCategories] objectAtIndex:indexPath.row];
        
        NSLog(@"Segue about to be performed %@", segue.identifier);
        
        if([segue.identifier isEqualToString:@"Search"])
        {
            QRataSearchViewController *qsvc = segue.destinationViewController;
            qsvc.searchText = self.searchText;
            // TODO would be better to set QRataTaxonomyController as dataSource
            // for the SearchViewController so it can refer back to popoverController without relying on it being passed
            // pass over the popover if there is one so search controller
            // can dismiss as necessary
            qsvc.datasource = self.datasource;
        }
        else if 
            ([segue.identifier isEqualToString:@"Sites"])
        {
            QRataSearchViewController *qsvc = segue.destinationViewController;
            qsvc.searchText = self.searchText;
            qsvc.categoryID = [childCategory objectForKey:QRATA_CATEGORY_ID];
            // pass over the popover if there is one so search controller
            // can dismiss as necessary
            qsvc.datasource = self.datasource;
        }
        else if 
            ([segue.identifier isEqualToString:@"Children"])
        {
            QRataTaxonomyViewController *qtvc = segue.destinationViewController;
            qtvc.categoryID = [childCategory objectForKey:QRATA_CATEGORY_ID];
            qtvc.categoryName = [childCategory objectForKey:QRATA_CATEGORY_NAME];
            qtvc.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:qtvc.categoryName style:UIBarButtonItemStylePlain target:nil action:nil];
            // pass over the popover if there is one so second taxonomy browser continues to have access
            qtvc.datasource = self.datasource;
        }
    }
}

@end
