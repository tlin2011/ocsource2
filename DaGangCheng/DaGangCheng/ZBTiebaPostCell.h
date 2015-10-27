//
//  ZBTiebaPostCell.h
//  DaGangCheng
//
//  Created by huaxo on 15-3-31.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBPostListCell.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "ApiUrl.h"
#import "ZBPostListButton.h"
#import "UIImage+Color.h"
#import "PostLockedSQL.h"
#import "ZBNumberUtil.h"

@interface ZBTiebaPostCell : ZBPostListCell
@property (nonatomic, strong) UIImageView *tagImgView;
@property (nonatomic, strong) UIButton *headBtn;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) ZBPostListButton *browseBtn;
@property (nonatomic, strong) UILabel *postTitleLab;
@property (nonatomic, strong) NSMutableArray *imgs;
@property (nonatomic, strong) ZBPostListButton *praiseBtn;
@property (nonatomic, strong) ZBPostListButton *replyBtn;
@property (nonatomic, strong) UIImageView *lineImgView;
@property (nonatomic, strong) UIImageView *bottomLineImgView;

@end
