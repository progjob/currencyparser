//
//  DataLoader.h
//  ReadWebViewData
//
//  Created by Dmitry on 16.09.17.
//  Copyright © 2017 Evstratov Dmitry. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DataLoaderOperationComplete)(NSData *data, NSString *MIMEType, NSString *characterEncodingName, NSURL *baseURL);

@interface DataLoader : NSObject

- (void)loadDataWithCompetionBlock:(DataLoaderOperationComplete)completion;

@end
