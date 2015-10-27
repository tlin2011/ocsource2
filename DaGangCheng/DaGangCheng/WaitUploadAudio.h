//
//  WaitUploadAudio.h
//  DaGangCheng
//
//  Created by huaxo on 15-1-8.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WaitUploadAudio : NSObject
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, strong) NSString *audioId;
@property (nonatomic, assign) BOOL isUploadSuccess;
@end
