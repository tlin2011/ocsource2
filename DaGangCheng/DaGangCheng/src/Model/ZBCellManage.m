//
//  ZBCellManage.m
//  DaGangCheng
//
//  Created by huaxo on 15-4-8.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBCellManage.h"
#import "PindaoHomeNewsCell.h"
#import "ZBTiebaPostCell.h"

@implementation ZBCellManage

+ (CGFloat)cellHightWithPost:(Post *)post vcStyle:(ZBCellManageVCStyle)vcStyle {
    
    CGFloat height = 44.0;
    int style = 1;
    
    if (style == ZBCellManageStyleTieba) {
        height = [ZBTiebaPostCell getCellHeightByPost:post];
    } else {
        height = [PindaoHomeNewsCell getCellHeightByPost:post];
    }
    return height;
}

//+ (UITableViewCell *)cellWithPost:(UIViewController *)vc vcStyle:(ZBCellManageVCStyle)vcStyle delegate:(UIViewController *)delegate {
//    
//    int style = 1;
//    if (style == ZBCellManageStyleTieba) {
//        
//    }
//}

@end
