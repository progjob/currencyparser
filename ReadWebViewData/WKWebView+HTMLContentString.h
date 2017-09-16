//
//  WKWebView+HTMLContentString.h
//  ReadWebViewData
//
//  Created by Dmitry on 16.09.17.
//  Copyright © 2017 Evstratov Dmitry. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WKWebView (HTMLContentString)

- (void)parseContentWithComletion:(void (^ _Nullable)(_Nullable id content, NSError * _Nullable error))completionHandler;

@end
