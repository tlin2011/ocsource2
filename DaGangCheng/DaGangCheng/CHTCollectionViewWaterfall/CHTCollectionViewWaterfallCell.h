//
//  UICollectionViewWaterfallCell.h
//  Demo
//
//  Created by Nelson on 12/11/27.
//  Copyright (c) 2012年 Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "ApiUrl.h"
#import "UIImageView+WebCache.h"
#import "ZBWaterfallMangerView.h"
#import "ZBNumberUtil.h"

@class CHTCollectionViewWaterfallCell;

@protocol CHTCollectionViewWaterfallCellDelegate <NSObject>

- (void)collectionViewWaterfallCellDidClicked:(CHTCollectionViewWaterfallCell *)cell;
- (void)collectionViewWaterfallCellDidLongPressed:(CHTCollectionViewWaterfallCell *)cell;

@end

@interface CHTCollectionViewWaterfallCell : UICollectionViewCell

@property (nonatomic, weak) id<CHTCollectionViewWaterfallCellDelegate>delegate;

@property (nonatomic, strong) Post *post;
- (void)showManagerView;
@end
