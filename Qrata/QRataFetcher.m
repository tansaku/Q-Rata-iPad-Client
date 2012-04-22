//
//  QRataFetcher.m
//
//  Copyright 2011 NeuroGrid Ltd. All rights reserved.
//

#import "QRataFetcher.h"
#import "QRataAPIKey.h"

@implementation QRataFetcher

+ (NSArray *)executeQRataFetch:(NSString *)query
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
    NSString *request = [NSString stringWithFormat:@"http://api.qrata.com/searches.json?search[search_string]=%@",text];
    return [self executeQRataFetch:request];
}

+ (NSArray *)categoryDetails:(NSString *)id
{
    NSString *request = [NSString stringWithFormat:@"http://api.qrata.com/categories/%@.json",id];
    return [self executeQRataFetch:request];
}

+ (NSArray *)categoryChildren:(NSString *)id
{
    NSString *request = [NSString stringWithFormat:@"http://api.qrata.com/categories/%@/children.json",id];
    return [self executeQRataFetch:request];
}

+ (NSArray *)categoryParents:(NSString *)id
{
    NSString *request = [NSString stringWithFormat:@"http://api.qrata.com/categories/%@/parent.json",id];
    return [self executeQRataFetch:request];
}

+ (NSArray *)categories
{
    return [self executeQRataFetch:@"http://api.qrata.com/categories.json"];
}

+ (NSArray *)criteria
{
    return [self executeQRataFetch:@"http://api.qrata.com/criteria.json"];
}
@end
