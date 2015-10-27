//
//  ProhibitTalkView.h
//  DaGangCheng
//
//  Created by huaxo2 on 15/9/23.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProhibitTalkView;


@protocol ProhibitTalkViewDelegate <NSObject>

-(void)closeDialog:(ProhibitTalkView  *)ptView;

-(void)clickOk:(ProhibitTalkView  *)ptView;



@end

@interface ProhibitTalkView : UIView


@property(nonatomic,weak)id<ProhibitTalkViewDelegate> prohibitTalkViewDelegate;

@property (nonatomic, strong) UIView *view;


- (id)initPTView;

-(int)getMinuteBySelectTag;


@end
