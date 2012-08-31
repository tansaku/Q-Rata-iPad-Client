//
//  QRataFetcher.h
//
//  
//  Copyright 2011 NeuroGrid Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define QRATA_NAME @"name"
#define QRATA_FIRST_NAME @"first_name"
#define QRATA_LAST_NAME @"last_name"
#define QRATA_BIO @"bio"
#define QRATA_TITLE @"title"
#define QRATA_BODY @"body"
#define QRATA_CATEGORY_NAME @"name"
#define QRATA_CATEGORY_ID @"id"
#define QRATA_URL @"url"
#define QRATA_ID @"id"
#define QRATA_SCORE @"score"
#define QRATA_EXPERT @"expert_id"
#define QRATA_EXPERT_FIRST_NAME @"expert_first_name"
#define QRATA_EXPERT_LAST_NAME @"expert_last_name"
#define QRATA_DESCRIPTION @"description"
#define QRATA_EVALUATION @"evaluation"
#define QRATA_EXPLANATION @"explanation"
#define QRATA_WEAKNESSES @"weaknesses"
#define QRATA_STRENGTHS @"strengths"

@interface QRataFetcher : NSObject

+ (NSArray *)search:(NSString *)text;
+ (NSArray *)categorySites:(NSString *)id;
+ (NSArray *)categoryDetails:(NSString *)id;
+ (NSArray *)categoryChildren:(NSString *)id;
+ (NSArray *)categoryParents:(NSString *)id;
+ (NSArray *)categories;
+ (NSArray *)experts;
+ (NSArray *)criteria;
+ (NSArray *)pages;
+ (NSArray *)siteCheck:(NSArray *)sites;
+ (NSArray *)siteCriterionRatings:(NSString *)id;


@end
