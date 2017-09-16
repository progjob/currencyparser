//
//  DataUploader.m
//  ReadWebViewData
//
//  Created by Dmitry on 16.09.17.
//  Copyright © 2017 Evstratov Dmitry. All rights reserved.
//

#import "DataUploader.h"
static NSString * const uploadDataBaseUrl = @"http://localHost:8080/uploadData";

@implementation DataUploader

- (void)uploadData:(id)uploadData
withCompetionBlock:(DataUploaderOperationComplete)completion {
    NSURL *url = [NSURL URLWithString:uploadDataBaseUrl];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSError *error = nil;
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:uploadData
                                                   options:kNilOptions
                                                     error:&error];
    if (!error) {
        NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                                   fromData:data
                                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                              completion();
                                                          }];
        [uploadTask resume];
    }
}

@end
