//
//  ViewController.m
//  Currency-Exchange
//
//  Created by Rj on 3/5/16.
//  Copyright © 2016 Rj. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.data = [Data sharedData];
    
    [self.data loadFavoriteCurrencies];
    [self.data loadExchangeRates];
    
    self.currencyA = [[ISO4217Currency alloc] init];
    self.currencyB = [[ISO4217Currency alloc] init];
    
    if(self.data.favoriteCurrencies.count > 0)
    {
        self.currencyA = [self.data.favoriteCurrencies objectAtIndex: 0];
        self.currencyB = [self.data.favoriteCurrencies objectAtIndex: 0];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing: YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    [self.pickerView reloadAllComponents];
    
    [self.data loadFavoriteCurrencies];

    if(self.data.favoriteCurrencies.count > 0)
    {
        self.currencyA = [self.data.favoriteCurrencies objectAtIndex: [self.pickerView selectedRowInComponent: 0]];
        self.currencyB = [self.data.favoriteCurrencies objectAtIndex: [self.pickerView selectedRowInComponent: 1]];
    }
}


// boiler plate function to resolve query url
NSString* getURL(NSString *homeAlphaCode, NSString *foreignAlphaCode)
{
    NSString *urlFront = @"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22";
    NSString *urlmiddle = [NSString stringWithFormat: @"%@%@", homeAlphaCode, foreignAlphaCode];
    NSString *urlBack = @"%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=";
    
    urlFront = [urlFront stringByAppendingString: urlmiddle];
    urlFront = [urlFront stringByAppendingString: urlBack];
    
    return urlFront;
}

