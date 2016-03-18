//
//  Data.h
//  Currency-Exchange
//
//  Created by Rj on 3/6/16.
//  Copyright © 2016 Rj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Data : NSObject

// list of currencies from the is04217.csv
@property   (strong)    NSMutableArray  *iso4217Currencies;

// saved currencies from iso4217
@property   (strong)    NSMutableArray  *favoriteCurrencies;
@property   (strong)    NSMutableArray  *exchangeRates;

+ (id) sharedData;

- (Data*) init;

- (void) loadISO4217Currencies;
- (void) saveISO4217Currencies;

- (void) loadFavoriteCurrencies;
- (void) saveFavoriteCurrencies;

- (void) loadExchangeRates;
- (void) saveExchangeRates;

@end
