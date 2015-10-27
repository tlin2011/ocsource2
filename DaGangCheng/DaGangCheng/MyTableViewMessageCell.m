//
//  MyTableViewMessageCell.m
//  DaGangCheng
//
//  Created by huaxo on 15-7-22.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "MyTableViewMessageCell.h"
#import "UIImage+Color.h"

@implementation MyTableViewMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    //我的动态Ico
    self.myDynamicIco = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.myDynamicIco.image = [UIImage imageNamed:@"我的卡包.png"];
    self.myDynamicIco.contentMode = UIViewContentModeCenter;
    [self addSubview:self.myDynamicIco];
    
    //我的动态Label
    self.myDynamicLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.myDynamicLabel.textAlignment = NSTextAlignmentCenter;
    self.myDynamicLabel.font = [UIFont systemFontOfSize:14];
    self.myDynamicLabel.textColor = UIColorFromRGB(0x333333);
    self.myDynamicLabel.text = GDLocalizedString(@"我的卡包");
    [self.contentView addSubview:self.myDynamicLabel];
    
    //我的动态按钮
    self.myDynamicButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.myDynamicButton addTarget:self action:@selector(clickedMyDynamicButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.myDynamicButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0 alpha:0.2] andSize:CGSizeMake(2, 2)] forState:UIControlStateHighlighted];
    [self addSubview:self.myDynamicButton];
    
    //我的动态消息标签
    self.myDynamicTipLabel = [[TipLabel alloc] init];
    [self addSubview:self.myDynamicTipLabel];
    
    //line
    self.line = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.line.backgroundColor = UIColorFromRGB(0xe5e5e5);
    [self addSubview:self.line];
    
    //我的聊天Ico
    self.myTalkIco = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.myTalkIco.contentMode = UIViewContentModeCenter;
    self.myTalkIco.image = [UIImage imageNamed:@"我的聊天.png"];
    [self addSubview:self.myTalkIco];
    
    //我的聊天Label
    self.myTalkLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.myTalkLabel.textAlignment = NSTextAlignmentCenter;
    self.myTalkLabel.font = [UIFont systemFontOfSize:14];
    self.myTalkLabel.textColor = UIColorFromRGB(0x333333);
    self.myTalkLabel.text = GDLocalizedString(@"我的聊天");
    [self addSubview:self.myTalkLabel];
    
    //我的聊天按钮
    self.myTalkButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.myTalkButton addTarget:self action:@selector(clickedMyTalkButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.myTalkButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0 alpha:0.2] andSize:CGSizeMake(2, 2)] forState:UIControlStateHighlighted];
    [self addSubview:self.myTalkButton];
    
    //我的聊天消息标签
    self.myTalkTipLabel = [[TipLabel alloc] init];
    [self addSubview:self.myTalkTipLabel];
}

- (void)updateUI {
    //我的动态Ico
    //我的动态Label
    //line
    //我的聊天Ico
    //我的聊天Label
}

+ (CGFloat)heightWithCell {
    return 65;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    
    //我的动态Ico
    self.myDynamicIco.frame = CGRectMake(0, 7, frame.size.width/2.0, 32);
    
    //我的动态Label
    self.myDynamicLabel.frame = CGRectMake(0, 40, frame.size.width/2.0, 16);
    
    //我的动态按钮
    self.myDynamicButton.frame = CGRectMake(0, 0, frame.size.width/2.0, frame.size.height);
    
    //我的动态消息标签
    self.myDynamicTipLabel.center = CGPointMake(frame.size.width*0.25+12, 10);
    
    //line
    self.line.frame = CGRectMake(frame.size.width/2.0, 0, 0.5, frame.size.height);
    
    //我的聊天Ico
    self.myTalkIco.frame = CGRectMake(frame.size.width/2.0, 7, frame.size.width/2.0, 32);
    
    //我的聊天Label
    self.myTalkLabel.frame = CGRectMake(frame.size.width/2.0, 40, frame.size.width/2.0, 16);
    
    //我的聊天按钮
    self.myTalkButton.frame = CGRectMake(frame.size.width/2.0, 0, frame.size.width/2.0, frame.size.height);
    
    //我的聊天消息标签
    self.myTalkTipLabel.center = CGPointMake(frame.size.width*0.75+12, 10);
}

- (void)clickedMyDynamicButton:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(myTableViewMessageCell:clickedMyDynamicButton:)]) {
        
        [self.delegate myTableViewMessageCell:self clickedMyDynamicButton:sender];
    }
}

- (void)clickedMyTalkButton:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(myTableViewMessageCell:clickedMyTalkButton:)]) {
        
        [self.delegate myTableViewMessageCell:self clickedMyTalkButton:sender];
    }
}

@end
