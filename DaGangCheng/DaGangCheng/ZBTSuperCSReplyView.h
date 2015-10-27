//
//  ZBTSuperCSReplyView.h
//  DaGangCheng
//
//  Created by huaxo on 14-12-10.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBTSuperCSReplyView : UIView
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *postId;
@property (nonatomic, weak) UIViewController *delegate;
- (void)show;
@end
