//
//  DrawPictureView.h
//  DaGangCheng
//
//  Created by huaxo on 14-11-13.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DrawPictureView;

@protocol DrawPictureDelegate <NSObject>

- (void)drawPictureView:(DrawPictureView *)view uploadImage:(UIImage *)image;

@end

@interface DrawPictureView : UIView

@property (nonatomic, weak) id<DrawPictureDelegate>delegate;

@end
