//
//  ZBWaterfallCell.h
//  DaGangCheng
//
//  Created by huaxo on 15-2-11.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "Post.h"
#import "ApiUrl.h"
#import "UIImageView+WebCache.h"
#import "ZBWaterfallMangerView.h"

@interface ZBWaterfallCell : UIView//PSCollectionViewCell
@property (nonatomic, strong) Post *post;
- (void)showManagerView;
@end
