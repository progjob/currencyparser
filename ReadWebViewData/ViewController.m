//
//  ViewController.m
//  ReadWebViewData
//
//  Created by Evstratov Dmitry on 12.09.17.
//  Copyright © 2017 Evstratov Dmitry. All rights reserved.
//

#import "ViewController.h"

#import <WebKit/WebKit.h>
#import "WKWebView+HTMLContentString.h"

#import "ExchangeRateParser.h"
#import "DataLoader.h"
#import "DataUploader.h"

static NSString * const buttonTitleForWaitingData = @"";
static NSString * const buttonTitleForLoadData = @"Load Data";
static NSString * const buttonTitleForUploadData = @"Upload Data";

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

- (void)loadData {
    [self.activityIndicator startAnimating];
    [self prvt_tuneMainButton];

    DataLoader *dataLoader = [[DataLoader alloc] init];
    [dataLoader loadWebContentWithCompetionBlock:^(NSData *data, NSString *MIMEType, NSString *characterEncodingName, NSURL *baseURL) {
        [self.wkWebView loadData:data
                        MIMEType:MIMEType
           characterEncodingName:characterEncodingName
                         baseURL:baseURL];
    }];
}

- (void)uploadData {
    [self.wkWebView parseContentWithComletion:^(id  _Nullable content, NSError * _Nullable error) {
        ExchangeRateParser *exchangeRateParser = [[ExchangeRateParser alloc] initWithContentString:content];
        [exchangeRateParser grabCurrenciesValuesWithCompletionBlock:^(NSArray *valuesList) {
            DataUploader* dataUploader = [[DataUploader alloc] init];
            [dataUploader uploadData:valuesList
                  withCompetionBlock:^{
                      
                      NSLog(@"Data Uploaded Successfully");
                      
                  }];
        }];
    }];
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
    NSString *title = !self.isWebDataLoaded ? buttonTitleForLoadData : buttonTitleForUploadData;
    if (self.activityIndicator.isAnimating) {
        title = buttonTitleForWaitingData;
    }
    
    [self.mainButton setTitle:title
                     forState:UIControlStateNormal];
}

- (void)prvt_setActionForButton {
    SEL previousAction = self.isWebDataLoaded ? @selector(loadData) : @selector(uploadData);
    [self.mainButton removeTarget:self
                           action:previousAction
                 forControlEvents:UIControlEventTouchUpInside];
    
    SEL actualAction = !self.isWebDataLoaded ? @selector(loadData) : @selector(uploadData);
    [self.mainButton addTarget:self
                        action:actualAction
              forControlEvents:UIControlEventTouchUpInside];
}

@end
