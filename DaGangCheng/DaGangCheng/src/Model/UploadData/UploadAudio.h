//
//  UploadAudio.h
//  DaGangCheng
//
//  Created by huaxo on 14-11-12.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadAudio : NSObject

/**
 *  上传语音
 *
 *  @param image 要上传的语音
 */
+(void)uploadWithFilePath:(NSString *)path;

/**
 *  上传语音+回调
 *
 *  @param image          要上传的语音
 *  @param completedBlock 上传完语音回调
 */
+(void)uploadWithFilePath:(NSString *)path completed:(void(^)(NSString * audioStr, NSError *error))completedBlock;

/**
 *  上传语音+进度+回调
 *
 *  @param image          要上传的语音
 *  @param completedBlock 上传语音进度
 *  @param completedBlock 上传完语音回调
 */
+(void)uploadWithFilePath:(NSString *)path progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock completed:(void(^)(NSString * audioStr, NSError *error))completedBlock;
@end
