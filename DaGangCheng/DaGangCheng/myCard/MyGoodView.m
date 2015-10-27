//
//  MyGoodView.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/9/29.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "MyGoodView.h"

@implementation MyGoodView



-(instancetype)initGoodViewWithGoodName:(NSString *)goodName goodNum:(NSString *)goodNum{
    
    self=[super init];
    if (self) {
        UILabel *goodNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0,DeviceWidth*0.5, 48)];
        goodNameLabel.text=goodName;
        [self addSubview:goodNameLabel];
        
        UILabel *goodNumLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodNameLabel.frame), 0, DeviceWidth*0.2, 48)];
        goodNumLabel.text=[NSString stringWithFormat:@"x%@",goodNum];
        
        [self addSubview:goodNumLabel];
        

        
    }
    return self;
}




@end
