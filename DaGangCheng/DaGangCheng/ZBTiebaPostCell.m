//
//  ZBTiebaPostCell.m
//  DaGangCheng
//
//  Created by huaxo on 15-3-31.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBTiebaPostCell.h"

#define HeadBtnTopHight 20
#define HeadBtnLeftWidth 10
#define PostImageViewWidth 90
#define PostImageViewHeight 90 //65
#define PostTitleLabelFont [UIFont fontWithName:@"HelveticaNeue-Bold" size:18]


@implementation ZBTiebaPostCell

- (void)initSubviews {
    [super initSubviews];
    
    //帖子标签
    self.tagImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.tagImgView];
    
    //头像
    self.headBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    self.headBtn.layer.cornerRadius = 16.0;
    self.headBtn.layer.masksToBounds = YES;
    [self addSubview:self.headBtn];
    
    //昵称
    self.nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLab.textColor = UIColorFromRGB(0x2a2a2d);
    self.nameLab.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.nameLab];
    
    //发帖时间
    self.timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.timeLab.textColor = UIColorFromRGB(0xa8a8ab);
    self.timeLab.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.timeLab];
    
    //浏览量
    self.browseBtn = [[ZBPostListButton alloc] initWithFrame:CGRectZero];
    self.browseBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.browseBtn setTitleColor:UIColorFromRGB(0xa8a8a9) forState:UIControlStateNormal];
    self.browseBtn.userInteractionEnabled = NO;
    [self addSubview:self.browseBtn];
    
    //帖子标题
    self.postTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.postTitleLab.textColor = UIColorFromRGB(0x2a3137);
    self.postTitleLab.numberOfLines = 0;
    [self addSubview:self.postTitleLab];
    
    //点赞
    self.praiseBtn = [[ZBPostListButton alloc] initWithFrame:CGRectZero];
    self.praiseBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.praiseBtn setTitleColor:UIColorFromRGB(0x7a8186) forState:UIControlStateNormal];
    self.praiseBtn.userInteractionEnabled = NO;
    [self addSubview:self.praiseBtn];
    
    //评论
    self.replyBtn = [[ZBPostListButton alloc] initWithFrame:CGRectZero];
    self.replyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.replyBtn setTitleColor:UIColorFromRGB(0x7a8186) forState:UIControlStateNormal];
    self.replyBtn.userInteractionEnabled = NO;
    [self addSubview:self.replyBtn];
    
    //线
    self.lineImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    //self.lineImgView.layer.borderColor = UIColorFromRGB(0xdbdbdb).CGColor;
    //self.lineImgView.layer.borderWidth = 0.5;
    //self.lineImgView.layer.masksToBounds = YES;
    UIImage *bgImg = [UIImage imageWithColor:UIColorFromRGB(0xefefef) andSize:CGSizeMake(2, 2)];
    [self.lineImgView setImage:bgImg];
    [self addSubview:self.lineImgView];
    
    //底部线
    self.bottomLineImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    UIImage *bottomImg = [UIImage imageWithColor:UIColorFromRGB(0xdbdbdb) andSize:CGSizeMake(2, 2)];
    [self.bottomLineImgView setImage:bottomImg];
    [self addSubview:self.bottomLineImgView];
}

