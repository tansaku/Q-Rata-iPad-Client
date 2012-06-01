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
    NSLog(@"[%@ %@] sent %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), query);
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSMutableArray *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
     //NSLog(@"[%@ %@] received %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), results);
    if (results && results.count > 0)
    {
        [results removeObjectIdenticalTo:nil];
        [results removeObjectIdenticalTo:[NSNull null]];
    }
    return results;
}

+ (NSArray *)search:(NSString *)text
{
    NSString *request = [NSString stringWithFormat:@"http://api.qrata.com/searches.json?search[search_string]=%@",text];
    return [self executeQRataFetch:request];
}

+ (NSArray *)categorySites:(NSString *)id
{
    NSString *request = [NSString stringWithFormat:@"http://api.qrata.com/categories/%@/sites.json",id];
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

+ (NSArray *)siteCheck:(NSArray *)sites
{
    NSString *siteList = [[sites valueForKey:@"description"] componentsJoinedByString:@"&sites[]="];
    NSString *request = [NSString stringWithFormat:@"http://api.qrata.com/sites.json?sites[]=%@",siteList];
    return [self executeQRataFetch:request];
}

+ (NSArray *)siteCriterionRatings:(NSString *)id
{
    NSString *request = [NSString stringWithFormat:@"http://api.qrata.com/sites/%@/site_criterion_ratings.json",id];
    return [self executeQRataFetch:request];
}

+ (NSArray *)categories
{
    return [self executeQRataFetch:@"http://api.qrata.com/categories.json"];
}

+ (NSArray *)experts
{
    return [self executeQRataFetch:@"http://api.qrata.com/experts.json"];
}

+ (NSArray *)pages
{
    return [self executeQRataFetch:@"http://api.qrata.com/mobile_pages.json"];
}

+ (NSArray *)criteria
{
    return [self executeQRataFetch:@"http://api.qrata.com/criteria.json"];
}
@end
