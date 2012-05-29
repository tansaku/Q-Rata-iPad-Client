//
//  QRataFetcher.h
//
//  
//  Copyright 2011 NeuroGrid Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BING_NAME @"Title"
#define BING_URL @"Url"
#define BING_DISPLAY_URL @"DisplayUrl"
#define BING_SCORE @"score"

@interface BingFetcher : NSObject

+ (NSArray *)search:(NSString *)text;

@end
