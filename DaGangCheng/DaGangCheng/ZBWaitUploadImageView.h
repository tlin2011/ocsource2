//
//  ZBWaitUploadImageView.h
//  DaGangCheng
//
//  Created by huaxo on 15-3-3.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaitUploadImage.h"
#import "UploadImage.h"

@class ZBWaitUploadImageView;

@protocol ZBWaitUploadImageViewDelegate <NSObject>

@optional
//添加图片
- (void)waitUploadImageviewDidClickedAddPhotoBtn;
//删除图片
- (void)waitUploadImageviewDidRemovedPhotoBtn;

@end

@interface ZBWaitUploadImageView : UIView
@property (nonatomic, weak) id<ZBWaitUploadImageViewDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *imageList;
@property (nonatomic, assign, readonly) CGSize contentSize;

- (void)addImageOnView:(WaitUploadImage *)uploadImage;
@end
