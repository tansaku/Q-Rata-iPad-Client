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
@synthesize searchBar = _searchBar;
@synthesize navigationItem;
@synthesize tableView = _tableView;
@synthesize searchDisplayController;
@synthesize searchText = _searchText;
@synthesize categoryID = _categoryID;
@synthesize selectedRowData = _selectedRowData;
@synthesize selectedRowCriterionRatings = _selectedRowCriterionRatings;

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
     UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
      [spinner startAnimating];
      self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
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
        NSArray *bingResults = [BingFetcher search:text];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            self.navigationItem.rightBarButtonItem = nil;
            self.qRataResults = results;
            self.bingResults = bingResults;
            [self.searchDisplayController setActive:NO];
        });
    });
    dispatch_release(qRataDownloadQueue);
    
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

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self searchBar] setText:_searchText];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.title = @"Q-Rata";
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slanted_gradient.png"]];
    [tempImageView setFrame:self.tableView.frame]; 
    
    //self.navigationItem.titleView = [[UIImageView alloc] initWithImage: [self scale:[UIImage imageNamed:@"type_logo.png"] toSize:CGSizeMake(96, 32)]];

    
    self.tableView.backgroundView = tempImageView;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setSearchDisplayController:nil];
    [self setSearchBar:nil];
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
    if(self.categoryID)
        return 1;
    else
        return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section == 0 ? @"Q-Rata" : @"Bing";
}

- (NSString *)titleValue:(NSInteger)section forResult:(NSDictionary *)result
{
    return [result objectForKey:QRATA_NAME] ? [result objectForKey:QRATA_NAME]: [result objectForKey:BING_NAME];
}

- (NSString *)subTitleValue:(NSInteger)section forResult:(NSDictionary *)result
{
    return  [result objectForKey:QRATA_URL] ? [result objectForKey:QRATA_URL]: [result objectForKey:BING_DISPLAY_URL];
}

- (NSString *)scoreValue:(NSInteger)section forResult:(NSDictionary *) result
{
    return [result objectForKey:QRATA_SCORE] ? [[result objectForKey:QRATA_SCORE] stringValue] : @"0";
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
    cell.textLabel.text = [self titleValue:indexPath.section forResult:result];
    cell.detailTextLabel.text = [self subTitleValue:indexPath.section forResult:result];
    score.text = [self scoreValue:indexPath.section forResult:result];    
   // cell.detailTextLabel.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //CGRect shiftedFrame = cell.detailTextLabel.frame;
    //shiftedFrame.origin.x += 20;
    //shiftedFrame.origin.y += 100;
    //cell.detailTextLabel.frame = shiftedFrame;

    
    //score.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    score.textAlignment = UITextAlignmentCenter;
   
    score.backgroundColor = [UIColor clearColor];
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
    
    
    // should check here if this is a Bing item and perform segue to request a review page instead
    // danger here is that if we don't pass through selected row here, then we will get the 
    // metadata for the previously highlighted 
    
    self.selectedRowData = [[self whichResults:indexPath.section] objectAtIndex:indexPath.row];
    if ([self.selectedRowData objectForKey:QRATA_SCORE]) {
        // need to grab siteCriterionRatings ...
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
        
        dispatch_queue_t qRataDownloadQueue = dispatch_queue_create("qrata criterion downloader", NULL);
        dispatch_async(qRataDownloadQueue, ^(void){
            // TODO get expert actual name ...
            //[QrataFetcher expertName
            NSArray *results = [QRataFetcher siteCriterionRatings:[self.selectedRowData objectForKey:QRATA_ID]];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                self.navigationItem.rightBarButtonItem = nil;
                self.selectedRowCriterionRatings = results;
                [self performSegueWithIdentifier:@"MetaData" sender:self];
            });
        });
        dispatch_release(qRataDownloadQueue);
        
    }
    else
    {
        [self performSegueWithIdentifier:@"EvaluationRequest" sender:self];
    }
    // actually could just detect on meta data page and display the appropriate button

}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"URL" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%@", NSStringFromClass([[segue destinationViewController] class]));
    
   // UIStoryboardPopoverSegue* popoverSegue = (UIStoryboardPopoverSegue*)segue;
   // [sender setPopoverController:[popoverSegue popoverController]];
    
    
    NSIndexPath *indexPath = [[sender tableView] indexPathForSelectedRow];
    NSDictionary *result = [[sender whichResults:indexPath.section] objectAtIndex:indexPath.row];
    
    NSLog(@"Segue about to be performed");
    
    if([segue.identifier isEqualToString:@"MetaData"])
    {
        UINavigationController *nc = segue.destinationViewController;
        MetaDataTableViewController *mdtvc = [nc.viewControllers objectAtIndex:0];
        mdtvc.result = self.selectedRowData;
        mdtvc.ratings = self.selectedRowCriterionRatings;
        NSString* title = [self.selectedRowData objectForKey:QRATA_NAME];
        mdtvc.desiredTitle = title? title : [self.selectedRowData objectForKey:BING_NAME];
    }
    else if([segue.identifier isEqualToString:@"EvaluationRequest"])
    {
        EvaluationRequestViewController *ervc = segue.destinationViewController;
        NSString* title = [self.selectedRowData objectForKey:QRATA_NAME];
        ervc.desiredTitle = title? title : [self.selectedRowData objectForKey:BING_NAME];
    }
    else if([segue.identifier isEqualToString:@"URL"])
    {
        NSString *urlString = [@"http://" stringByAppendingString:[self subTitleValue:indexPath.section forResult:result]];
    
        QRataResultViewController* q = segue.destinationViewController;
        q.url = urlString;
    }
    // if we are seguing and we are in popover we should hide popover, and ensure button is showing detail view
    // [popoverController dismissPopoverAnimated:YES];
    if (self.datasource.popoverController) {
        [self.datasource.popoverController dismissPopoverAnimated:YES];
        // also need to ensure BarButton is displayed
        [segue.destinationViewController setButton:self.datasource.barButton];
    }
}

@end
