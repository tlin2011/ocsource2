//
//  PindaoHomeNewsCell.h
//  DaGangCheng
//
//  Created by huaxo on 14-10-21.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "ApiUrl.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "PostLockedSQL.h"
#import "ZBPostListCell.h"
#import "ZBNumberUtil.h"


@interface PindaoHomeNewsCell : ZBPostListCell
@property (nonatomic, strong) UILabel *postTitleLabel;
@property (nonatomic, strong) Post * dataSource;
@property (nonatomic, strong) UIButton *managerBtn;


- (void)initSubviews;
- (void)layoutSubviews;

- (void)lockedByPost:(Post *)post;
- (void)postTitleColorByLocked:(BOOL)lock;
@end
