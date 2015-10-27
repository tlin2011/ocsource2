//
//  ZBPostView.m
//  DaGangCheng
//
//  Created by huaxo on 15-6-24.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBPostView.h"

#define SubjectLabelTop 100

#define HeadBtnLeftWidth 10
#define PostTitleLabelFont [UIFont fontWithName:@"HelveticaNeue-Bold" size:18]

@interface ZBPostView ()

@property (nonatomic) int contentTextViewY;
@property (nonatomic, strong) UIImageView *PindaoImage;

@end


@implementation ZBPostView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}

- (void)initData {
    
}


- (void)initUI {
    self.backgroundColor = [UIColor whiteColor];
    //头像
    UIButton *txView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    txView.layer.cornerRadius = 20;
    txView.layer.masksToBounds = YES;
    [txView addTarget:self action:@selector(clickedHeadPortrait:) forControlEvents:UIControlEventTouchUpInside];
    self.txView = txView;
    
    UIImageView *headBg = [[UIImageView alloc] initWithFrame:CGRectMake(8, 46, 45, 45)];
    headBg.image = [UIImage imageNamed:@"head_bg.png"];
    self.txView.center = CGPointMake(headBg.frame.size.width/2.0, headBg.frame.size.height/2.0);
    [headBg setUserInteractionEnabled:YES];
    [headBg addSubview:self.txView];
    [self addSubview:headBg];
    
    //昵称
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    nameLabel.textColor = UIColorFromRGB(0x3668b2);
    self.nameLabel = nameLabel;
    [self addSubview:self.nameLabel];
    
    //浏览量
    ZBPostListButton *browseBtn = [[ZBPostListButton alloc] initWithFrame:CGRectZero];
    browseBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [browseBtn setTitleColor:UIColorFromRGB(0xa8a8a9) forState:UIControlStateNormal];
    browseBtn.userInteractionEnabled = NO;
    self.browseBtn = browseBtn;
    [self addSubview:self.browseBtn];
    
    //时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    timeLabel.font = [UIFont systemFontOfSize:11];
    timeLabel.textColor = UIColorFromRGB(0x98999a);
    self.timeLabel = timeLabel;
    [self addSubview:self.timeLabel];
    
    //来自频道的名称
    UIButton *fromPindaoName = [UIButton buttonWithType:UIButtonTypeCustom];
    fromPindaoName.frame = CGRectZero;
    fromPindaoName.titleLabel.font = [UIFont systemFontOfSize:14];
    [fromPindaoName setTitleColor:UIColorFromRGB(0xa6a9af) forState:UIControlStateNormal];
    [fromPindaoName setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    //设置button方法的实现
    //[fromPindaoName addTarget:self action:@selector(clickedPindaoButton:) forControlEvents:UIControlEventTouchUpInside];
    //设置button上字体的对齐方式
    [fromPindaoName setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    //设置button上字体的偏移量
    [fromPindaoName setTitleEdgeInsets:UIEdgeInsetsMake(0, 45, 0, 0)];
    [fromPindaoName setBackgroundColor:UIColorFromRGB(0xf2f5f7)];
    [fromPindaoName setBackgroundImage:[UIImage imageNamed:@"矩形灰.jpg"] forState:UIControlStateHighlighted];
    [fromPindaoName addTarget:self action:@selector(clickedPindaoName:) forControlEvents:UIControlEventTouchUpInside];
    self.fromPindaoName = fromPindaoName;
    [self addSubview:self.fromPindaoName];
    
    self.PindaoImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.PindaoImage.layer.cornerRadius = 2;
    self.PindaoImage.layer.masksToBounds = YES;
    [self.fromPindaoName addSubview:self.PindaoImage];
    
    UIImageView *signImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.signImage = signImage;
    signImage.image = [UIImage imageNamed:@"超链_jt@2x.png"];
    [self.fromPindaoName addSubview:signImage];
    
    //标题
    UILabel *subjectLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    subjectLabel.numberOfLines = 0;
    subjectLabel.textColor = UIColorFromRGB(0x32373e);
    self.subjectLabel = subjectLabel;
    [self addSubview:self.subjectLabel];
    
    //内容
    ZBCoreTextView *contentTextView = [[ZBCoreTextView alloc] initWithFrame:CGRectZero];
    contentTextView.backgroundColor = [UIColor whiteColor];
    contentTextView.delegate = self;
    self.contentTextView = contentTextView;
    [self addSubview:self.contentTextView];
    
    //地址图标
    UIImageView *loctionIco = [[UIImageView alloc] initWithFrame:CGRectZero];
    loctionIco.image = [UIImage imageNamed:@"dingwei.png"];
    loctionIco.contentMode = UIViewContentModeScaleAspectFit;
    self.loctionIco = loctionIco;
    [self addSubview:self.loctionIco];
    
    //地址
    UILabel *loctionAddr = [[UILabel alloc] initWithFrame:CGRectZero];
    loctionAddr.font = [UIFont systemFontOfSize:10];
    loctionAddr.textColor = [UIColor grayColor];
    self.loctionAddr = loctionAddr;
    [self addSubview:self.loctionAddr];
    
    //底端线
    UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectZero];
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    self.bottomLine = bottomLine;
    [self addSubview:self.bottomLine];
}

+ (CGFloat)heightFromRegularMatchArray:(NSArray *)rmArray post:(Post *)post{
    CGFloat height = [ZBCoreTextView heightFromRegularMatchArray:rmArray];
    height += [self getPostTitleHeightByPost:post];
    height += 115;
    if (post.address && ![post.address isEqualToString:@""] && ![post.address isEqualToString:@"未知地址"]) {
        height += 25;
    }
    
    return height;
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

- (void)updateData {
    //头像
    [self.txView sd_setBackgroundImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:self.post.userImageId w:60]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"nm.png"]];
    self.txView.tag = [self.post.uid intValue];

    //昵称
    self.nameLabel.text = self.post.userName;
    
    //浏览量
    [self.browseBtn setTitle:[ZBNumberUtil shortStringByInteger:self.post.readNum] forState:UIControlStateNormal];
    [self.browseBtn setImage:[UIImage imageNamed:@"browse_post.png"] forState:UIControlStateNormal];
    
    //时间
    self.timeLabel.text = [NSString stringWithFormat:@"%@  %@",GDLocalizedString(@"楼主"),self.post.createTime];

    //来自频道的名称
    [self.fromPindaoName setTitle:self.post.pindaoName forState:UIControlStateNormal];
    [self.PindaoImage sd_setImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:self.post.pindaoImageID w:60]] placeholderImage:[UIImage imageNamed:@"default_bg.png"]];
    self.fromPindaoName.tag = self.post.pindaoID;
    
    //标题
    NSString *text = self.post.title;
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet  whitespaceAndNewlineCharacterSet]];
    self.subjectLabel.font = PostTitleLabelFont;
    self.subjectLabel.text = text;
    
    //内容
    self.contentTextView.regularMatchArray = self.regularMatchArray;
    
    //地址ico
    
    //地址
    self.loctionAddr.text = self.post.address;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    
    //头像
    //self.txView.frame = CGRectMake(0, 0, 40, 40);
    
    //昵称
    self.nameLabel.frame = CGRectMake(62, 53, 100, 15);
    
    //浏览量
    self.browseBtn.frame = CGRectMake(self.frame.size.width-100, 53, 90, 16);

    //时间
    self.timeLabel.frame = CGRectMake(62, 75, 100, 12);
    
    //来自频道的名称
    self.fromPindaoName.frame = CGRectMake(0, 0, self.frame.size.width, 40);
    self.signImage.frame = CGRectMake(self.fromPindaoName.frame.size.width - 15, 17, 6, 10);
    self.PindaoImage.frame = CGRectMake(10, 8, 25, 25);    
    
    //标题
    CGFloat subjectLabelHeight = [self.class getPostTitleHeightByPost:self.post];
    self.subjectLabel.frame = CGRectMake(HeadBtnLeftWidth, SubjectLabelTop, frame.size.width-2*HeadBtnLeftWidth, subjectLabelHeight);
    self.contentTextViewY = SubjectLabelTop + subjectLabelHeight + 10;

    if (self.post.address && ![self.post.address isEqualToString:@""] && ![self.post.address isEqualToString:@"未知地址"]) {
        
        self.loctionIco.hidden = NO;
        self.loctionAddr.hidden = NO;
        
        //地址ico
        self.loctionIco.frame = CGRectMake(10, frame.size.height-25, 10, 10);
        
        //地址
        self.loctionAddr.frame = CGRectMake(24, frame.size.height-25, 280, 11);
    } else {
        
        self.loctionIco.hidden = YES;
        self.loctionAddr.hidden = YES;
    }
    
    //内容
    CGFloat contentTextViewHeight = [ZBCoreTextView heightFromRegularMatchArray:self.regularMatchArray];
    self.contentTextView.frame = CGRectMake(HeadBtnLeftWidth, self.contentTextViewY, DeviceWidth-2*HeadBtnLeftWidth, contentTextViewHeight);
    
    //底端线
    self.bottomLine.frame = CGRectMake(0, frame.size.height-0.5, frame.size.width, 0.5);
    
    self.tableView.tableHeaderView = self;
}

