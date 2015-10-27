//
//  ZBSubReply.m
//  DaGangCheng
//
//  Created by huaxo on 15-6-30.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBSubReply.h"

@implementation ZBSubReply

+ (ZBSubReply *)subReplyFromJson:(NSDictionary *)json {
    
    ZBSubReply *subReply = [[ZBSubReply alloc] init];
    subReply.ID = ZBJsonNumber(json[@"sub_id"]);
    subReply.content = ZBJsonObject(json[@"content"]);
    subReply.createTime = ZBJsonNumber(json[@"reply_time"]);
    subReply.userImageID = ZBJsonNumber(json[@"tx_id"]);
    subReply.uid = ZBJsonNumber(json[@"uid"]);
    subReply.userName = ZBJsonObject(json[@"user_name"]);
    
    NSString *createTime = [TimeUtil getFriendlySimpleTime:[NSNumber numberWithLong:subReply.createTime]];
    subReply.combinationCreateTime = createTime;
    
    NSString *combinationContent = [NSString stringWithFormat:@"%@: %@   %@",subReply.userName,subReply.content,subReply.combinationCreateTime];

    subReply.combinationContent = combinationContent;
    
    return subReply;
}

@end
