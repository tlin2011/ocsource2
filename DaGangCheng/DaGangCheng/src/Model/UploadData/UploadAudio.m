//
//  UploadAudio.m
//  DaGangCheng
//
//  Created by huaxo on 14-11-12.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "UploadAudio.h"

#import "AFNetworking.h"
#import "ApiUrl.h"

@interface UploadAudio ()

@end

@implementation UploadAudio

+ (void)uploadWithFilePath:(NSString *)path {
    [self uploadWithFilePath:path progress:nil completed:nil];
}

+ (void)uploadWithFilePath:(NSString *)path completed:(void (^)(NSString *, NSError *))completedBlock {
    [self uploadWithFilePath:path progress:nil completed:completedBlock];
}

+ (void)uploadWithFilePath:(NSString *)path progress:(void (^)(NSUInteger, long long, long long))progressBlock completed:(void (^)(NSString *, NSError *))completedBlock {
    
    //
    NSData* audioData = [NSData dataWithContentsOfFile:path];
    NSString *fileName = [path lastPathComponent];
    
    // 1. Create 'AFHTTPRequestSerializer' which will create your request.
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    // 2.Create an 'NSMutableURLRequest'.
    NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:@"POST" URLString:[ApiUrl v1UploadAudio] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:audioData name:fileName fileName:fileName mimeType:@"audio"];
    } error:nil];
    
    //3. Create and use 'AFHTTPRequestOperationManager' to create an 'AFHTTPRequestOperation' from the 'NSMutableURLRequest' that we just created.
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer ];//需要使用JSON解析器
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //todo
        NSLog(@"upload-audio  Success: %@", responseObject);
        NSDictionary* json = ( NSDictionary*) responseObject;
        int audioId = [[json valueForKey:@"ret"] intValue] ? [[json valueForKey:@"audio_id"] intValue]:0;
        int audioLen = [[json valueForKey:@"ret"] intValue] ? [[json valueForKey:@"xlen"] intValue]:0;
        
        NSString *str = [NSString stringWithFormat:@"\n[yy:%d:%d]\n",audioId,audioLen];
        completedBlock(str, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //todo
        completedBlock(nil, error);
        NSLog(@"upload-img  Error: %@", error);
        
    }];
    
    // 4.Set the progress block of the operation.
    [operation setUploadProgressBlock:progressBlock];
    
    // 5.Begin!
    [operation start];

}

@end