- (void)clickedHeadPortrait:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(postView:clickedHeadPortraitFromUid:imageID:)]) {
        [self.delegate postView:self clickedHeadPortraitFromUid:self.post.uid imageID:self.post.userImageId];
    }
}

- (void)clickedPindaoName:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(postView:clickedPindaoName:pindaoID:)]) {
        [self.delegate postView:self clickedPindaoName:self.post.pindaoName pindaoID:[NSString stringWithFormat:@"%ld",(long)self.post.pindaoID]];
    }

}

#pragma mark -- ZBCoreTextViewDelegate
- (void)coreTextViewShouldRefresh:(ZBCoreTextView *)coreTextView {
    if ([self.delegate respondsToSelector:@selector(postViewShouldRefresh:)]) {
        [self.delegate postViewShouldRefresh:self];
    }
}
- (void)coreTextView:(ZBCoreTextView *)View clickedImageView:(UIImageView *)imageView imageID:(NSString *)imageID {
    if ([self.delegate respondsToSelector:@selector(postView:clickedImageView:imageID:)]) {
        [self.delegate postView:self clickedImageView:imageView imageID:imageID];
    }
}
- (void)coreTextView:(ZBCoreTextView *)view textTouchBeginRun:(ZBRichTextRun *)run {
    if ([self.delegate respondsToSelector:@selector(postView:textTouchBeginRun:)]) {
        [self.delegate postView:self textTouchBeginRun:run];
    }
}
- (void)coreTextView:(ZBCoreTextView *)view textTouchEndRun:(ZBRichTextRun *)run {
    if ([self.delegate respondsToSelector:@selector(postView:textTouchEndRun:)]) {
        [self.delegate postView:self textTouchEndRun:run];
    }
}
- (void)coreTextView:(ZBCoreTextView *)view textTouchCanceledRun:(ZBRichTextRun *)run {
    if ([self.delegate respondsToSelector:@selector(postView:textTouchCanceledRun:)]) {
        [self.delegate postView:self textTouchCanceledRun:run];
    }
}

- (void)dealloc {

}

@end
