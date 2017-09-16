//
//  WKWebView+HTMLContentString.m
//  ReadWebViewData
//
//  Created by Dmitry on 16.09.17.
//  Copyright © 2017 Evstratov Dmitry. All rights reserved.
//

#import "WKWebView+HTMLContentString.h"

static NSString * const getDomTreejavaScriptCode = @"document.documentElement.outerHTML.toString()";

@implementation WKWebView (HTMLContentString)

- (void)parseContentWithComletion:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler {
    [self evaluateJavaScript:getDomTreejavaScriptCode
           completionHandler:^(NSString * _Nullable content, NSError * _Nullable error) {
               completionHandler(content, error);
           }];
}

@end
