//
//  MyProfileTableViewCell.h
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/6.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyProfileTableViewCell : UITableViewCell


typedef NS_ENUM(NSInteger, MyProfileTabelViewCellType) {
    MyProfileTabelViewCellText = 0,
    MyProfileTabelViewCellImage = 1
};


@property (assign, nonatomic) int64_t userImageID;

//标签
@property (nonatomic, strong) UILabel *myLabel;

//对应的文本
@property (nonatomic, strong) UILabel *myValLabel;

//对应的图片
@property (nonatomic, strong) UIImageView *myHeaderImage;


//对应类型
@property (nonatomic) MyProfileTabelViewCellType cellType;


-(void)initMyProfileCell;


@end
