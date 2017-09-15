//
//  ExchangeRateParser.m
//  ReadWebViewData
//
//  Created by Dmitry on 15.09.17.
//  Copyright © 2017 Evstratov Dmitry. All rights reserved.
//

#import "ExchangeRateParser.h"
#import "ExchangeRate.h"
#import "TFHpple.h"

static NSString * const XPathQueryTemplate = @"//tr[@class='tr %@']/td[@class='type %@']";
static const NSArray *currencyTypeList;
static const NSArray *operationTypeList;

@interface ExchangeRateParser ()

@property (nonatomic, copy) NSString *contentString;
@property (nonatomic, strong) TFHpple *document;

@end

@implementation ExchangeRateParser

#pragma mark - Life Cycle

- (instancetype)initWithContentString:(NSString *)contentString {
    self = [super init];
    if (self) {
        self.contentString = contentString;
        currencyTypeList = [[self prvt_currencyValuesToTypeMapping] allKeys];
        operationTypeList = [[self prvt_operationValuesToTypeMapping] allKeys];
    }
    
    return self;
}

#pragma mark - Interface API

- (void)grabCurrenciesValuesWithCompletionBlock:(ExchangeRateParseOperationComplete)completionBlock {
    NSMutableArray *exchangeRatesList = [@[] mutableCopy];
    TFHpple *documentForQuery = [[TFHpple alloc] initWithHTMLData:[self.contentString dataUsingEncoding:NSUnicodeStringEncoding]];
    
    for (NSString *currency in currencyTypeList) {
        for (NSString *operation in operationTypeList) {
            NSString *query = [NSString stringWithFormat:XPathQueryTemplate, currency, operation];
            NSArray *elementsList = [documentForQuery searchWithXPathQuery:query];
            if (elementsList.count) {
                NSString *value = [[elementsList[0] valueForKey:@"node"] objectForKey:@"nodeContent"];
                ExchangeRateCurrencyType currencyType = [self prvt_getCurrencyTypeFromCurrencyString:currency];
                ExchangeRateOperationType operationType = [self prvt_getOperationTypeFromOperationString:operation];
                ExchangeRate *exchangeRate = [[ExchangeRate alloc] initWithValue:value
                                                                    currencyType:currencyType
                                                                   operationType:operationType];
                [exchangeRatesList addObject:exchangeRate];
            }
        }
    }
    
    completionBlock(exchangeRatesList);
}

#pragma mark - Private

- (ExchangeRateCurrencyType)prvt_getCurrencyTypeFromCurrencyString:(NSString *)srtingValue {
    return [[[self prvt_currencyValuesToTypeMapping] objectForKey:srtingValue] integerValue];
}

- (ExchangeRateOperationType)prvt_getOperationTypeFromOperationString:(NSString *)srtingValue {
    return [[[self prvt_operationValuesToTypeMapping] objectForKey:srtingValue] integerValue];
}

- (NSDictionary *)prvt_currencyValuesToTypeMapping {
    return @{
             @"chf" :@(ExchangeRateCurrencyTypeEUR),
             @"eur" :@(ExchangeRateCurrencyTypeEUR),
             @"gbp" :@(ExchangeRateCurrencyTypeGBP),
             @"usd" :@(ExchangeRateCurrencyTypeUSD),
             };
}

- (NSDictionary *)prvt_operationValuesToTypeMapping {
    return @{
             @"buy" :@(ExchangeRateOperationTypeBuy),
             @"sell" :@(ExchangeRateOperationTypeSell)
             };
}

@end
