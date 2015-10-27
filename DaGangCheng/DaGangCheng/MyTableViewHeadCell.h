//
//  MyTableViewHeadCell.h
//  DaGangCheng
//
//  Created by huaxo on 15-7-22.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewHeadCell : UITableViewCell

@property (assign, nonatomic) int64_t userImageID;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) int64_t UID;
@property (copy  , nonatomic) NSString *phoneNumber;
@property (assign, nonatomic) BOOL isLogined;

@property (strong, nonatomic) UIImageView *headView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *UIDLabel;
@property (strong, nonatomic) UILabel *phoneLabel;

- (void)updateUI;
+ (CGFloat)heightWithCell;
@end
