//
//  ExchangeRateParser.h
//  ReadWebViewData
//
//  Created by Dmitry on 15.09.17.
//  Copyright © 2017 Evstratov Dmitry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExchangeRate.h"

typedef void (^ExchangeRateParseOperationComplete) (NSArray *valuesList);

@interface ExchangeRateParser : NSObject

- (instancetype)initWithContentString:(NSString *)contentString;
- (void)grabCurrenciesValuesWithCompletionBlock:(ExchangeRateParseOperationComplete)completionBlock;

@end
