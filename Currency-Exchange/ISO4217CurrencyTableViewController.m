//
//  ISO4217CurrencyTableViewController.m
//  Currency-Exchange
//
//  Created by Rj on 3/5/16.
//  Copyright © 2016 Rj. All rights reserved.
//

#import "ISO4217CurrencyTableViewController.h"

@interface ISO4217CurrencyTableViewController ()

@end

@implementation ISO4217CurrencyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.data = [Data sharedData];
    self.currencyList = [[NSMutableArray alloc] init];
    self.checkedCurrencies = [[NSMutableArray alloc] init];
    
    for(ISO4217Currency *i in self.data.favoriteCurrencies)
    {
        [self.checkedCurrencies addObject: i];
    }
    
    [self.data loadISO4217Currencies];
    
    if([self.data.iso4217Currencies count] == 0)
    {
        // read the csv file
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"iso4217" ofType:@"csv"];
        NSString *myCSVString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil ];
        
        self.rowArray = [[NSMutableArray alloc]initWithArray:[myCSVString componentsSeparatedByString:@"\n"]];
        
        NSLog(@"%@", myCSVString);
        
        // loop through each row and add it to the list of currencies
        for(NSString *row in self.rowArray)
        {
            NSArray* tempArray = [row componentsSeparatedByString:@","];
            
            if([tempArray count] < 6)
            {
                break;
            }
            
            ISO4217Currency *thisCurrency = [[ISO4217Currency alloc] init];
            
            thisCurrency.entity = [NSString stringWithFormat: @"%@", [tempArray objectAtIndex: 0]];
            thisCurrency.currency = [NSString stringWithFormat: @"%@", [tempArray objectAtIndex: 1]];
            thisCurrency.alphaCode = [NSString stringWithFormat: @"%@", [tempArray objectAtIndex: 2]];
            thisCurrency.numericCode = [tempArray objectAtIndex: 3];
            thisCurrency.minorUnit = [tempArray objectAtIndex: 4];
            thisCurrency.symbol = [NSString stringWithFormat: @"%@", [tempArray objectAtIndex: 5]];
            
            [self.data.iso4217Currencies addObject: thisCurrency];
        }
        
        [self.data saveISO4217Currencies];
        NSLog(@"new csv query");
    }
    else
    {
        NSLog(@"already queried the csv");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)savePressed:(id)sender
{
    [self.data.favoriteCurrencies removeAllObjects];
    
    // look through all currencies that have a checkmark associated with them
    for(ISO4217Currency *i in self.checkedCurrencies)
    {
        BOOL added = NO;
        
        // check if the currency is already in the favorites list
        for(ISO4217Currency *j in self.data.favoriteCurrencies)
        {
            if([i.entity isEqualToString: j.entity])
            {
                added = YES;
            }
        }
        
        // if it wasn't in the favorites list, add it
        if(added == NO)
        {
            [self.data.favoriteCurrencies addObject: i];
        }
    }
    
    [self.data saveFavoriteCurrencies];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data.iso4217Currencies count];
}

// displays content of each cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleIdentifier = @"ISO4217CurrencyCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: simpleIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:simpleIdentifier];
    }
    
    ISO4217Currency *thisCurrency = [[ISO4217Currency alloc] init];
    thisCurrency = [self.data.iso4217Currencies objectAtIndex: indexPath.row];
    cell.textLabel.text = thisCurrency.currency;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    // display checkmarks
    for(ISO4217Currency *i in self.checkedCurrencies)
    {
        if([i.currency isEqualToString: cell.textLabel.text])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        }
    }
    
    return cell;
}

// called when user selects a currency from the tableview
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *thisCell = [tableView cellForRowAtIndexPath: indexPath];
    
    // if currency is already checked, remove the checkmark
    if(thisCell.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        thisCell.accessoryType = UITableViewCellAccessoryNone;
        
        for(NSInteger i = 0; i < [self.checkedCurrencies count]; ++i)
        {
            ISO4217Currency *thisCurrency = [self.checkedCurrencies objectAtIndex: i];
            
            if([thisCell.textLabel.text isEqualToString: thisCurrency.currency])
            {
                [self.checkedCurrencies removeObjectAtIndex: i];
                break;
            }
        }
    }
    // add the checkmark to currency
    else
    {
        thisCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        // add to currency to checked currencies, array used as a placeholder before saving
        [self.checkedCurrencies addObject: [self.data.iso4217Currencies objectAtIndex: indexPath.row]];
    }
}

@end
