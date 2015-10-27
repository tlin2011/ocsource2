//
//  PostManagerView.h
//  DaGangCheng
//
//  Created by huaxo on 14-10-13.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZBTPostManagerView;

@protocol ZBTPostManagerViewDelegate <NSObject>

@optional
- (void)zbtPostManagerView:(ZBTPostManagerView *)view selectedButtonTitle:(NSString *)title;
@end

@interface ZBTPostManagerView : UIView
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, weak) id<ZBTPostManagerViewDelegate>delegate;

- (id)initWithButtonTitles:(NSArray *)titles imageWidth:(CGFloat)imageWidth delegate:(id<ZBTPostManagerViewDelegate>)delegate;

- (void)show;

@end
