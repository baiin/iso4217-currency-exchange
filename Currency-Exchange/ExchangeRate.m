//
//  ExchangeRate.m
//  Currency-Exchange
//
//  Created by Rj on 3/8/16.
//  Copyright © 2016 Rj. All rights reserved.
//

#import "ExchangeRate.h"

@implementation ExchangeRate

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.rate = [aDecoder decodeObjectForKey: @"rate"];
    self.homeAlphaCode = [aDecoder decodeObjectForKey: @"homeAlphaCode"];
    self.foreignAlphaCode = [aDecoder decodeObjectForKey: @"foreignAlphaCode"];
    self.alphaCodeCombo = [aDecoder decodeObjectForKey: @"alphaCodeCombo"];
    self.lastFetched = [aDecoder decodeObjectForKey: @"lastFetched"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)anEncoder
{
    [anEncoder encodeObject: self.rate forKey: @"rate"];
    [anEncoder encodeObject: self.homeAlphaCode forKey: @"homeAlphaCode"];
    [anEncoder encodeObject: self.foreignAlphaCode forKey: @"foreignAlphaCode"];
    [anEncoder encodeObject: self.alphaCodeCombo forKey: @"alphaCodeCombo"];
    [anEncoder encodeObject: self.lastFetched forKey: @"lastFetched"];
}

@end
