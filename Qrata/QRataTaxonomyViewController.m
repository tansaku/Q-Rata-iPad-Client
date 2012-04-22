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

@synthesize qRataCategories = _qRataCategories;
@synthesize tableView = _tableView;
@synthesize searchDisplayController;
@synthesize delegate = _delegate;
@synthesize searchText = _searchText;
@synthesize categoryID = _categoryID;

-(QRataResultViewController *)splitViewQRataResultViewController{
    id gvc = [self.splitViewController.viewControllers lastObject];
    if(![gvc isKindOfClass:[QRataResultViewController class]]){
        gvc = nil;
    }
    return gvc;
}

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
    //TODO have to pass along text or set it or something ...
    [self performSegueWithIdentifier:@"Search" sender:self];
    
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
    
    dispatch_queue_t qRataDownloadQueue = dispatch_queue_create("qrata downloader", NULL);
    dispatch_async(qRataDownloadQueue, ^(void){
        NSArray *categories = nil;
        if(!self.categoryID){
            categories = [QRataFetcher categories];
        }else{
            categories = [QRataFetcher categoryChildren:self.categoryID];
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //self.navigationItem.rightBarButtonItem = nil;
            self.qRataCategories = categories;
            [self.searchDisplayController setActive:NO];
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
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.navigationItem.backBarButtonItem ? self.navigationItem.backBarButtonItem.title : @"Q-Rata";
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
    [self performSegueWithIdentifier:@"Children" sender:self];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"MetaData" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%@", NSStringFromClass([[segue destinationViewController] class]));

    
    NSLog(@"Segue about to be performed %@", segue.identifier);
    
    if([segue.identifier isEqualToString:@"Search"])
    {
        QRataSearchViewController *qsvc = segue.destinationViewController;
        qsvc.searchText = self.searchText;
    }
    else if 
        ([segue.identifier isEqualToString:@"Children"])
    {
        NSIndexPath *indexPath = [[sender tableView] indexPathForSelectedRow];
        NSDictionary *result = [[sender qRataCategories] objectAtIndex:indexPath.row];
        QRataTaxonomyViewController *qtvc = segue.destinationViewController;
        qtvc.categoryID = [result objectForKey:QRATA_CATEGORY_ID];
        self.searchText = [result objectForKey:QRATA_CATEGORY_NAME];
        qtvc.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[result objectForKey:QRATA_CATEGORY_NAME] style:UIBarButtonItemStylePlain target:nil action:nil];
    }
}
@end
