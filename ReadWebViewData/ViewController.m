//
//  ViewController.m
//  ReadWebViewData
//
//  Created by Evstratov Dmitry on 12.09.17.
//  Copyright © 2017 Evstratov Dmitry. All rights reserved.
//

#import "ViewController.h"

#import <WebKit/WebKit.h>
#import "TFHpple.h"

static NSString * const loadDataBaseUrl = @"https://alfabank.ru/currency/";
static NSString * const buttonTitleForLoadData = @"Загрузить страницу";
static NSString * const buttonTitleForSendData = @"Отправить данные";

static NSString * const XPathQueryTemplate = @"//tr[@class='tr %@']/td[@class='type %@']";
static const NSArray *currencyList;
static const NSArray *modeList;

@interface ViewController () <WKNavigationDelegate>

@property (nonatomic, strong) TFHpple *doc;

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

    currencyList = @[@"usd", @"eur", @"gbp", @"chf"];
    modeList = @[@"buy", @"sell"];

    
    self.activityIndicator.hidesWhenStopped = YES;
    [self tuneMainButton];
    
    self.wkWebView = [[WKWebView alloc] initWithFrame:self.webViewContainer.bounds];
    [self.webViewContainer addSubview:self.wkWebView];
    self.wkWebView.navigationDelegate = self;
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
    [self prvt_parseDataFromWebViewContent];
}

#pragma mark - UIWebViewDelegate

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    self.webDataLoaded = NO;
    [self.activityIndicator stopAnimating];
    [self tuneMainButton];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.webDataLoaded = YES;
    [self.activityIndicator stopAnimating];
    [self tuneMainButton];
}

#pragma mark - Private

- (void)tuneMainButton {
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

- (void)prvt_parseDataFromWebViewContent {
    NSString *jsCode = @"document.documentElement.outerHTML.toString()";
    [self.wkWebView evaluateJavaScript:jsCode
                     completionHandler:^(NSString * _Nullable result, NSError * _Nullable error) {
                         
                         NSData *nsdata = [result dataUsingEncoding:NSUnicodeStringEncoding];
                         TFHpple *documentForQuery = [[TFHpple alloc] initWithHTMLData:nsdata];
                         NSMutableDictionary *parseResult = [@{} mutableCopy];
                         
                         for (NSString *currency in currencyList) {
                             parseResult[currency] = [@{} mutableCopy];
                             
                             for (NSString *mode in modeList) {
                                 NSString *query = [NSString stringWithFormat:XPathQueryTemplate, currency, mode];
                                 NSArray *elementsList = [documentForQuery searchWithXPathQuery:query];
                                 if (elementsList.count) {
                                     TFHppleElement *element = [elementsList objectAtIndex:0];
                                     NSDictionary *dic = [element valueForKey:@"node"];
                                     NSString *content = [dic objectForKey:@"nodeContent"];
                                     [parseResult[currency] setValue:content forKey:mode];
                                 }
                             }
                         }
                         
                         NSLog(@"%@", parseResult);
                     }];
}

@end
