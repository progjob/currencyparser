//
//  ExchangeRate.m
//  ReadWebViewData
//
//  Created by Dmitry on 15.09.17.
//  Copyright © 2017 Evstratov Dmitry. All rights reserved.
//

#import "ExchangeRate.h"

@interface ExchangeRate ()

@property (nonatomic, assign, readwrite) NSString *value;
@property (nonatomic, assign, readwrite) ExchangeRateCurrencyType currencyType;
@property (nonatomic, assign, readwrite) ExchangeRateOperationType operationType;

@end

@implementation ExchangeRate

- (instancetype)initWithValue:(NSString *)value
                 currencyType:(ExchangeRateCurrencyType)currencyType
                operationType:(ExchangeRateOperationType)operationType {
    self = [super init];
    if (self) {
        self.value = value;
        self.currencyType = currencyType;
        self.operationType = operationType;
    }
    
    return self;
}

- (NSDictionary *)dictionarySerialize {
    return @{
             @"value" : self.value,
             @"currency" : [self prvt_currencyTypeToString],
             @"operation" : [self prvt_operationTypeToString],
            };
}

#pragma mark - Private

- (NSString *)prvt_currencyTypeToString {
    return [@{
              @(ExchangeRateCurrencyTypeCHF) : @"swiss frank",
              @(ExchangeRateCurrencyTypeEUR) : @"euro",
              @(ExchangeRateCurrencyTypeGBP) : @"ound sterling",
              @(ExchangeRateCurrencyTypeUSD) : @"dollar"
              } objectForKey:[NSNumber numberWithUnsignedInteger:self.operationType]];
}


- (NSString *)prvt_operationTypeToString {
    return [@{
              @(ExchangeRateOperationTypeBuy) : @"buy",
              @(ExchangeRateOperationTypeSell ) : @"sell"
              } objectForKey:[NSNumber numberWithUnsignedInteger:self.operationType]];
}

@end
