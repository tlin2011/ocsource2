//
//  HotActivityPindaoTableCell3.m
//  DaGangCheng
//
//  Created by huaxo on 15-4-9.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "HotActivityPindaoTableCell3.h"

#define PostTitleLabelFont [UIFont systemFontOfSize:16]
#define ActivityTimeLabelFont [UIFont systemFontOfSize:13];
#define PostTitleLabelTop (32+10)
#define PostTitleLabelLeft (8+12)
#define PostTitleLabelRight (8+12)
#define PostImageViewHeight 168

@implementation HotActivityPindaoTableCell3

- (void)initSubviews {
    [super initSubviews];
    
    //白背景
    self.bgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.cornerRadius = 2.0;
    self.bgView.layer.borderColor = UIColorFromRGB(0xb5b5b6).CGColor;
    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.masksToBounds = YES;
    [self addSubview:self.bgView];
    
    //发帖时间
    self.timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.timeLab.textColor = UIColorFromRGB(0xabadb1);
    self.timeLab.textAlignment = NSTextAlignmentCenter;
    self.timeLab.font = [UIFont systemFontOfSize:10.0];
    [self addSubview:self.timeLab];
    
    //标签
    self.tagLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.tagLab.textColor = [UIColor whiteColor];
    self.tagLab.font = [UIFont systemFontOfSize:10.0];
    self.tagLab.textAlignment = NSTextAlignmentCenter;
    self.tagLab.backgroundColor = UIColorFromRGB(0xe60012);
    self.tagLab.layer.cornerRadius = 2.0;
    self.tagLab.layer.masksToBounds = YES;
    [self addSubview:self.tagLab];
    
    //帖子标题
    self.postTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.postTitleLab.textColor = UIColorFromRGB(0x32373e);
    self.postTitleLab.numberOfLines = 0;
    self.postTitleLab.font = PostTitleLabelFont;
    [self addSubview:self.postTitleLab];
    
    //活动时间
    self.activityTimeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.activityTimeLab.textColor = UIColorFromRGB(0x878d98);
    self.activityTimeLab.textAlignment = NSTextAlignmentLeft;
    self.activityTimeLab.font = [UIFont systemFontOfSize:13.0];
    [self addSubview:self.self.activityTimeLab];
    
    //图片
    self.postImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.postImgView setContentMode:UIViewContentModeScaleAspectFill];
    self.postImgView.clipsToBounds = YES;
    [self addSubview:self.postImgView];
    
    //频道名
    self.pindaoNameLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.pindaoNameLab.textColor = UIColorFromRGB(0xabadb1);
    self.pindaoNameLab.textAlignment = NSTextAlignmentLeft;
    self.pindaoNameLab.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.pindaoNameLab];
    
    //人数
    self.prosonsLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.prosonsLab.font = [UIFont systemFontOfSize:13.0];
    self.prosonsLab.textColor = UIColorFromRGB(0xe60012);
    self.prosonsLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.prosonsLab];
    
    //参加
    self.joinLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.joinLab.textColor = UIColorFromRGB(0xe60012);
    self.joinLab.textAlignment = NSTextAlignmentCenter;
    self.joinLab.font = [UIFont systemFontOfSize:13];
    self.joinLab.layer.borderColor = UIColorFromRGB(0xe60012).CGColor;
    self.joinLab.layer.borderWidth = 1.0;
    self.joinLab.layer.cornerRadius = 2;
    self.joinLab.layer.masksToBounds = YES;
    [self addSubview:self.joinLab];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //背景
    self.bgView.frame = CGRectMake(8, 32, frame.size.width-8*2, frame.size.height-33);
    
    //发帖时间
    self.timeLab.frame = CGRectMake(0, 0, frame.size.width, 32);
    self.timeLab.text = self.post.createTime;
    
    //标签
    if (self.post.activtyTag.length > 0) {
        
        self.tagLab.text = (self.post.activtyTag.length > 4)?[self.post.activtyTag substringToIndex:4]:self.post.activtyTag;
        
        self.tagLab.frame = CGRectMake(PostTitleLabelLeft, PostTitleLabelTop+2, 44, 15);
        
        self.tagLab.hidden = NO;
    } else {
        self.tagLab.hidden = YES;
        self.tagLab.frame = CGRectZero;
    }
    
    
    //标题
    NSString *titleStr = self.post.title;
    titleStr = [titleStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *whiteSpace = @"";
    if (self.tagLab.hidden == NO) {
        whiteSpace = [whiteSpace stringByAppendingString:@"          "];
    }
    titleStr = [NSString stringWithFormat:@"%@%@", whiteSpace, titleStr];
    self.postTitleLab.text = titleStr;
    CGFloat height = [self.class getPostTitleHeightByPost:self.post];
    self.postTitleLab.frame = CGRectMake(PostTitleLabelLeft, PostTitleLabelTop, frame.size.width-PostTitleLabelLeft-PostTitleLabelRight, height);
    
    //活动时间
    height += PostTitleLabelTop+10;
    self.activityTimeLab.font = ActivityTimeLabelFont;
    self.activityTimeLab.frame = CGRectMake(PostTitleLabelLeft, height, frame.size.width-PostTitleLabelLeft-PostTitleLabelRight, self.activityTimeLab.font.lineHeight);

    NSTimeInterval startTimeInterval = [TimeUtil getTimeIntervalFromString:self.post.startTime];
    NSString *startTime = [self.post.startTime isEqualToString:@""]?@"":[TimeUtil getFriendlyTime:[NSNumber numberWithLong:startTimeInterval]];
    NSTimeInterval endTimeInterval = [TimeUtil getTimeIntervalFromString:self.post.endTime];
    NSString *endTime = [self.post.endTime isEqualToString:@""]?@"":[TimeUtil getFriendlyTime:[NSNumber numberWithLong:endTimeInterval]];
    
    self.activityTimeLab.text = [NSString stringWithFormat:@"%@：%@~%@",GDLocalizedString(@"活动时间"),startTime, endTime];
    
    //图片
    height += self.activityTimeLab.font.lineHeight+15;
    if ([self.post.imageList count] == 0) {
        self.postImgView.hidden = YES;
        self.postImgView.frame = CGRectZero;
    } else {
        self.postImgView.hidden = NO;
        self.postImgView.frame = CGRectMake(PostTitleLabelLeft, height, frame.size.width-PostTitleLabelLeft-PostTitleLabelRight, PostImageViewHeight);
        long imageID = [(NSNumber *)self.post.imageList[0] integerValue];
        [self.postImgView sd_setImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:imageID w:600]] placeholderImage:[UIImage imageNamed:@"default_bg.png"]];
        
        height += PostImageViewHeight;
    }
    
    //频道名
    self.pindaoNameLab.frame = CGRectMake(PostTitleLabelLeft, frame.size.height-40, 100, 40);
    self.pindaoNameLab.text = self.post.pindaoName;
    
    //人数
    self.prosonsLab.frame = CGRectMake(0, 0, 100, 40);
    self.prosonsLab.center = CGPointMake(frame.size.width/2.0, frame.size.height-40/2.0);
    NSString* readStr  = [ZBNumberUtil shortStringByInteger:self.post.readNum];
    NSString* readStrs =[NSString stringWithFormat:@"%@%@",readStr,GDLocalizedString(@"人想参加")];
    NSMutableAttributedString *readColorStr =  [[NSMutableAttributedString alloc] initWithString:readStrs];
    [readColorStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x32373e) range:NSMakeRange(readStrs.length-4,4)];
    self.prosonsLab.attributedText = readColorStr;
    
    //参加
    self.joinLab.frame = CGRectMake(frame.size.width-65-PostTitleLabelRight, frame.size.height-32, 65, 24);
    self.joinLab.text = GDLocalizedString(@"立即参与");
    
}

+ (CGFloat)getCellHeightByPost:(Post *)post {
    
    if ([post.imageList count] >= 1) {
        UIFont *actfont = ActivityTimeLabelFont;
        return PostTitleLabelTop + [self.class getPostTitleHeightByPost:post] + 10 + actfont.lineHeight + 15 + PostImageViewHeight + 40;
    }else if ([post.imageList count] == 0) {
        UIFont *actfont = ActivityTimeLabelFont;
        return PostTitleLabelTop + [self.class getPostTitleHeightByPost:post] + 10 + actfont.lineHeight + 15 + 40;
    }
    
    return 44;
}

+ (CGFloat)getPostTitleHeightByPost:(Post *)post {
    
    NSString *str = [post.title length]>0?post.title:@"";
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    str = [NSString stringWithFormat:@"          %@",str];
    if ([str length] == 0) {
        return 0.0;
    }
    CGSize size = CGSizeMake(DeviceWidth-40, 999);
    UIFont *font = PostTitleLabelFont;
    size = [str sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    size.height = size.height>2.0*font.lineHeight ? 2.0*font.lineHeight : size.height;
    
    return size.height;
}

@end
