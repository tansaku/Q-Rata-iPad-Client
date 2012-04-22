//
//  QRataFetcher.m
//
//  Copyright 2011 NeuroGrid Ltd. All rights reserved.
//

#import "BingFetcher.h"
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
    return [[self executeBingFetch:request] valueForKeyPath:@"SearchResponse.Web.Results"];
}
@end
