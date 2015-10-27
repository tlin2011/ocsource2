//
//  WaitUploadImageView.h
//  DaGangCheng
//
//  Created by huaxo on 14-11-12.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaitUploadImage.h"
#import "UploadImage.h"

@class WaitUploadImageView;

@protocol WaitUploadImageDelegate <NSObject>

- (void)waitUploadImageViewdidClickedAddPhotoBtn;

@end


@interface WaitUploadImageView : UIView
@property (nonatomic, weak) id<WaitUploadImageDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *imageList;

- (void)addImageOnView:(WaitUploadImage *)uploadImage;
@end
