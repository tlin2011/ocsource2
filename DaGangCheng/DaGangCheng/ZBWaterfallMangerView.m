//
//  ZBWaterfallMangerView.m
//  DaGangCheng
//
//  Created by huaxo on 15-2-26.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBWaterfallMangerView.h"


@interface ZBWaterfallMangerView ()
@property (nonatomic, strong) UIButton *praiseBtn;
@property (nonatomic, strong) UILabel *praiseLab;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *collectionBtn;
@end

@implementation ZBWaterfallMangerView
static ZBWaterfallMangerView *sharedManager = nil;
+(ZBWaterfallMangerView *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    self.praiseBtn = [[UIButton alloc] init];
    [self.praiseBtn setImage:[UIImage imageNamed:@"瀑布流_赞.png"] forState:UIControlStateNormal];
    [self.praiseBtn setImage:[UIImage imageNamed:@"瀑布流_赞_s.png"] forState:UIControlStateSelected];
    [self.praiseBtn addTarget:self action:@selector(clickedPraiseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.praiseBtn];
    
    self.praiseLab = [[UILabel alloc] init];
    self.praiseLab.textColor = [UIColor whiteColor];
    self.praiseLab.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.praiseLab];
    
    self.shareBtn = [[UIButton alloc] init];
    [self.shareBtn setImage:[UIImage imageNamed:@"瀑布流_分享.png"] forState:UIControlStateNormal];
    [self addSubview:self.shareBtn];
    
    self.collectionBtn = [[UIButton alloc] init];
    [self.collectionBtn setImage:[UIImage imageNamed:@"瀑布流_收藏.png"] forState:UIControlStateNormal];
    [self addSubview:self.collectionBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    
    self.praiseBtn.frame = CGRectMake(0, 0, 32, 32);
    [self addSubview:self.praiseBtn];
    
    self.praiseLab.frame = CGRectMake(32, 0, frame.size.width-3*32, 32);
    self.praiseLab.text = [NSString stringWithFormat:@"%ld",(long)self.post.zan];
    
    self.shareBtn.frame = CGRectMake(frame.size.width-2*32, 0, 32, 32);
    [self addSubview:self.shareBtn];
    
    self.collectionBtn.frame = CGRectMake(frame.size.width-32, 0, 32, 32);
    [self addSubview:self.collectionBtn];
}

- (void)clickedPraiseBtn:(UIButton *)sender {
    if (self.praiseBtn.selected==YES) {
        return;
    }
    //点赞
    [ZBPraise praiseWithKindId:self.post.postId getPraiseUid:self.post.uid praisedUid:[HuaxoUtil getUdidStr] praiseKind:ZBPraiseKindPost completed:^(BOOL result, NSString *msg, NSError *error) {
        if (result == YES) {
            self.praiseBtn.selected = YES;
            NSString *praiseNum = [self.praiseBtn titleForState:UIControlStateNormal];
            praiseNum = [NSString stringWithFormat:@"%ld",(long)[praiseNum integerValue]+1];
            [self.praiseBtn setTitle:praiseNum forState:UIControlStateSelected];
        }
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
