//
//  QRataTableViewController.m
//  Qrata
//
//  Created by Samuel Joseph on 3/27/12.
//  Copyright (c) 2012 NeuroGrid Ltd. All rights reserved.
//

#import "QRataSearchViewController.h"
#import "QRataFetcher.h"
#import "BingFetcher.h"
#import "QRataResultViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MetaDataTableViewController.h"

@implementation QRataSearchViewController

@synthesize qRataResults = _qRataResults;
@synthesize bingResults = _bingResults;
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

-(void)setQRataResults:(NSArray *)qRataResults
{
    if(_qRataResults != qRataResults) {
        _qRataResults = qRataResults;
        [self.tableView reloadData];
    }
}

-(void)setBingResults:(NSArray *)bingResults
{
    if(_bingResults != bingResults) {
        _bingResults = bingResults;
        [self.tableView reloadData];
    }
}

- (void)search:(NSString *)text
{
    // UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //  [spinner startAnimating];
    //  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t qRataDownloadQueue = dispatch_queue_create("qrata downloader", NULL);
    dispatch_async(qRataDownloadQueue, ^(void){
        NSArray *results = nil;
        if(self.categoryID)
        {
            results = [QRataFetcher categorySites:self.categoryID];
        }
        else
        {
            results = [QRataFetcher search:text];
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //self.navigationItem.rightBarButtonItem = nil;
            self.qRataResults = results;
            [self.searchDisplayController setActive:NO];
        });
    });
    dispatch_release(qRataDownloadQueue);
    
    dispatch_queue_t bingDownloadQueue = dispatch_queue_create("bing downloader", NULL);
    dispatch_async(bingDownloadQueue, ^(void){
        NSArray *results = [BingFetcher search:text];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //self.navigationItem.rightBarButtonItem = nil;
            self.bingResults = results;
            [self.searchDisplayController setActive:NO];
        });
    });
    dispatch_release(bingDownloadQueue);
}

-(void)setSearchText:(NSString *)searchText
{
    if(_searchText != searchText){
        _searchText = searchText;
    }
    [self search:_searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.categoryID = nil; // if we search we lose nav?
    [self search:searchBar.text];
    
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
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setSearchDisplayController:nil];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section == 0 ? @"Q-Rata" : @"Bing";
}

- (NSString *)titleKey:(NSInteger)section
{
    return section == 0 ? QRATA_NAME : BING_NAME;
}

- (NSString *)subTitleValue:(NSInteger)section forResult:(NSDictionary *)result
{
    return section == 0 ? [result objectForKey:QRATA_URL] : [[result objectForKey:BING_URL] substringFromIndex:7];
}

- (NSString *)scoreValue:(NSInteger)section forResult:(NSDictionary *) result
{
    return section == 0 ? [[result objectForKey:QRATA_SCORE] stringValue] : @"0";
}

- (NSArray *)whichResults:(NSInteger)section
{
    return section == 0 ? self.qRataResults : self.bingResults;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self whichResults:section] count];}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"QRata Result";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    UILabel *score = (UILabel*)[cell viewWithTag:123];
    if (!score) {
        score = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 36, 36)];
        score.tag = 123;
    }
    
    NSArray *results = [self whichResults:indexPath.section];
    NSDictionary *result = [results objectAtIndex:indexPath.row];
    cell.textLabel.text = [result objectForKey:[self titleKey:indexPath.section]];
    cell.detailTextLabel.text = [self subTitleValue:indexPath.section forResult:result];
    score.text = [self scoreValue:indexPath.section forResult:result];    
   // cell.detailTextLabel.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //CGRect shiftedFrame = cell.detailTextLabel.frame;
    //shiftedFrame.origin.x += 20;
    //shiftedFrame.origin.y += 100;
    //cell.detailTextLabel.frame = shiftedFrame;

    
    //score.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    score.textAlignment = UITextAlignmentCenter;
   
    score.backgroundColor = [UIColor yellowColor];
    score.font = [UIFont fontWithName:@"Cochin" size: 14.0];
    NSString* imagePath = [ [ NSBundle mainBundle] pathForResource:@"dummy" ofType:@"png"];
    
    cell.imageView.image = [UIImage imageWithContentsOfFile: imagePath];
    // trying to add gradient, but not working at present:
    // http://stackoverflow.com/questions/4850149/adding-a-cggradient-as-sublayer-to-uilabel-hides-the-text-of-label
    // http://stackoverflow.com/questions/422066/gradients-on-uiview-and-uilabels-on-iphone
    
    //CAGradientLayer *gradient = [CAGradientLayer layer];
    //gradient.frame = cell.imageView.bounds;
    //gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
    //[cell.imageView.layer insertSublayer:gradient atIndex:0];

    [cell.imageView addSubview:score];

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
    [self performSegueWithIdentifier:@"URL" sender:self];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"MetaData" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%@", NSStringFromClass([[segue destinationViewController] class]));
    NSIndexPath *indexPath = [[sender tableView] indexPathForSelectedRow];
    NSDictionary *result = [[sender whichResults:indexPath.section] objectAtIndex:indexPath.row];
    
    NSLog(@"Segue about to be performed");
    
    if([segue.identifier isEqualToString:@"MetaData"])
    {
        MetaDataTableViewController *mdtvc = segue.destinationViewController;
        mdtvc.result = result;
    }
    else if([segue.identifier isEqualToString:@"URL"])
    {
        NSString *urlString = [@"http://" stringByAppendingString:[self subTitleValue:indexPath.section forResult:result]];
    
        QRataResultViewController* q = segue.destinationViewController;
        q.url = urlString;
    }
}

@end
