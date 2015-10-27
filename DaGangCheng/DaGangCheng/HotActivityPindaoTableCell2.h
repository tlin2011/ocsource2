//
//  HotActivityPindaoTableCell2.h
//  DaGangCheng
//
//  Created by huaxo on 15-3-27.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "ApiUrl.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "PostLockedSQL.h"

@interface HotActivityPindaoTableCell2 : UITableViewCell

@property (nonatomic, strong) UILabel *postTitleLabel;
@property (nonatomic, strong) Post * dataSource;
@property (nonatomic, strong) UIButton *managerBtn;

+ (CGFloat)getCellHeightByPost:(Post *)post;


- (void)initSubviews;
- (void)layoutSubviews;

- (void)lockedByPost:(Post *)post;
- (void)postTitleColorByLocked:(BOOL)lock;
@end
