//
//  HotPhotoPindaoTableCell.m
//  DaGangCheng
//
//  Created by huaxo on 14-10-24.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "HotPhotoPindaoTableCell.h"
#import "UIImageView+WebCache.h"
#import "ApiUrl.h"

#define PostTitleLabelTopHight 10
#define PostTitleLabelLeftWidth 5

#define PostImage_SPACING 2

#define PostTitleLabelFont [UIFont fontWithName:@"HelveticaNeue-Bold" size:14]

@interface HotPhotoPindaoTableCell ()
@property (nonatomic, strong) UILabel *postTitleLabel;
//@property (nonatomic, strong) UIImageView *postImage;
//@property (nonatomic, strong) UIImageView *timeIco;
//@property (nonatomic, strong) UILabel *creatTime;
@property (nonatomic, strong) NSMutableArray *postImages;
@property (nonatomic, strong) UILabel *postInfo;
@property (nonatomic, strong) UIImageView *postTitleBg;


@end

@implementation HotPhotoPindaoTableCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    //图片
    self.postTitleBg = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.postTitleBg.backgroundColor = UIColorFromRGB(0xebeff2);
    [self addSubview:self.postTitleBg];
    
    //帖子主题
    self.postTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.postTitleLabel.font = PostTitleLabelFont;
    self.postTitleLabel.textColor = UIColorFromRGB(0x32373e);
    self.postTitleLabel.numberOfLines = 1;
    [self addSubview:self.postTitleLabel];
    
//    //图片
//    self.postImage = [[UIImageView alloc] initWithFrame:CGRectZero];
//    [self.postImage setContentMode:UIViewContentModeScaleAspectFill];
//    self.postImage.clipsToBounds = YES;
//    [self addSubview:self.postImage];
//    
//    //时间Ico
//    self.timeIco = [[UIImageView alloc] initWithFrame:CGRectZero];
//    [self addSubview:self.timeIco];
//    
//    //帖子创建时间
//    self.creatTime = [[UILabel alloc] initWithFrame:CGRectZero];
//    self.creatTime.textColor = [UIColor lightGrayColor];
//    self.creatTime.font = [UIFont systemFontOfSize:12];
//    self.creatTime.numberOfLines = 1;
//    [self addSubview:self.creatTime];
    
    //帖子信息
    self.postInfo = [[UILabel alloc] initWithFrame:CGRectZero];
    self.postInfo.textColor = UIColorFromRGB(0xabadb1);
    self.postInfo.font = [UIFont systemFontOfSize:12];
    self.postInfo.numberOfLines = 1;
    [self addSubview:self.postInfo];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    //帖子主题
    self.postTitleLabel.text = self.dataSource.title;
    self.postTitleLabel.frame = CGRectMake(PostTitleLabelLeftWidth, self.bounds.size.height - 30, self.bounds.size.width- (PostTitleLabelLeftWidth + 95 + 8), 15);
    
    //
    self.postTitleBg.frame = CGRectMake(0, self.bounds.size.height - 38, self.bounds.size.width, 30);
    
//    //帖子图片
//    [self.postImage setImage:[UIImage imageNamed:@"Default.png"]];
//    self.postImage.frame = CGRectMake(PostTitleLabelLeftWidth, self.postTitleLabel.frame.origin.y + self.postTitleLabel.frame.size.height + 10, DeviceWidth - 2*PostTitleLabelLeftWidth, PostImageViewHeight);
//    
//    //帖子时间Ico
//    [self.timeIco setImage:[UIImage imageNamed:@""]];
//    self.timeIco.frame = CGRectMake(PostTitleLabelLeftWidth, self.bounds.size.height - 25, 10, 15);
//    
//    //帖子创建时间
//    self.creatTime.text = self.dataSource.createTime;
//    self.creatTime.frame = CGRectMake(self.timeIco.frame.origin.x + self.timeIco.frame.size.width + 8, self.timeIco.frame.origin.y, self.timeIco.frame.origin.y, self.timeIco.frame.size.height);
    
    //帖子信息
    NSString *infoText = [NSString stringWithFormat:@"%@%@  %@%@", GDLocalizedString(@"赞"),[ZBNumberUtil shortStringByInteger:self.dataSource.zan], GDLocalizedString(@"评论"), [ZBNumberUtil shortStringByInteger:self.dataSource.replyNum]];
    self.postInfo.text = infoText;
    self.postInfo.frame = CGRectMake(self.bounds.size.width - 95-8, self.bounds.size.height - 28, 95, 13);
    self.postInfo.textAlignment = NSTextAlignmentRight;
    
    //显示图片
    [self showPostImageByPost:self.dataSource];
}

- (void)showPostImageByPost:(Post *)post {
    if (self.postImages) {
        for (UIImageView *iv in self.postImages) {
            [iv removeFromSuperview];
        }
        [self.postImages removeAllObjects];
    }else {
        self.postImages = [[NSMutableArray alloc] init];
    }
    
    NSArray *postImgeIds = post.imageList;
    if ([postImgeIds count] >= 2) {
        
        //显示两张图
        //图片
        CGFloat width = (self.bounds.size.width + PostImage_SPACING)/2.0;
        for (int i=0; i<2; i++) {
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(width * i, 0, width-PostImage_SPACING, 160)];
            [iv setContentMode:UIViewContentModeScaleAspectFill];
            iv.clipsToBounds = YES;
            long imageID = [(NSNumber *)postImgeIds[i] integerValue];
            [iv sd_setImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:imageID w:iv.frame.size.width*2]] placeholderImage:[UIImage imageNamed:@"default_bg.png"]];
            [self addSubview:iv];
            [self.postImages addObject:iv];
        }
    } else if ([postImgeIds count] >= 1) {
        //显示一张图
        //图片
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 160)];
        [iv setContentMode:UIViewContentModeScaleAspectFill];
        iv.clipsToBounds = YES;
        long imageID = [(NSNumber *)postImgeIds[0] integerValue];
        [iv sd_setImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:imageID w:iv.bounds.size.width]] placeholderImage:[UIImage imageNamed:@"default_bg.png"]];
        [self addSubview:iv];
        [self.postImages addObject:iv];
        
    }else if ([postImgeIds count] == 0) {
    }
    
}

@end