- (IBAction)convertPressed:(id)sender
{
    if([self.data.favoriteCurrencies count] < 2)
    {
        self.resultLabel.text = @"Need More Currencies";
    }
    else
    {
        if([self.currencyA.entity isEqualToString: self.currencyB.entity])
        {
            self.resultLabel.text = @"Select Different Currencies";
        }
        else
        {
            NSString *amount = self.amountTextField.text;
            
            if([amount isEqualToString: @""] || amount.floatValue == 0)
            {
                self.resultLabel.text = @"Enter a Valid Value";
            }
            else
            {
                BOOL    isStoredRate = NO;
                
                // search if the rate was already queried
                for(ExchangeRate *e in self.data.exchangeRates)
                {
                    if([e.alphaCodeCombo rangeOfString: self.currencyA.alphaCode].location == NSNotFound)
                    {
                        // not found
                    }
                    else
                    {
                        if([e.alphaCodeCombo rangeOfString: self.currencyB.alphaCode].location == NSNotFound)
                        {
                            // not found
                        }
                        else
                        {
                            isStoredRate = YES;
                            
                            // check if the rate is outdated, update it if necessary
                            if([[NSDate date] timeIntervalSince1970] - [e.lastFetched timeIntervalSince1970] >= 5)
                            {
                                NSString *urlFront = [[NSString alloc] init];
                                urlFront = getURL(e.homeAlphaCode, e.foreignAlphaCode);
                                
                                NSURLSession *session = [NSURLSession sharedSession];
                                
                                [[session dataTaskWithURL:[NSURL URLWithString: urlFront] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                                    NSError  *errorVal;
                                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorVal];
                                    NSNumber *rates = [[[[json objectForKey:@"query"] objectForKey:@"results"] objectForKey:@"rate"] valueForKey: @"Rate"];
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        e.rate = rates;
                                        e.lastFetched = [NSDate date];
                                        
                                        if([e.homeAlphaCode isEqualToString: self.currencyA.alphaCode])
                                        {
                                            // use stored rate
                                            self.exchangeRate = e.rate;
                                        }
                                        else
                                        {
                                            // use inverse of rate
                                            self.exchangeRate = @(1 / [e.rate floatValue]);
                                        }
                                        
                                        NSNumber *result = @([amount floatValue] * [self.exchangeRate floatValue]);
                                        
                                        NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
                                        
                                        [numFormatter setMinimumFractionDigits: self.currencyB.minorUnit.integerValue];
                                        [numFormatter setMaximumFractionDigits: self.currencyB.minorUnit.integerValue];
                                        
                                        self.resultLabel.text = [NSString stringWithFormat:@"%@%@ is %@%@", self.currencyA.symbol, self.amountTextField.text, self.currencyB.symbol, [numFormatter stringFromNumber: result]];
                                        
                                        [self.data saveExchangeRates];
                                        
                                        NSLog(@"stale data");
                                    });
                                }] resume];
                            }
                            else
                            {
                                if([e.homeAlphaCode isEqualToString: self.currencyA.alphaCode])
                                {
                                    // use stored rate
                                    self.exchangeRate = e.rate;
                                }
                                else
                                {
                                    // use inverse of rate
                                    self.exchangeRate = @(1 / [e.rate floatValue]);
                                }
                                
                                NSNumber *result = @([amount floatValue] * [self.exchangeRate floatValue]);
                                
                                NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
                                
                                [numFormatter setMinimumFractionDigits: self.currencyB.minorUnit.integerValue];
                                [numFormatter setMaximumFractionDigits: self.currencyB.minorUnit.integerValue];
                                
                                self.resultLabel.text = [NSString stringWithFormat:@"%@%@ is %@%@", self.currencyA.symbol, self.amountTextField.text, self.currencyB.symbol, [numFormatter stringFromNumber: result]];
                                
                                NSLog(@"no query necessary");
                            }
                            
                            [self.view endEditing: YES];
                            
                            break;
                        }
                    }
                }
                
                // make a query to Yahoo if exchange rate is not stored
                if(isStoredRate == NO)
                {
                    NSString *urlFront = [[NSString alloc] init];
                    urlFront = getURL(self.currencyA.alphaCode, self.currencyB.alphaCode);
                    
                    NSURLSession *session = [NSURLSession sharedSession];
                    
                    [[session dataTaskWithURL:[NSURL URLWithString: urlFront] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                        NSError  *e;
                        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&e];
                        NSNumber *rates = [[[[json objectForKey:@"query"] objectForKey:@"results"] objectForKey:@"rate"] valueForKey: @"Rate"];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.exchangeRate = rates;
                            
                            NSNumber *result = @([amount floatValue] * [self.exchangeRate floatValue]);
                            
                            NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
                            
                            [numFormatter setMinimumFractionDigits: self.currencyB.minorUnit.integerValue];
                            [numFormatter setMaximumFractionDigits: self.currencyB.minorUnit.integerValue];
                            
                            self.resultLabel.text = [NSString stringWithFormat:@"%@%@ is %@%@", self.currencyA.symbol, self.amountTextField.text, self.currencyB.symbol, [numFormatter stringFromNumber: result]];
                            
                            ExchangeRate    *newExchangeRate = [[ExchangeRate alloc] init];
                            
                            newExchangeRate.rate = rates;
                            newExchangeRate.homeAlphaCode = self.currencyA.alphaCode;
                            newExchangeRate.foreignAlphaCode = self.currencyB.alphaCode;
                            newExchangeRate.alphaCodeCombo = [NSString stringWithFormat:@"%@%@", self.currencyA.alphaCode, self.currencyB.alphaCode];
                            newExchangeRate.lastFetched = [NSDate date];
                            
                            // add the new exchange rate to our favorites list
                            [self.data.exchangeRates addObject: newExchangeRate];
                            [self.data saveExchangeRates];
                            
                            NSLog(@"new fetch");
                            
                            [self.view endEditing:YES];
                        });
                    }] resume];
                }
            }
        }
    }
}

- (IBAction)refreshPressed:(id)sender
{
    NSLog(@"refresh");
    
    for(ExchangeRate *eRate in self.data.exchangeRates)
    {
        NSString *urlFront = getURL(eRate.homeAlphaCode, eRate.foreignAlphaCode);
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        [[session dataTaskWithURL:[NSURL URLWithString: urlFront] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
            NSError  *e;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&e];
            NSNumber *rates = [[[[json objectForKey:@"query"] objectForKey:@"results"] objectForKey:@"rate"] valueForKey: @"Rate"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                eRate.rate = rates;
                [self.data saveExchangeRates];
                NSLog(@"refreshed: %@ = %@", eRate.alphaCodeCombo, eRate.rate);
            });
        }] resume];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    ISO4217Currency *thisCurrency = [self.data.favoriteCurrencies objectAtIndex: row];
    
    if(component == 0)
    {
        self.currencyA = thisCurrency;
    }
    else
    {
        self.currencyB = thisCurrency;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.data.favoriteCurrencies count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    ISO4217Currency *thisCurrency = [self.data.favoriteCurrencies objectAtIndex: row];
    
    return [NSString stringWithFormat:@"%@", thisCurrency.currency];
}

@end
