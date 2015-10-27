//
//  MyGoodsTableViewCell.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/9/29.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "MyGoodsTableViewCell.h"

#import "MyGoodView.h"

@implementation MyGoodsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    return self;
}



-(void)initWithTitle:(NSString *)mtitle data:(NSArray *)dataArray{
    
    self.titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(12, 0, 80, 48)];
    self.titleLabel.text=mtitle;
    [self.contentView addSubview:self.titleLabel];
    
    for (int i=0; i<dataArray.count; i++) {
        NSDictionary *dataTemp=dataArray[i];
        
        MyGoodView *goodView=[[MyGoodView alloc] initGoodViewWithGoodName:dataTemp[@"goods_name"] goodNum:dataTemp[@"goods_num"]];
        goodView.frame=CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+12,48*i,self.contentView.frame.size.width-80,46);
        
        [self.contentView addSubview:goodView];
        
        if (i!=dataArray.count-1) {
            UILabel *buttonLine=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(goodView.frame),CGRectGetMaxY(goodView.frame),DeviceWidth*0.7,0.5)];
            buttonLine.backgroundColor=[UIColor grayColor];
            [self.contentView addSubview:buttonLine];
        }
    }

}


@end
