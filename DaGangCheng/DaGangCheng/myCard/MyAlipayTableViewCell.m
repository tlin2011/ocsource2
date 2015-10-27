//
//  MyAlipayTableViewCell.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/25.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "MyAlipayTableViewCell.h"




@implementation MyAlipayTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickSelect:(UIButton *)sender {

    BOOL flag=sender.selected;

    sender.selected=!flag;
    
    if ([self.alipayCellDelegate respondsToSelector:@selector(clickSelectBtn:)]) {
        [self.alipayCellDelegate clickSelectBtn:flag];
    }
}
@end
