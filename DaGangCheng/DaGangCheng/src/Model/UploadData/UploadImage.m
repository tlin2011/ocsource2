//
//  UploadImage.m
//  DaGangCheng
//
//  Created by huaxo on 14-11-12.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "UploadImage.h"
#import "AFNetworking.h"
#import "ApiUrl.h"

@implementation UploadImage

+(void)uploadWithImage:(UIImage *)image{
    [self uploadWithImage:image progress:nil completed:nil];
}

+(void)uploadWithImage:(UIImage *)image completed:(void (^)(NSString *, NSError *))completedBlock {
    [self uploadWithImage:image progress:nil completed:completedBlock];
}

+(void)uploadWithImage:(UIImage *)image progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock completed:(void (^)(NSString *, NSError*))completedBlock {
    
    //压缩
    NSData* imageData = UIImageJPEGRepresentation(image, 0.5);//高保真
    
    // 1. Create 'AFHTTPRequestSerializer' which will create your request.
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    // 2.Create an 'NSMutableURLRequest'.
    NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:@"POST" URLString:[ApiUrl v1UploadImage] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"0_test.jpg" fileName:@"0_test.jpg" mimeType:@"image/jpg"];
    } error:nil];
    
    //3. Create and use 'AFHTTPRequestOperationManager' to create an 'AFHTTPRequestOperation' from the 'NSMutableURLRequest' that we just created.
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer ];//需要使用JSON解析器
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //todo
        NSLog(@"upload-img  Success: %@", responseObject);
        NSDictionary* json = ( NSDictionary*) responseObject;
        int imgId = [((NSNumber*)[json valueForKey:@"ret"]) intValue] ? [(NSNumber*)[json valueForKey:@"img_id"] intValue]:0;
        
        //NSString *txtdesc = [NSString stringWithFormat:@"上传成功 (大小:%.1fK) 图片ID:%d",((float)imgSize/1024),imgId];
        NSString *imageStr = [NSString stringWithFormat:@"[img:%d]",imgId];
        completedBlock(imageStr, nil);

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
