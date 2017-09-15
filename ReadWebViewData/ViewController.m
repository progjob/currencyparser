//
//  ViewController.m
//  ReadWebViewData
//
//  Created by Evstratov Dmitry on 12.09.17.
//  Copyright © 2017 Evstratov Dmitry. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

#import "ExchangeRateParser.h"
#import "DataUploader.h"

static NSString * const loadDataBaseUrl = @"https://alfabank.ru/currency/";
static NSString * const getDomTreejavaScriptCode = @"document.documentElement.outerHTML.toString()";
static NSString * const buttonTitleForLoadData = @"Загрузить страницу";
static NSString * const buttonTitleForSendData = @"Отправить данные";

@interface ViewController () <WKNavigationDelegate>

@property (weak, nonatomic) IBOutlet UIView *webViewContainer;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *mainButton;

@property (nonatomic, strong) WKWebView *wkWebView;
@property (assign, nonatomic, getter=isWebDataLoaded) BOOL webDataLoaded;

@end

@implementation ViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prvt_tuneMainButton];
    [self prvt_tuneWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (void)loadData:(id)sender {
    [self.activityIndicator startAnimating];
    [self prvt_setTitleForButton];

    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:loadDataBaseUrl]]];
}

- (void)uploadData:(id)sender {
    [self prvt_sendCurrenciesValues];
}

#pragma mark - UIWebViewDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.webDataLoaded = YES;
    [self.activityIndicator stopAnimating];
    [self prvt_tuneMainButton];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    self.webDataLoaded = NO;
    [self.activityIndicator stopAnimating];
    [self prvt_tuneMainButton];
}

#pragma mark - Private

- (void)prvt_sendCurrenciesValues {
    [self.wkWebView evaluateJavaScript:getDomTreejavaScriptCode
                     completionHandler:^(NSString * _Nullable content, NSError * _Nullable error) {
                         ExchangeRateParser *exchangeRateParser = [[ExchangeRateParser alloc] initWithContentString:content];
                         [exchangeRateParser grabCurrenciesValuesWithCompletionBlock:^(NSArray *valuesList) {
                             
//                             NSLog(@"%@", valuesList);
                             DataUploader* dataUploader = [[DataUploader alloc] init];
                             [dataUploader uploadData];
                             
                         }];
                     }];
}

- (void)prvt_tuneWebView {
    self.wkWebView = [[WKWebView alloc] initWithFrame:self.webViewContainer.frame];
    [self.webViewContainer addSubview:self.wkWebView];
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight + UIViewAutoresizingFlexibleWidth;
}

- (void)prvt_tuneMainButton {
    [self prvt_setTitleForButton];
    [self prvt_setActionForButton];
}

- (void)prvt_setTitleForButton {
    NSString *title = !self.isWebDataLoaded ? buttonTitleForLoadData : buttonTitleForSendData;
    if (self.activityIndicator.isAnimating) {
        title = @"";
    }
    
    [self.mainButton setTitle:title
                     forState:UIControlStateNormal];
}

- (void)prvt_setActionForButton {
    SEL previousAction = self.isWebDataLoaded ? @selector(loadData:) : @selector(uploadData:);
    [self.mainButton removeTarget:self
                           action:previousAction
                 forControlEvents:UIControlEventTouchUpInside];
    
    SEL actualAction = !self.isWebDataLoaded ? @selector(loadData:) : @selector(uploadData:);
    [self.mainButton addTarget:self
                        action:actualAction
              forControlEvents:UIControlEventTouchUpInside];
}

@end
