//
//  ISO4217Currency.h
//  Currency-Exchange
//
//  Created by Rj on 3/5/16.
//  Copyright © 2016 Rj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISO4217Currency : NSObject <NSCoding>

@property (strong) NSString     *entity;
@property (strong) NSString     *currency;
@property (strong) NSString     *alphaCode;
@property (strong) NSNumber     *numericCode;
@property (strong) NSNumber     *minorUnit;
@property (strong) NSString     *symbol;

+ (id) sharedISO4217Currency;

- (instancetype)initWithCoder:(NSCoder *)aDecoder;
- (void)encodeWithCoder:(NSCoder *)aCoder;

@end
