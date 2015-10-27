//
//  HotActivityPindaoTableCell3.h
//  DaGangCheng
//
//  Created by huaxo on 15-4-9.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBPostListCell.h"
#import "ApiUrl.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "ZBNumberUtil.h"

@interface HotActivityPindaoTableCell3 : ZBPostListCell
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *tagLab;
@property (nonatomic, strong) UILabel *postTitleLab;
@property (nonatomic, strong) UILabel *activityTimeLab;
@property (nonatomic, strong) UIImageView *postImgView;
@property (nonatomic, strong) UILabel *pindaoNameLab;
@property (nonatomic, strong) UILabel *prosonsLab;
@property (nonatomic, strong) UILabel *joinLab;
@property (nonatomic, strong) UIImageView *bgView;
@end
