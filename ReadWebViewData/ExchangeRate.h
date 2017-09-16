//
//  ExchangeRate.h
//  ReadWebViewData
//
//  Created by Dmitry on 15.09.17.
//  Copyright © 2017 Evstratov Dmitry. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ExchangeRateCurrencyType) {
    ExchangeRateCurrencyTypeCHF,
    ExchangeRateCurrencyTypeEUR,
    ExchangeRateCurrencyTypeGBP,
    ExchangeRateCurrencyTypeUSD
};

typedef NS_ENUM(NSInteger, ExchangeRateOperationType) {
    ExchangeRateOperationTypeBuy,
    ExchangeRateOperationTypeSell,
};

@interface ExchangeRate : NSObject

@property (nonatomic, assign, readonly) NSString *value;
@property (nonatomic, assign, readonly) ExchangeRateCurrencyType currencyType;
@property (nonatomic, assign, readonly) ExchangeRateOperationType operationType;

- (instancetype)initWithValue:(NSString *)value
                 currencyType:(ExchangeRateCurrencyType)currencyType
                operationType:(ExchangeRateOperationType)operationType;

- (NSDictionary *)dictionarySerialize;

@end
