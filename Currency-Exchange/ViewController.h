//
//  ViewController.h
//  Currency-Exchange
//
//  Created by Rj on 3/5/16.
//  Copyright © 2016 Rj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISO4217Currency.h"
#import "ExchangeRate.h"
#import "Data.h"

@interface ViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong) Data *data;
@property (strong) NSNumber *exchangeRate;

@property (strong) ISO4217Currency *currencyA;
@property (strong) ISO4217Currency *currencyB;

- (IBAction)convertPressed:(id)sender;
- (IBAction)refreshPressed:(id)sender;

@end

