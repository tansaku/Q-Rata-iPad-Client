//
//  QRataFetcher.h
//
//  
//  Copyright 2011 NeuroGrid Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define QRATA_NAME @"name"
#define QRATA_URL @"url"

@interface QRataFetcher : NSObject

+ (NSArray *)topHits;

@end