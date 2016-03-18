//
//  ExchangeRate.h
//  Currency-Exchange
//
//  Created by Rj on 3/8/16.
//  Copyright © 2016 Rj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISO4217Currency.h"

@interface ExchangeRate : NSObject <NSCoding>

@property (strong) NSNumber *rate;
@property (strong) NSString *homeAlphaCode;
@property (strong) NSString *foreignAlphaCode;
@property (strong) NSString *alphaCodeCombo;
@property (strong) NSDate *lastFetched;

- (instancetype)initWithCoder:(NSCoder *)aDecoder;
- (void)encodeWithCoder:(NSCoder *)aCoder;

@end
