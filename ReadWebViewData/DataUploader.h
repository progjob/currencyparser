//
//  DataUploader.h
//  ReadWebViewData
//
//  Created by Dmitry on 16.09.17.
//  Copyright © 2017 Evstratov Dmitry. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DataUploaderOperationComplete)(void);

@interface DataUploader : NSObject

- (void)uploadData:(id)uploadData
withCompetionBlock:(DataUploaderOperationComplete)completion;

@end
