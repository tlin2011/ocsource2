//
//  KL_ImageZoomView.h
//  ShowImgDome
//
//  Created by chuliangliang on 14-9-28.
//  Copyright (c) 2014年 aikaola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDProgressView.h"
//#import "SDWebImageManagerDelegate.h"
#import "SDWebImageManager.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface KL_ImageZoomView : UIView <UIScrollViewDelegate>
{
    CGFloat viewscale;
    NSString *downImgUrl;
    
}
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) BOOL isViewing;
@property (nonatomic, retain) UIImageView *containerView;
@property (nonatomic, retain) DDProgressView *progress;

//fred
@property (nonatomic, assign) CGAffineTransform oldTransform;
@property (nonatomic, retain) MBProgressHUD *hud;

- (void)resetViewFrame:(CGRect)newFrame;
- (void)updateImage:(NSString *)imgName;
- (void)uddateImageWithUrl:(NSString *)imgUrl;

//fred 旋转图片
- (void)rotationAngle:(int)angle;
//fred 保存图片
- (void)savePicture;
@end
