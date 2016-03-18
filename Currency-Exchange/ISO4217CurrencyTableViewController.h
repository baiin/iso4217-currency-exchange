//
//  ISO4217CurrencyTableViewController.h
//  Currency-Exchange
//
//  Created by Rj on 3/5/16.
//  Copyright © 2016 Rj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISO4217Currency.h"
#import "Data.h"

@interface ISO4217CurrencyTableViewController : UITableViewController

@property   (strong)    Data                *data;
@property   (strong)    NSMutableArray      *rowArray;
@property   (strong)    NSMutableArray      *currencyList;
@property   (strong)    NSMutableArray      *checkedCurrencies;

- (IBAction) savePressed: (id) sender;

@end
