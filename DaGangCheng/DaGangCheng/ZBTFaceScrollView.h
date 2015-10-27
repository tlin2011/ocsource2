//
//  ZBTFaceScrollView.h
//  DaGangCheng
//
//  Created by huaxo on 15-1-9.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZBTFaceScrollView;

@protocol ZBTFaceScrollViewDelegate <NSObject>

- (void)faceScrollView:(ZBTFaceScrollView *)faceView selectedFaceName:(NSString *)faceName;
- (void)faceScrollView:(ZBTFaceScrollView *)faceView selectedDeleteButton:(UIButton *)deleBtn;

@end


@interface ZBTFaceScrollView : UIView <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, weak) id<ZBTFaceScrollViewDelegate>delegate;
@end
