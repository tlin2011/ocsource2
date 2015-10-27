//
//  ZBCellManage.h
//  DaGangCheng
//
//  Created by huaxo on 15-4-8.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Post.h"

typedef NS_ENUM(NSInteger, ZBCellManageStyle) {
    ZBCellManageStyleNews = 0,                  // 新闻cell
    ZBCellManageStyleTieba                // 贴吧cell
};

typedef NS_ENUM(NSInteger, ZBCellManageVCStyle) {
    ZBCellManageVCStyleHot,                  // 热点
    ZBCellManageVCStyleGeneral                // 普通
};

@interface ZBCellManage : NSObject

+ (CGFloat)cellHightWithPost:(Post *)post vcStyle:(ZBCellManageVCStyle)vcStyle;

//+ (UITableViewCell *)cellWithPost:(UIViewController *)vc vcStyle:(ZBCellManageVCStyle)vcStyle delegate:(UIViewController *)delegate;

@end
