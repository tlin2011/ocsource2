//
//  Pindao.m
//  DaGangCheng
//
//  Created by huaxo on 14-10-28.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "Pindao.h"
#import "TimeUtil.h"

@implementation Pindao

+ (Pindao *)getPindaoByJson:(NSDictionary *)json {
    Pindao *pindao = [[Pindao alloc] init];
    
    pindao.pindaoId = [NSString stringWithFormat:@"%@", json[@"id"]?json[@"id"]:json[@"kind_id"]];
    pindao.uid = [NSString stringWithFormat:@"%@", json[@"uid"]];
    pindao.name = (json[@"kind"]?json[@"kind"]:json[@"title"])?(json[@"kind"]?json[@"kind"]:json[@"title"]):json[@"bbs_kind"];
    pindao.imageId = [NSString stringWithFormat:@"%ld", (long)[json[@"img_id"] integerValue]];
    pindao.todayPostNum = [NSString stringWithFormat:@"%ld",(long)[json[@"cur_post_num"] integerValue]] ;
    pindao.gps_lat = [json[@"gps_lat"] floatValue];
    pindao.gps_lng = [json[@"gps_lng"] floatValue];
    pindao.desc = json[@"desc"];
    pindao.addr = json[@"addr"];
    pindao.tips = json[@"tips"];
    pindao.distance = [NSString stringWithFormat:@"%@", json[@"distance"]];
    pindao.userNum = [NSString stringWithFormat:@"%ld", (long)[json[@"user_num"] integerValue]];
    
    pindao.statusValue = [json[@"k_status"] integerValue];
    
    NSNumber *timeNum = [NSNumber numberWithLong:[json[@"create_time"] integerValue]];
    NSString* timeStr = [TimeUtil getFriendlySimpleTime:timeNum];
    pindao.createTime = timeStr;
    
    pindao.kindId = [NSString stringWithFormat:@"%ld", (long)[json[@"class_id"] integerValue]];
    pindao.kindName = json[@"class_name"];
    pindao.postNum = [NSString stringWithFormat:@"%ld", (long)[json[@"post_num"] integerValue]];
    pindao.replyNum = [NSString stringWithFormat:@"%ld", (long)[json[@"reply_num"] integerValue]];
    
    return pindao;
}
@end
