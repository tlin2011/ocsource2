//
//  SubReplyBoxView.h
//  DaGangCheng
//
//  Created by huaxo on 15-1-19.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBTFaceScrollView.h"
#import "ZBTFaceImage.h"

@interface SubReplyBoxView : UIView <ZBTFaceScrollViewDelegate>
@property (nonatomic, weak) UIViewController *delegate;
@property (nonatomic, strong) UIButton *faceBtn;
@property (nonatomic, strong) UIButton *keyboardBtn;
@property (nonatomic, strong) UITextView *contentTV;

@end
