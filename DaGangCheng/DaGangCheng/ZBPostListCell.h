//
//  ZBPostListCell.h
//  DaGangCheng
//
//  Created by huaxo on 15-3-31.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@interface ZBPostListCell : UITableViewCell

@property (nonatomic, strong) Post *post;

+ (CGFloat)getCellHeightByPost:(Post *)post;

- (void)initSubviews;
@end
