//
//  DataLoader.m
//  ReadWebViewData
//
//  Created by Dmitry on 16.09.17.
//  Copyright © 2017 Evstratov Dmitry. All rights reserved.
//

#import "DataLoader.h"

static NSString * const loadDataBaseUrl = @"https://alfabank.ru/currency/";

@implementation DataLoader

- (void)loadData {
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:loadDataBaseUrl]];
    request.HTTPMethod = @"GET";
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
                                                    
                                                    NSLog(@"load end");
                                                }];
    [dataTask resume];
}

@end
