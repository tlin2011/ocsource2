//
//  PindaoHomeNewsCell.m
//  DaGangCheng
//
//  Created by huaxo on 14-10-21.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "PindaoHomeNewsCell.h"

#define PostTitleLabelTopHight 10
#define PostTitleLabelLeftWidth 10
#define PostImageViewWidth 98
#define PostImageViewHeight 75 //65
//#define PostTitleLabelFont [UIFont fontWithName:@"HelveticaNeue-Bold" size:20]
#define PostTitleLabelFont [UIFont systemFontOfSize:18]

@interface PindaoHomeNewsCell ()

@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *postInfoLabel;
@property (nonatomic, strong) UIImageView *postFlagIv;
@property (nonatomic, strong) UIImageView *lineImgView;



@property (nonatomic, strong) NSMutableArray *postImages;
@end

@implementation PindaoHomeNewsCell



- (void)initSubviews {
    [super initSubviews];
    
    //帖子标签
    self.postFlagIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [self addSubview:self.postFlagIv];
    
    //帖子主题
    self.postTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.postTitleLabel.font = PostTitleLabelFont;
    self.postTitleLabel.textColor = [UIColor blackColor];
    self.postTitleLabel.numberOfLines = 2;
    [self addSubview:self.postTitleLabel];
    
    //帖子的用户名
    self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.userNameLabel.font = [UIFont systemFontOfSize:12];
    self.userNameLabel.textColor = [UIColor lightGrayColor];
    self.userNameLabel.numberOfLines = 1;
    self.userNameLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.userNameLabel];
    
    //帖子的信息
    self.postInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.postInfoLabel.font = [UIFont systemFontOfSize:12];
    self.postInfoLabel.textColor = [UIColor lightGrayColor];
    self.postInfoLabel.numberOfLines = 1;
    [self addSubview:self.postInfoLabel];
    
    //帖子操作
    self.managerBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    
    [self.managerBtn setImage:[UIImage imageNamed:@"更多操作_评论_查看话题.png"] forState:UIControlStateNormal];
    [self.managerBtn setImage:[UIImage imageNamed:@"更多操作_评论_查看话题.png"] forState:UIControlStateHighlighted];
    [self.managerBtn setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 0, 0)];
    [self addSubview:self.managerBtn];
    
    //分割线
    self.lineImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.lineImgView.backgroundColor = UIColorFromRGB(0xc8c7cc);
    [self addSubview:self.lineImgView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //帖子标签
    self.postFlagIv.image = [Post imageByPostFlag:self.post.flag];
    
    //title color
    [self postTitleColorByLocked:self.post.isLocked];
    
    //用户名
    self.userNameLabel.text = self.post.userName;
    self.userNameLabel.frame = CGRectMake(PostTitleLabelLeftWidth, self.bounds.size.height - 23, 80, 13);
    
    //帖子的信息
    NSString *infoText = [NSString stringWithFormat:@"%@%@  %@%@  %@", GDLocalizedString(@"粉丝"),[ZBNumberUtil shortStringByInteger:self.post.zan], GDLocalizedString(@"评论"), [ZBNumberUtil shortStringByInteger:self.post.replyNum], self.post.createTime];
    self.postInfoLabel.text= infoText;
    self.postInfoLabel.frame = CGRectMake(CGRectGetMaxX(self.userNameLabel.frame)+10, self.bounds.size.height - 23, self.frame.size.width-CGRectGetMaxX(self.userNameLabel.frame)-10-30, 13);
    self.postInfoLabel.textAlignment = NSTextAlignmentRight;
    
    //帖子操作
    self.managerBtn.frame = CGRectMake(DeviceWidth - 40, self.bounds.size.height - 40, 40, 40);
    
    //分割线
    self.lineImgView.frame = CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5);
    
    //帖子主题 和 图片
    [self displayPostTitleAndPostImageByPost:self.post];
    
    if (self.post.isLocked) {
        self.postTitleLabel.textColor = UIColorFromRGB(0x898989);
    } else {
        self.postTitleLabel.textColor = [UIColor blackColor];
    }
}

