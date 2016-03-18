//
//  ISO4217Currency.m
//  Currency-Exchange
//
//  Created by Rj on 3/5/16.
//  Copyright © 2016 Rj. All rights reserved.
//

#import "ISO4217Currency.h"

@implementation ISO4217Currency

+ (id) sharedISO4217Currency
{
    static ISO4217Currency *shared = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{shared = [[self alloc] init];});
    
    return shared;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.entity = [aDecoder decodeObjectForKey: @"entity"];
    self.currency = [aDecoder decodeObjectForKey: @"currency"];
    self.alphaCode = [aDecoder decodeObjectForKey: @"alphaCode"];
    self.numericCode = [aDecoder decodeObjectForKey: @"numericCode"];
    self.minorUnit = [aDecoder decodeObjectForKey: @"minorUnit"];
    self.symbol = [aDecoder decodeObjectForKey: @"symbol"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)anEncoder
{
    [anEncoder encodeObject: self.entity forKey: @"entity"];
    [anEncoder encodeObject: self.currency forKey: @"currency"];
    [anEncoder encodeObject: self.alphaCode forKey: @"alphaCode"];
    [anEncoder encodeObject: self.numericCode forKey: @"numericCode"];
    [anEncoder encodeObject: self.minorUnit forKey: @"minorUnit"];
    [anEncoder encodeObject: self.symbol forKey: @"symbol"];
}

@end
