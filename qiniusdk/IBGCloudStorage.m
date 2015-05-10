//
//  IBGCloudStorage.m
//  qiniusdkdemo
//
//  Created by Austin.Yang on 4/17/15.
//  Copyright (c) 2015 Austin.Yang. All rights reserved.
//

#import "IBGCloudStorage.h"

@interface IBGCloudStorage()
@property (strong, nonatomic) NSString* _app_server_domain;
@property (strong, nonatomic) NSString* _app_cloud_storage_config_cgi;
@property (strong, nonatomic) NSString* _app_upload_video_meta_cgi;

@property (strong, nonatomic) NSString* _cloud_storage_domain;
@property (strong, nonatomic) NSString* _cloud_storage_token;
@property (strong, nonatomic) QNUploadManager* _uploadManager;

@end

@implementation IBGCloudStorage

-(IBGCloudStorage* ) init{
    self._app_server_domain = @"192.168.1.217:8090";
    self._app_cloud_storage_config_cgi = @"cloudstorage/config-video";
    self._app_upload_video_meta_cgi = @"video/upload-meta";
//    self._cloud_storage_domain = @"7xilfq.com1.z0.glb.clouddn.com";
    return self;
}


-(QNUploadManager*) getSingletonUpManager{
    if ( !self._uploadManager ) {
        self._uploadManager = [[QNUploadManager alloc] init];
    }
    return self._uploadManager;
}

-(NSString *) generateUniqueContentKey{
    NSString *contentUUID = [[NSUUID UUID] UUIDString];
    return contentUUID;
}

-(void) uploadFile:(NSString *)filePath
            UserID:(NSString*) uid
          complete:(QNUpCompletionHandler)completionHandler
          progress:(QNUpProgressHandler)progressHandler
            cancel:(QNUpCancellationSignal)cancelSignal
{
    
    
    //handle the operations after config request complete successfully
    void (^config_get_success)(AFHTTPRequestOperation *operation, id responseObject) =
    ^(AFHTTPRequestOperation *operation, id responseObject){
//        NSLog(@"JSON: %@", responseObject);
        self._cloud_storage_domain = responseObject[@"cs_domain"];
        self._cloud_storage_token = responseObject[@"cs_token"];
        
        NSString* uniqId = responseObject[@"uniq_id"];
        NSString* videoKey = responseObject[@"cs_vkey"];
        
        //setup the option parameters
        QNUploadOption *qnOptConfig = [[QNUploadOption alloc] initWithMime:@""
                                                             progressHandler:progressHandler
                                                                      params:nil
                                                                    checkCrc:NO
                                                            cancellationSignal:cancelSignal];
        //process upload
        QNUploadManager *qnUpManager = [[QNUploadManager alloc] init];
        [qnUpManager putFile:filePath key:videoKey
                       token:self._cloud_storage_token
         
                    complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp){
                        NSString *requestURI = [[NSString alloc] initWithFormat:@"http://%@/%@",
                                                self._app_server_domain, self._app_upload_video_meta_cgi];
                        
                        NSDictionary* dicPost = @{@"uniq_id":uniqId, @"uid": uid};
                        
                        AFHTTPRequestOperationManager *afManager = [AFHTTPRequestOperationManager manager];
                        [afManager POST:requestURI
                           parameters:dicPost
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  // todo call the complete block for the caller
                                  NSLog(@"JSON: %@", responseObject);}
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  NSLog(@"Error: %@", error);}];
                    
                    }
         
                      option:qnOptConfig];
    };
    
    NSString *requestConfURI = [[NSString alloc] initWithFormat:@"http://%@/%@", self._app_server_domain, self._app_cloud_storage_config_cgi];
    
    AFHTTPRequestOperationManager *afManager = [AFHTTPRequestOperationManager manager];
    [afManager GET:requestConfURI parameters:nil
         success:config_get_success
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {NSLog(@"Error: %@", error);}];

   
    
    
/**
    ProtocolManager *protocolManager = [ProtocolManager sharedProtocolManager];
    
    ProtocolBase * protocol = [protocolManager ProtocolWithClass:[UploadTokenProtocol class]
                                                             Key:nil
    Success:    ^(ProtocolBase *protocol){
        UploadTokenProtocol* p = (UploadTokenProtocol*)protocol;
        self._cloud_storage_token = p._cloud_storage_token;
        self._cloud_storage_domain = p._cloud_storage_domain;
         
         //      process the upload operation
        QNUploadOption *uploadOptions = [[QNUploadOption alloc] initWithMime:@""
                                                              progressHandler:progressHandler
                                                                       params:nil checkCrc:NO cancellationSignal:cancelSignal];
        QNUploadManager *upManager = [self getSingletonUpManager];
        
        NSString* contentKey = [self generateUniqueContentKey];
        NSString* storageKey = [[NSString alloc]initWithFormat:@"%@/%@", uid, contentKey];
        
        [upManager putFile:filePath
                        key:storageKey
                      token:self._cloud_storage_token
                   complete:completionHandler option:uploadOptions];
         
     }
    Failure:    ^(ProtocolBase *protocol, NSError *error){
        #pragma todo - error handling of configuration query error
    }];
    
    [protocol startWork];
*/
}



@end