- (void)displayPostTitleAndPostImageByPost:(Post *)post {
    if (self.postImages) {
        for (UIImageView *iv in self.postImages) {
            [iv removeFromSuperview];
        }
        [self.postImages removeAllObjects];
    }else {
        self.postImages = [[NSMutableArray alloc] init];
    }
    
    if ([post.imageList count] >= 3) {
        
            //显示三张图
            //帖子主题
            NSString *title = [self.post.title stringByTrimmingCharactersInSet:[NSCharacterSet  whitespaceAndNewlineCharacterSet]];
            self.postTitleLabel.text = title;
            CGFloat postTitleHeight = [self.class getPostTitleHeightByPost:self.post];
            self.postTitleLabel.frame = CGRectMake(10, PostTitleLabelTopHight, DeviceWidth-20, postTitleHeight);
            //图片
            CGFloat width = ((DeviceWidth - 2 * PostTitleLabelLeftWidth) - 3 * PostImageViewWidth) / 2.0 + PostImageViewWidth;
            for (int i=0; i<3; i++) {
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(PostTitleLabelLeftWidth + width * i, self.postTitleLabel.frame.origin.x + self.postTitleLabel.frame.size.height + 10, PostImageViewWidth, PostImageViewHeight)];
                [iv setContentMode:UIViewContentModeScaleAspectFill];
                iv.clipsToBounds = YES;
                long imageID = [post.imageList[i] integerValue];
                [iv sd_setImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:imageID w:PostImageViewWidth*2]] placeholderImage:[UIImage imageNamed:@"default_bg.png"]];
                [self addSubview:iv];
                [self.postImages addObject:iv];
            }
    } else if ([post.imageList count] >= 1) {
            //显示一张图
            //帖子主题
            NSString *title = [self.post.title stringByTrimmingCharactersInSet:[NSCharacterSet  whitespaceAndNewlineCharacterSet]];
            self.postTitleLabel.text = title;
            CGFloat postTitleHeight = [self.class getPostTitleHeightWithOneImageByPost:self.post];
            self.postTitleLabel.frame = CGRectMake(PostTitleLabelLeftWidth, PostTitleLabelTopHight, DeviceWidth-2*PostTitleLabelLeftWidth-PostImageViewWidth-10, postTitleHeight);
            //图片
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(self.postTitleLabel.frame.origin.x + self.postTitleLabel.frame.size.width + 10, PostTitleLabelTopHight, PostImageViewWidth, PostImageViewHeight)];
            [iv setContentMode:UIViewContentModeScaleAspectFill];
            iv.clipsToBounds = YES;
        long imageID = [(NSNumber *)post.imageList[0] integerValue];
            [iv sd_setImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:imageID w:PostImageViewWidth*2]] placeholderImage:[UIImage imageNamed:@"default_bg.png"]];
            [self addSubview:iv];
            [self.postImages addObject:iv];

    }else if ([post.imageList count] == 0) {

            //显示文本
            //帖子主题
            NSString *title = [self.post.title stringByTrimmingCharactersInSet:[NSCharacterSet  whitespaceAndNewlineCharacterSet]];
            self.postTitleLabel.text = title;
            CGFloat postTitleHeight = [self.class getPostTitleHeightByPost:self.post];
            self.postTitleLabel.frame = CGRectMake(PostTitleLabelLeftWidth, PostTitleLabelTopHight, DeviceWidth-20, postTitleHeight);

    }

}

+ (CGFloat)getCellHeightByPost:(Post *)post {

    if ([post.imageList count] >= 3) {
        return PostTitleLabelTopHight + [self.class getPostTitleHeightByPost:post] + 10 + PostImageViewHeight + 38;
    }else if ([post.imageList count] >= 1) {
        return PostTitleLabelTopHight + PostImageViewHeight + 38;
    }else if ([post.imageList count] == 0) {
        return PostTitleLabelTopHight + [self.class getPostTitleHeightByPost:post] + 38;
    }

    return 10;
}

+ (CGFloat)getPostTitleHeightWithOneImageByPost:(Post *)Post {
    CGFloat height = 0;
    NSString *text = nil;
    UIFont *font = PostTitleLabelFont;
    text = [Post.title length]>0?Post.title:@" ";
    //    NSMutableArray *arr = [[NSMutableArray alloc] init];
    //    //去掉图片
    //    text = [TQRichTextImageRun analyzeText:contentText runsArray:&arr];
    //    //去掉表情
    //    text = [TQRichTextEmojiRun analyzeText:text runsArray:&arr];
    //去掉空格
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet  whitespaceAndNewlineCharacterSet]];
    //text = @"我我我我我我我我我我我我我我我我我我我我我我";//我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我";
    //NSLog(@"text len %d %d", text.length,[text isEqualToString:@""]);
    if (text.length != 0) {
        CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(DeviceWidth-2*PostTitleLabelLeftWidth-PostImageViewWidth-10, 999.0) lineBreakMode:UILineBreakModeWordWrap];
        height = size.height>2.0*font.lineHeight ? 2.0*font.lineHeight: size.height;
        //NSLog(@"size2 %f",size.height);
        return height;
    } else {
        return 0.0;
    }
}

+ (CGFloat)getPostTitleHeightByPost:(Post *)Post {
    CGFloat height = 0;
    NSString *text = nil;
    UIFont *font = PostTitleLabelFont;
    text = [Post.title length]>0?Post.title:@" ";
    //    NSMutableArray *arr = [[NSMutableArray alloc] init];
    //    //去掉图片
    //    text = [TQRichTextImageRun analyzeText:contentText runsArray:&arr];
    //    //去掉表情
    //    text = [TQRichTextEmojiRun analyzeText:text runsArray:&arr];
    //去掉空格
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet  whitespaceAndNewlineCharacterSet]];
    //text = @"我我我我我我我我我我我我我我我我我我我我我我";//我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我";
    //NSLog(@"text len %d %d", text.length,[text isEqualToString:@""]);
    if (text.length != 0) {
        CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(DeviceWidth - 2*PostTitleLabelLeftWidth, 999.0) lineBreakMode:UILineBreakModeWordWrap];
        height = size.height>2.0*font.lineHeight ? 2.0*font.lineHeight: size.height;
        //NSLog(@"size2 %f",size.height);
        return height;
    } else {
        return 0.0;
    }
}

- (void)lockedByPost:(Post *)post {
    PostLockedSQL *pSql = [[PostLockedSQL alloc] init];
    [pSql insertPostId:post.postId];
    post.isLocked = YES;
    self.postTitleLabel.textColor = UIColorFromRGB(0x898989);
}

- (void)postTitleColorByLocked:(BOOL)lock {
    if (lock) {
        self.postTitleLabel.textColor = UIColorFromRGB(0x898989);
    }else {
        self.postTitleLabel.textColor = [UIColor blackColor];
    }
}

- (void)setDataSource:(Post *)dataSource {
    self.post = dataSource;
    _dataSource = dataSource;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    if (selected == YES) {
        [self lockedByPost:self.post];
    }
}

@end
