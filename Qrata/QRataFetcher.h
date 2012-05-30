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
#define QRATA_ID @"id"
#define QRATA_SCORE @"score"
#define QRATA_EXPERT @"expert_id"
#define QRATA_DESCRIPTION @"description"
#define QRATA_EVALUATION @"evaluation"
#define QRATA_CAVEATS @"caveats"

@interface QRataFetcher : NSObject

+ (NSArray *)search:(NSString *)text;
+ (NSArray *)categorySites:(NSString *)id;
+ (NSArray *)categoryDetails:(NSString *)id;
+ (NSArray *)categoryChildren:(NSString *)id;
+ (NSArray *)categoryParents:(NSString *)id;
+ (NSArray *)categories;
+ (NSArray *)criteria;
+ (NSArray *)siteCheck:(NSArray *)sites;
+ (NSArray *)siteCriterionRatings:(NSString *)id;


@end