- (NSMutableArray *)imgs {
    if (!_imgs) {
        _imgs = [[NSMutableArray alloc] init];
        for (int i=0; i<3; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
            btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
            btn.userInteractionEnabled = NO;
            [_imgs addObject:btn];
        }
    }
    return _imgs;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    
    //self.headBtn.backgroundColor = [UIColor redColor];
    //self.nameLab.backgroundColor = [UIColor redColor];
    //self.timeLab.backgroundColor = [UIColor redColor];
    //self.browseBtn.backgroundColor = [UIColor redColor];
    //self.postTitleLab.backgroundColor = [UIColor redColor];
    //self.praiseBtn.backgroundColor = [UIColor redColor];
    //self.replyBtn.backgroundColor = [UIColor redColor];
    
    //帖子标签
    self.tagImgView.frame = CGRectMake(0, 10, 18, 18);
    self.tagImgView.image = [Post imageByPostFlag:self.post.flag];
    
    //头像
    self.headBtn.frame = CGRectMake(HeadBtnLeftWidth, HeadBtnTopHight, 32, 32);
    [self.headBtn sd_setImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:self.post.userImageId w:2*CGRectGetWidth(self.headBtn.frame)]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"nm.png"]];
    
    //昵称
    self.nameLab.frame = CGRectMake(HeadBtnLeftWidth+CGRectGetWidth(self.headBtn.frame)+10, HeadBtnTopHight, 120, self.nameLab.font.lineHeight);
    self.nameLab.text = self.post.userName;
    
    //时间
    self.timeLab.frame = CGRectMake(HeadBtnLeftWidth+CGRectGetWidth(self.headBtn.frame)+10, HeadBtnTopHight + CGRectGetHeight(self.nameLab.frame)+1, 200, self.timeLab.font.lineHeight);
    NSString *pindaoNameStr = self.post.pindaoName?self.post.pindaoName:@"";
    NSString *timeText = [NSString stringWithFormat:@"%@   %@",self.post.createTime,pindaoNameStr];
    self.timeLab.text = timeText;
    
    //浏览量
    self.browseBtn.frame = CGRectMake(frame.size.width-100, HeadBtnTopHight, 90, 16);
    [self.browseBtn setTitle:[ZBNumberUtil shortStringByInteger:self.post.readNum] forState:UIControlStateNormal];
    [self.browseBtn setImage:[UIImage imageNamed:@"browse_post.png"] forState:UIControlStateNormal];
    
    //帖子名称
    NSString *nameStr = self.post.title;
    nameStr = [nameStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.postTitleLab.text = nameStr;
    CGFloat titleLabHeight = [self.class getPostTitleHeightByPost:self.post];
    self.postTitleLab.frame = CGRectMake(HeadBtnLeftWidth, HeadBtnTopHight+32+12, frame.size.width-2*HeadBtnLeftWidth, titleLabHeight);
    
    //图片
    for (UIButton *btn in self.imgs) {
        [btn removeFromSuperview];
    }
    
    CGFloat imgY = HeadBtnTopHight+32+12+titleLabHeight+12;
    if ([self.post.imageList count]>=1) {
        for (int i=0; i<[self.post.imageList count] && i<3; i++) {
            UIButton *btn = self.imgs[i];
            btn.frame = CGRectMake(HeadBtnLeftWidth+93*i, imgY, PostImageViewWidth, PostImageViewHeight);
            UIImage *phImage = [UIImage imageNamed:@"default_bg.png"];
            phImage = [UIImage imageWithColor:[UIColor colorWithPatternImage:phImage] andSize:CGSizeMake(PostImageViewWidth, PostImageViewHeight)];
            [btn sd_setImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:[self.post.imageList[i] integerValue] w:PostImageViewWidth*2]] forState:UIControlStateNormal placeholderImage:phImage];
            [self addSubview:btn];
        }
    }else {

    }
    
    //评论
    [self.replyBtn setTitle:[ZBNumberUtil shortStringByInteger:self.post.replyNum] forState:UIControlStateNormal];
    [self.replyBtn setImage:[UIImage imageNamed:@"reply_post.png"] forState:UIControlStateNormal];
    CGFloat replyBtnWidth = [self.replyBtn buttonTitleWidth];
    replyBtnWidth += 26;
    self.replyBtn.frame = CGRectMake(frame.size.width-replyBtnWidth-10, frame.size.height-28, replyBtnWidth, 16);

    
    //点赞
    NSString *praiseStr = [ZBNumberUtil shortStringByInteger:self.post.zan];
    praiseStr = [praiseStr isEqualToString:@"0"]?GDLocalizedString(@"赞"):praiseStr;
    [self.praiseBtn setTitle:praiseStr forState:UIControlStateNormal];
    [self.praiseBtn setImage:[UIImage imageNamed:@"praise_post.png"] forState:UIControlStateNormal];
    CGFloat praiseBtnWidth = [self.praiseBtn buttonTitleWidth];
    praiseBtnWidth += 26;
    self.praiseBtn.frame = CGRectMake(frame.size.width-replyBtnWidth-10-11-praiseBtnWidth, frame.size.height-28, praiseBtnWidth, 16);
    [self.praiseBtn setImageEdgeInsets:UIEdgeInsetsMake(-2, -5, 2, 5)];
    
    //线
    self.lineImgView.frame = CGRectMake(0, 0, frame.size.width, 10);
    
    //底部线
    self.bottomLineImgView.frame = CGRectMake(0, frame.size.height-0.5, frame.size.width, 0.5);
    
    //看过的贴
    if (self.post.isLocked) {
        self.postTitleLab.textColor = UIColorFromRGB(0x898989);
    } else {
        self.postTitleLab.textColor = UIColorFromRGB(0x2a3137);
    }
}

+ (CGFloat)getCellHeightByPost:(Post *)post {
    
    if ([post.imageList count] >= 1) {
        return HeadBtnTopHight+32+12+[self getPostTitleHeightByPost:post]+12+PostImageViewHeight+8+16+12+10;
    } else {
        return HeadBtnTopHight+32+12+[self getPostTitleHeightByPost:post]+12+8+16+12+10;
    }
}


+ (CGFloat)getPostTitleHeightByPost:(Post *)post {
    
    NSString *str = [post.title length]>0?post.title:@"";
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([str length] == 0) {
        return 0.0;
    }
    CGSize size = CGSizeMake(DeviceWidth-2*HeadBtnLeftWidth, 999);
    UIFont *font = PostTitleLabelFont;
    size = [str sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    size.height = size.height>2.0*font.lineHeight ? 2.0*font.lineHeight : size.height;
    
    return size.height;
}

- (void)lockedByPost:(Post *)post {
    PostLockedSQL *pSql = [[PostLockedSQL alloc] init];
    [pSql insertPostId:post.postId];
    post.isLocked = YES;
    self.postTitleLab.textColor = UIColorFromRGB(0x898989);
}

- (void)postTitleColorByLocked:(BOOL)lock {
    if (lock) {
        self.postTitleLab.textColor = UIColorFromRGB(0x898989);
    }else {
        self.postTitleLab.textColor = UIColorFromRGB(0x2a3137);;
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected == YES) {
        [self lockedByPost:self.post];
    }
}

@end
