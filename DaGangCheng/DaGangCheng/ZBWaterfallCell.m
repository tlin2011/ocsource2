//
//  ZBWaterfallCell.m
//  DaGangCheng
//
//  Created by huaxo on 15-2-11.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBWaterfallCell.h"

@interface ZBWaterfallCell ()
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *head;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *lookNumView;
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, weak)   UIView *managerView;
@end

@implementation ZBWaterfallCell

- (void)initSubviews {
    //[super initSubviews];
    
    self.backgroundColor = UIColorFromRGB(0xeceff2);

    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:10];
    self.timeLabel.textColor = UIColorFromRGB(0xabadb1);
    [self addSubview:self.timeLabel];
    
    self.bgView = [[UIImageView alloc] init];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.cornerRadius = 4;
    self.bgView.layer.borderColor = UIColorFromRGB(0xb5b5b6).CGColor;
    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.clipsToBounds = YES;
    [self addSubview:self.bgView];
    
    self.imageView = [[UIImageView alloc] init];
    [self.bgView addSubview:self.imageView];
    
    self.head = [[UIImageView alloc] init];
    self.head.layer.cornerRadius = 8;
    self.head.layer.masksToBounds = YES;
    [self addSubview:self.head];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:self.nameLabel];
    
    self.lookNumView = [[UIImageView alloc] init];
    [self addSubview:self.lookNumView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    //
    self.timeLabel.frame = CGRectMake(0, 0 , frame.size.width, 20);
    self.timeLabel.text = self.post.createTime;
    
    //
    self.bgView.frame = CGRectMake(0, 20, frame.size.width, frame.size.height-20);
    
    //图片
    self.imageView.frame = CGRectMake(0, 0, self.bgView.frame.size.width, self.bgView.frame.size.height-25);
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:self.post.preImageId w:self.imageView.bounds.size.width*2]] placeholderImage:[UIImage imageNamed:@"default_bg.png"]];
    //
    self.head.frame = CGRectMake(5, frame.size.height-5-16 , 16, 16);
    [self.head sd_setImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:self.post.userImageId w:self.head.bounds.size.width*2]] placeholderImage:[UIImage imageNamed:@"nm.png"]];
    //
    self.nameLabel.frame = CGRectMake(28, frame.size.height-25, frame.size.width-28-5, 25);
    self.nameLabel.text = self.post.title;
    
}

- (void)showManagerView {
    CGRect frame = self.frame;
    CGRect managerFrame = CGRectMake(0, frame.size.height-32-25, frame.size.width, 32);
    ZBWaterfallMangerView *managerView = [ZBWaterfallMangerView sharedManager];
    managerView.frame = managerFrame;
    managerView.post = self.post;
    [self addSubview:managerView];
    self.managerView = managerView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
