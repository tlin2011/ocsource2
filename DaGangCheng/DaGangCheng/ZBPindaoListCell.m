//
//  ZBPindaoListCell.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/5/15.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBPindaoListCell.h"
#import "Pindao.h"
#import "UIView+AdjustFrame.h"
#import "UIImageView+WebCache.h"
#import "ApiUrl.h"
#import "PindaoCacher.h"
#import "PindaoIndexViewController.h"

#define kMargin 5

@interface ZBPindaoListCell ()

@property (weak, nonatomic) UIImageView *pindaoImageView;
@property (weak, nonatomic) UIView *view;
@property (weak, nonatomic) UILabel *pindaoNameLabel;
@property (weak, nonatomic) UIButton *fansBtn;
@property (weak, nonatomic) UIButton *postBtn;
@property (weak, nonatomic) UIButton *careBtn;
@property (weak, nonatomic) UILabel *descLabel;
@property (weak, nonatomic) UIImageView *careBgImageView;

@end

@implementation ZBPindaoListCell

//- (void)awakeFromNib {
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubviews];
        self.contentView.backgroundColor = UIColorFromRGB(0xf7f8f8);
        // 设置选中风格
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)initSubviews
{
    UIImageView *pindaoImageView = [[UIImageView alloc] init];
    self.pindaoImageView = pindaoImageView;
    [self.contentView addSubview:pindaoImageView];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    [self.contentView addSubview:view];
    
    UILabel *pindaoNameLabel = [[UILabel alloc] init];
    pindaoNameLabel.textAlignment = NSTextAlignmentLeft;
    pindaoNameLabel.font = [UIFont systemFontOfSize:17];
    pindaoNameLabel.textColor = UIColorFromRGB(0x32373e);
    self.pindaoNameLabel = pindaoNameLabel;
    [view addSubview:pindaoNameLabel];
    
    UIButton *fansBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fansBtn setImage:[UIImage imageNamed:@"粉丝数Icon.png"] forState:UIControlStateNormal];
    [fansBtn setTitleColor:UIColorFromRGB(0x98999a) forState:UIControlStateNormal];
    fansBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];    
    fansBtn.userInteractionEnabled = NO;
    fansBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    fansBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
    self.fansBtn = fansBtn;
    [view addSubview:fansBtn];
    
    UIButton *postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [postBtn setImage:[UIImage imageNamed:@"帖数_社区.png"] forState:UIControlStateNormal];
    [postBtn setTitleColor:UIColorFromRGB(0x98999a) forState:UIControlStateNormal];
    postBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    postBtn.userInteractionEnabled = NO;
    postBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    postBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
    self.postBtn =postBtn;
    [view addSubview:postBtn];
    
    UIImageView *careBgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    careBgImageView.layer.cornerRadius = 2.0;
    careBgImageView.layer.masksToBounds = YES;
    self.careBgImageView = careBgImageView;
    [view addSubview:careBgImageView];
    
    UIButton *careBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    careBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    careBtn.layer.cornerRadius = 2.0;
    careBtn.layer.masksToBounds = YES;
    //[careBtn setBackgroundImage:[UIImage imageWithColor:UIColorWithMobanTheme andSize:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    [careBtn setImage:[UIImage imageNamed:@"社区频道分类_+.png"] forState:UIControlStateNormal];
    NSString *unfocus = [NSString stringWithFormat:@" %@",[ZBAppSetting standardSetting].unfocusName];
    [careBtn setTitle:unfocus forState:UIControlStateNormal];
    [careBtn setTitleColor:UIColorWithMobanThemeSub forState:UIControlStateNormal];
    //[careBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0x868788) andSize:CGSizeMake(10, 10)] forState:UIControlStateSelected];
    [careBtn setImage:[[UIImage alloc] init] forState:UIControlStateSelected];
    NSString *focus = [NSString stringWithFormat:@"%@",[ZBAppSetting standardSetting].focusName];
    [careBtn setTitle:focus forState:UIControlStateSelected];
    [careBtn setTitleColor:UIColorWithMobanThemeSub forState:UIControlStateSelected];
    //
    [careBtn addTarget:self action:@selector(focus:) forControlEvents:UIControlEventTouchUpInside];
    self.careBtn =careBtn;
    [view addSubview:careBtn];
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.textAlignment = NSTextAlignmentLeft;
    descLabel.font = [UIFont systemFontOfSize:12.0];
    descLabel.textColor = UIColorFromRGB(0x98999a);
    descLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.descLabel = descLabel;
    [view addSubview:descLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.pindaoImageView.frame = CGRectMake(8, 8, 70, 70);
    
    self.view.frame = CGRectMake(CGRectGetMaxX(self.pindaoImageView.frame), 8, self.width - 70 - 2 * 8, 70);
    
    self.pindaoNameLabel.x = kMargin;
    self.pindaoNameLabel.y = kMargin;
    
    self.fansBtn.frame = CGRectMake(self.pindaoNameLabel.x, CGRectGetMaxY(self.pindaoNameLabel.frame) + kMargin, 46, 12);
    
    self.postBtn.frame = CGRectMake(CGRectGetMaxX(self.fansBtn.frame), self.fansBtn.y, 46, 12);
    
    self.careBtn.frame = CGRectMake(self.view.width - 58, CGRectGetMaxY(self.pindaoNameLabel.frame)-10, 54, 44);
    self.careBgImageView.frame = CGRectMake(self.view.width - 58, CGRectGetMaxY(self.pindaoNameLabel.frame), 54, 24);
    
    self.descLabel.frame = CGRectMake(kMargin, self.view.height - kMargin - 12, self.view.width - 2 * 8, 12);
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"list";
    ZBPindaoListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

// 重写set方法赋值
- (void)setPd:(Pindao *)pd
{
    _pd = pd;
    [self.pindaoImageView sd_setImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:[pd.imageId integerValue] w:100]] placeholderImage:[UIImage imageNamed:@"频道默认图片.png"]];
    self.pindaoNameLabel.text = pd.name;
    [self.pindaoNameLabel sizeToFit];
    [self.fansBtn setTitle:[ZBNumberUtil shortStringByString:pd.userNum] forState:UIControlStateNormal];
    [self.postBtn setTitle:[ZBNumberUtil shortStringByString:pd.postNum] forState:UIControlStateNormal];
    self.descLabel.text = pd.desc;
    
    if ([PindaoCacher isFocused:HUASHUO_PD kindID:pd.pindaoId]) {
        self.careBtn.selected = YES;
        self.careBgImageView.backgroundColor = UIColorFromRGB(0x868788);
    } else {
        //按钮设置
        self.careBtn.selected = NO;
        self.careBgImageView.backgroundColor = UIColorWithMobanTheme;
    }
}

- (void)focus:(UIButton *)sender {
    
    NSString *kindId = self.pd.pindaoId;
    BOOL ret = NO;
    if (sender.selected) {
        sender.selected = NO;
        self.careBgImageView.backgroundColor = UIColorWithMobanTheme;
        ret = [PindaoCacher unfocusPindao:HUASHUO_PD kindId:kindId];
    }
    else
    {
        if(kindId==nil) return ;
        //按钮设置
        sender.selected = YES;
        self.careBgImageView.backgroundColor = UIColorFromRGB(0x868788);
        
        ret = [PindaoCacher focusPindao:self.pd.name kind:HUASHUO_PD kindID:[NSNumber numberWithFloat:[kindId floatValue]] imgID:[NSNumber numberWithInteger:[self.pd.imageId integerValue]] desc:self.pd.desc];
    }
    
    if(ret){
        [PindaoCacher forceSaveToNetwork];
    }
}

@end