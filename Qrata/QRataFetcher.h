//
//  QRataFetcher.h
//
//  
//  Copyright 2011 NeuroGrid Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define QRATA_NAME @"name"
#define QRATA_CATEGORY_NAME @"name"
#define QRATA_CATEGORY_ID @"id"
#define QRATA_URL @"url"
#define QRATA_SCORE @"score"

@interface QRataFetcher : NSObject

+ (NSArray *)search:(NSString *)text;
+ (NSArray *)categorySites:(NSString *)id;
+ (NSArray *)categoryDetails:(NSString *)id;
+ (NSArray *)categoryChildren:(NSString *)id;
+ (NSArray *)categoryParents:(NSString *)id;
+ (NSArray *)categories;
+ (NSArray *)criteria;
+ (NSArray *)siteCheck:(NSArray *)sites;

@end
