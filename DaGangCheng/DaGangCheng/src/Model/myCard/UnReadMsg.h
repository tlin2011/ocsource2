//
//  UnReadMsg.h
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/28.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnReadMsg : NSObject

@property(nonatomic,copy)NSString * msg_id;
@property(nonatomic,copy)NSString * order_sn;
@property(nonatomic,copy)NSString * msg_title;
@property(nonatomic,copy)NSString * msg_content;
@property(nonatomic,strong)NSNumber * state;
@property(nonatomic,copy)NSString * url;
@property(nonatomic,copy)NSString * create_time_i;

@end
