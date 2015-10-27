//
//  CustomWindow.h
//  UIWindowCustomTest
//
//  Created by jonesduan on 12-2-14.
//  Copyright (c) 2012年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomWindow : UIWindow {
    UIView *superView;
    UIView *backgroundView;
    UIImageView *backgroundImage;
    UIView *contentView;
    BOOL closed;
}

@property (nonatomic,retain) UIView *superView;
@property (nonatomic,retain) UIView *backgroundView;
@property (nonatomic,retain) UIImageView *backgroundImage;
@property (nonatomic,retain) UIView *contentView;

-(CustomWindow *)initWithView:(UIView *)aView;
-(void)show;
-(void)close;

@end
