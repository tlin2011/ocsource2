//
//  ZBChat.m
//  DaGangCheng
//
//  Created by huaxo on 15-7-10.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBChat.h"

@implementation ZBChat

+ (ZBChat *)chatFromJson:(NSDictionary *)json {
    
    ZBChat *chat = [[ZBChat alloc] init];
    chat.imgID = ZBJsonNumber(json[@"img_id"]);
    chat.msg = ZBJsonObject(json[@"msg"]);
    chat.msgID = ZBJsonNumber(json[@"msg_id"]);
    chat.createTime = ZBJsonNumber(json[@"time"]);
    chat.userImageID = ZBJsonNumber(json[@"tx_id"]);
    chat.uid = ZBJsonNumber(json[@"uid"]);
    
    NSString *createTime = [TimeUtil getFriendlySimpleTime:[NSNumber numberWithInteger:chat.createTime]];
    chat.combinationCreateTime = createTime;
    
    return chat;
}

@end
