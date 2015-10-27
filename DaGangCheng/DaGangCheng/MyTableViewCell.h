//
//  MyTableViewCell.h
//  DaGangCheng
//
//  Created by huaxo on 15-7-16.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImage *image;
@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) UIImageView *line;

- (void)updateUI;
+ (CGFloat)heightWithCell;
@end
