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

static NSString * const loadDataBaseUrl = @"https://alfabank.ru/about/";

static NSString * const uploadDataBaseUrl = @"https://alfabank.ru/about/";

static NSString * const buttonTitleForLoadData = @"Загрузить страницу";
static NSString * const buttonTitleForSendData = @"Отправить данные";

@interface ViewController ()

@property (nonatomic, strong) TFHpple *doc;

@property (nonatomic, strong) WKWebView *wkWebView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *mainButton;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (assign, nonatomic, getter=isWebDataLoaded) BOOL webDataLoaded;

@end

@implementation ViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.activityIndicator.hidesWhenStopped = YES;
    [self tuneMainButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (void)loadData:(id)sender {
    [self.activityIndicator startAnimating];
    [self prvt_setTitleForButton];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:loadDataBaseUrl]]];
}

- (void)uploadData:(id)sender {
    NSLog(@"uploadData");
    
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.webDataLoaded = YES;
    [self.activityIndicator stopAnimating];
    [self tuneMainButton];

    NSLog(@"loaded");
    
//    NSCachedURLResponse* response = [[NSURLCache sharedURLCache] cachedResponseForRequest:[webView request]];
//    NSData* data = [response data];
//    TFHpple *doc       = [[TFHpple alloc] initWithHTMLData:data];
//    NSArray *elements  = [doc searchWithXPathQuery:@"//div[@class='promo-block-inner']"];
//    TFHppleElement *el = [elements objectAtIndex:0];
//    NSDictionary *dic = [el valueForKey:@"node"];
//    NSString *cont = [dic objectForKey:@"nodeContent"];
//    NSLog(@"cont = [%@]", cont);
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

@end
