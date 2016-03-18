//
//  Data.m
//  Currency-Exchange
//
//  Created by Rj on 3/6/16.
//  Copyright © 2016 Rj. All rights reserved.
//

#import "Data.h"

@implementation Data

+ (id) sharedData
{
    static Data *shared = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{shared = [[self alloc] init];});
    
    return shared;
}

- (Data*) init
{
    self = [super init];
    
    if(self)
    {
        self.iso4217Currencies = [[NSMutableArray alloc] init];
        self.favoriteCurrencies = [[NSMutableArray alloc] init];
        self.exchangeRates = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) loadISO4217Currencies
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"iso4217Currencies"];
    NSMutableArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData: data];
    
    // only load currencies if there is data to load
    if([arr count] > 0)
    {
        self.iso4217Currencies = arr;
    }
}

- (void) saveISO4217Currencies
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject: self.iso4217Currencies];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"iso4217Currencies"];
}

- (void) loadFavoriteCurrencies
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"favoriteCurrencies"];
    NSMutableArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData: data];
    
    // only load currencies if there is data to load
    if([arr count] > 0)
    {
        self.favoriteCurrencies = arr;
    }
}

- (void) saveFavoriteCurrencies
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject: self.favoriteCurrencies];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"favoriteCurrencies"];
}

- (void) loadExchangeRates
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"exchangeRates"];
    NSMutableArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData: data];
    
    if([arr count] > 0)
    {
        self.exchangeRates = arr;
    }
}

- (void) saveExchangeRates
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject: self.exchangeRates];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"exchangeRates"];
}

@end
