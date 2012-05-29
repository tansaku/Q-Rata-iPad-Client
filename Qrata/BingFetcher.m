//
//  QRataFetcher.m
//
//  Copyright 2011 NeuroGrid Ltd. All rights reserved.
//

#import "BingFetcher.h"
#import "QRataFetcher.h"
#import "BingAPIKey.h"

@implementation BingFetcher

+ (NSArray *)executeBingFetch:(NSString *)query
{
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"[%@ %@] sent %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), query);
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
     //NSLog(@"[%@ %@] received %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), results);
    return results;
}

+ (NSArray *)search:(NSString *)text
{
    NSString *request = [NSString stringWithFormat:@"http://api.search.live.net/json.aspx?Appid=%@&query=%@&sources=web&web.count=50&web.offset=0",BingAPIKey, text];
    NSArray *results = [[self executeBingFetch:request] valueForKeyPath:@"SearchResponse.Web.Results"];
    NSMutableArray* sites = [NSMutableArray arrayWithCapacity:results.count];
    NSURL *bing;
    for (NSDictionary* result in results)
    {
        bing = [NSURL URLWithString:[result objectForKey:BING_URL]];
        [sites addObject:[bing host]];  
    }
    NSArray* qrataMatches = [QRataFetcher siteCheck:sites];
    if(qrataMatches.count > 0)
    {
        // gonna be difficult to get any kind of match unless to check against 
        // raw host portion of url ...
        BOOL addedFlag = FALSE;
        NSMutableArray* merged = [NSMutableArray arrayWithCapacity:results.count];
        for(NSDictionary* result in results)
        {
            for (NSDictionary* match in qrataMatches) {
                bing = [NSURL URLWithString:[result objectForKey:BING_DISPLAY_URL]];
                NSURL *qrata = [NSURL URLWithString:[match objectForKey:QRATA_URL]];
                
                if ([[bing host] isEqualToString:[qrata host]]){
                    [merged addObject:qrataMatches];
                    addedFlag = TRUE;
                    break;
                }
            }
            if(addedFlag == FALSE)
                [merged addObject:result];
            addedFlag = FALSE;
        }
        results = merged;
    }
    return results;
}
@end
