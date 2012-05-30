//
//  QRataResultViewController.m
//  Qrata
//
//  Created by Samuel Joseph on 3/27/12.
//  Copyright (c) 2012 NeuroGrid Ltd. All rights reserved.
//

#import "QRataResultViewController.h"
#import "MetaDataTableViewController.h"
#import "QRataSearchViewController.h"

@implementation QRataResultViewController
@synthesize webView = _webView;
@synthesize url = _url;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize toolbar = _toolbar;
@synthesize button;
@synthesize spinner = _spinner;

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if(_splitViewBarButtonItem != splitViewBarButtonItem){
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        if(_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
        if(splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
        self.toolbar.items = toolbarItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}

- (void)setUrl:(NSString *)url
{
    if(_url != url) _url = url;
    [self loadUrl:url ];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadUrl:(NSString *)urlString{
    //Create a URL object.
    NSURL *url;
    if(!urlString) 
        url = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html"];
    else
        url = [NSURL URLWithString:urlString];
        
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error : %@",error);
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if(!self.spinner)
    {
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.spinner startAnimating];
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        [toolbarItems addObject:[[UIBarButtonItem alloc] initWithCustomView:self.spinner]];
        self.toolbar.items = toolbarItems;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(self.spinner)
    {
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        [toolbarItems removeLastObject];
        self.toolbar.items = toolbarItems;
        self.spinner = nil;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"Request: %@",[[request mainDocumentURL] lastPathComponent]);
    //NSLog(@"NavigationType: %@",navigationType);
    return YES;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView.delegate=self;
    [self loadUrl:self.url];
    if(self.button)
    {
        [self setSplitViewBarButtonItem:self.button];
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
