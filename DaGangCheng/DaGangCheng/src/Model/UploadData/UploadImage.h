//
//  uploadImage.h
//  DaGangCheng
//
//  Created by huaxo on 14-11-12.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadImage : NSObject

/**
 *  上传图片
 *
 *  @param image 要上传的图片
 */
+(void)uploadWithImage:(UIImage *)image;

/**
 *  上传图片+回调
 *
 *  @param image          要上传的图片
 *  @param completedBlock 上传完图片回调
 */
+(void)uploadWithImage:(UIImage *)image completed:(void(^)(NSString * imageStr, NSError *error))completedBlock;

/**
 *  上传图片+进度+回调
 *
 *  @param image          要上传的图片
 *  @param completedBlock 上传图片进度
 *  @param completedBlock 上传完图片回调
 */
+(void)uploadWithImage:(UIImage *)image progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock completed:(void(^)(NSString * imageStr, NSError *error))completedBlock;
@end
