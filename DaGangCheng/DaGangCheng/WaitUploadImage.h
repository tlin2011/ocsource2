//
//  WaitUploadImage.h
//  DaGangCheng
//
//  Created by huaxo on 14-11-12.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WaitUploadImage : NSObject
@property (nonatomic, strong) UIButton *imageBtn;
@property (nonatomic, strong) NSString *imageId;
@property (nonatomic, strong) UIImage *smallImage;
@property (nonatomic, strong) UIImage *fullImage;
@property (nonatomic, assign) BOOL isUploadSuccess;
@end
