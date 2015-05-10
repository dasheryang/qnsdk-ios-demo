//
//  IBGCloudStorage.h
//  qiniusdkdemo
//
//  Created by Austin.Yang on 4/17/15.
//  Copyright (c) 2015 Austin.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QiniuSDK.h>
#import <AFNetworking/AFNetworking.h>

@interface IBGCloudStorage : NSObject

-(void) uploadFile:(NSString *)filePath
            UserID:(NSString*) uid
          complete:(QNUpCompletionHandler)completionHandler
          progress:(QNUpProgressHandler)progressHandler
            cancel:(QNUpCancellationSignal)cancelSignal;


-(NSString *) getResourceURLStringByKey: (NSString *)key;

@end
