//
//  UICollectionViewWaterfallCell.m
//  Demo
//
//  Created by Nelson on 12/11/27.
//  Copyright (c) 2012年 Nelson. All rights reserved.
//

#import "CHTCollectionViewWaterfallCell.h"

@interface CHTCollectionViewWaterfallCell ()
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *head;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *lookNumView;
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *praiseBg;
@property (nonatomic, strong) UIImageView *praiseTriIv;
@property (nonatomic, strong) UILabel *praiseNumLab;
@property (nonatomic, weak)   UIView *managerView;
@end

@implementation CHTCollectionViewWaterfallCell

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
      //
      [self initSubviews];
  }
  return self;
}

- (void)initSubviews {
    //[super initSubviews];
    
    self.backgroundColor = UIColorFromRGB(0xeceff2);
    
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:10];
    self.timeLabel.textColor = UIColorFromRGB(0xabadb1);
    [self addSubview:self.timeLabel];
    
    self.bgView = [[UIImageView alloc] init];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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
    
    self.praiseBg = [[UIImageView alloc] init];
    [self addSubview:self.praiseBg];
    
    self.praiseNumLab = [[UILabel alloc] init];
    self.praiseNumLab.font = [UIFont systemFontOfSize:10];
    self.praiseNumLab.textColor = [UIColor whiteColor];
    self.praiseNumLab.textAlignment = NSTextAlignmentCenter;
    self.praiseNumLab.layer.cornerRadius = 2.0f;
    self.praiseNumLab.layer.masksToBounds = YES;
    self.praiseNumLab.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.praiseBg addSubview:self.praiseNumLab];
    
    self.praiseTriIv = [[UIImageView alloc] init];
    [self.praiseTriIv setImage:[UIImage imageNamed:@"瀑布流_浏览图-小尾巴.png"]];
    self.praiseTriIv.contentMode = UIViewContentModeScaleAspectFit;
    [self.praiseBg addSubview:self.praiseTriIv];
    
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(press:)];
    [self addGestureRecognizer:press];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
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
    NSString *imageIDStr = [self.post.imageList firstObject];
    NSString *imageUrlStr = [ApiUrl getImageUrlStrFromID:[imageIDStr integerValue] w:self.imageView.bounds.size.width*2];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:[UIImage imageNamed:@"default_bg.png"]];
    //
    self.head.frame = CGRectMake(5, frame.size.height-5-16 , 16, 16);
    [self.head sd_setImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:self.post.userImageId w:self.head.bounds.size.width*2]] placeholderImage:[UIImage imageNamed:@"nm.png"]];
    //
    self.nameLabel.frame = CGRectMake(28, frame.size.height-25, frame.size.width-28-5, 25);
    self.nameLabel.text = self.post.title;
    
    //浏览数
    NSString *read = [ZBNumberUtil shortStringByInteger:self.post.readNum];
    CGSize praiseNumSize = [read sizeWithFont:self.praiseNumLab.font forWidth:100 lineBreakMode:NSLineBreakByWordWrapping];
    praiseNumSize.width += 10;
    praiseNumSize.width = praiseNumSize.width>20?praiseNumSize.width:20;
    self.praiseBg.frame = CGRectMake(frame.size.width-praiseNumSize.width-6, 9+20, praiseNumSize.width, 19);
    
    self.praiseNumLab.frame = CGRectMake(0, 0, praiseNumSize.width, 16);
    self.praiseNumLab.text = read;
    
    self.praiseTriIv.frame = CGRectMake(0, 16, praiseNumSize.width, 3);
}

//单击
- (void)tap:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(collectionViewWaterfallCellDidClicked:)]) {
        [self.delegate collectionViewWaterfallCellDidClicked:self];
    }
}

//长按
- (void)press:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(collectionViewWaterfallCellDidLongPressed:)]) {
        [self.delegate collectionViewWaterfallCellDidLongPressed:self];
    }
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

@end
