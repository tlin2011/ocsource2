//
//  HotActivityPindaoTableCell2.m
//  DaGangCheng
//
//  Created by huaxo on 15-3-27.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "HotActivityPindaoTableCell2.h"

#define PostTitleLabelFont [UIFont systemFontOfSize:16]
#define PostImageViewHeight 176

@interface HotActivityPindaoTableCell2 ()

@property (nonatomic, strong) UIImageView *postBg;
@property (nonatomic, strong) UILabel *postNameLab;
@property (nonatomic, strong) UIImageView *postImgView;
@property (nonatomic, strong) UILabel *postContentLab;
@property (nonatomic, strong) UILabel *userNameLab;
@property (nonatomic, strong) UILabel *praiseNumLab;

@end

@implementation HotActivityPindaoTableCell2

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    self.backgroundColor = UIColorFromRGB(0xe1e2e5);
    
    //帖子背景
    self.postBg = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.postBg.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.postBg];
    
    //帖子标题
    self.postNameLab = [[UILabel alloc] init];
    self.postNameLab.font = PostTitleLabelFont;
    self.postNameLab.textColor = UIColorFromRGB(0x32373e);
    [self.postNameLab setNumberOfLines:0];
    self.postNameLab.lineBreakMode = UILineBreakModeWordWrap;
    [self addSubview:self.postNameLab];
    
    //帖子图片
    self.postImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.postImgView setContentMode:UIViewContentModeScaleAspectFill];
    self.postImgView.clipsToBounds = YES;
    [self addSubview:self.postImgView];
    
    //帖子内容
    self.postContentLab = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:self.postContentLab];
    
    //用户名
    self.userNameLab = [[UILabel alloc] init];
    self.userNameLab.textColor = UIColorFromRGB(0xabadb1);
    self.userNameLab.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.userNameLab];
    
    //赞
    self.praiseNumLab = [[UILabel alloc] init];
    self.praiseNumLab.textColor = UIColorFromRGB(0xabadb1);
    self.praiseNumLab.font = [UIFont systemFontOfSize:12];
    self.praiseNumLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.praiseNumLab];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    
    //帖子背景
    self.postBg.frame = CGRectMake(10, 5, frame.size.width - 10*2, frame.size.height - 5*2);
    
    //用户名
    NSString *userNameStr = [NSString stringWithFormat:@"%@  %@",self.dataSource.userName,self.dataSource.createTime];
    self.userNameLab.text = userNameStr;
    self.userNameLab.frame = CGRectMake(20, frame.size.height - 5 - 10 - 12, frame.size.width - 40, 12);
    
    //赞
    NSString *praiseStr = [NSString stringWithFormat:@"赞%d  评论%d",self.dataSource.zan,self.dataSource.replyNum];
    self.praiseNumLab.text = praiseStr;
    self.praiseNumLab.frame = CGRectMake(20, frame.size.height - 5 -10 -12, frame.size.width - 40, 12);
    
    //帖子标题
    NSString *nameStr = self.dataSource.title;
    nameStr = [nameStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.postNameLab.text = nameStr;
    CGFloat nameHeight = [self.class getPostTitleHeightByPost:self.dataSource];
    self.postNameLab.frame = CGRectMake(20, 5+10, frame.size.width-40, nameHeight);
    
    //帖子内容
    if ([self.dataSource.imageList count] == 0) {
        self.imageView.hidden = YES;
        self.imageView.frame = CGRectZero;
    } else {
        self.postImgView.hidden = NO;
        self.postImgView.frame = CGRectMake(10, 15+nameHeight+10, frame.size.width-20, PostImageViewHeight);
        long imageID = [(NSNumber *)self.dataSource.imageList[0] integerValue];
        [self.postImgView sd_setImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:imageID w:640]] placeholderImage:[UIImage imageNamed:@"default_bg.png"]];
    }
    
}

+ (CGFloat)getCellHeightByPost:(Post *)post {
    
    if ([post.imageList count] >= 1) {
        return 5 + 10 + [self.class getPostTitleHeightByPost:post] + 10 + PostImageViewHeight + 38;
    }else if ([post.imageList count] == 0) {
        return 5 + 10 + [self.class getPostTitleHeightByPost:post] + 10 + 20 + 38;
    }
    
    return 10;
}

+ (CGFloat)getPostTitleHeightByPost:(Post *)post {
    
    NSString *str = [post.title length]>0?post.title:@"";
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([str length] == 0) {
        return 0.0;
    }
    CGSize size = CGSizeMake(DeviceWidth-40, 999);
    UIFont *font = PostTitleLabelFont;
    size = [str sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    size.height = size.height>2.0*font.lineHeight ? 2.0*font.lineHeight : size.height;
    
    return size.height;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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

@end
