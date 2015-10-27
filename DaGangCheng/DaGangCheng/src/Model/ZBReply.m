//
//  ZBReply.m
//  DaGangCheng
//
//  Created by huaxo on 15-6-30.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBReply.h"



@implementation ZBReply

+ (ZBReply *)replyFromJson:(NSDictionary *)json {
    
    ZBReply *reply = [[ZBReply alloc] init];
    reply.ID = ZBJsonNumber(json[@"reply_id"]);
    reply.content = ZBJsonObject(json[@"content"]);
    reply.createTime = ZBJsonNumber(json[@"reply_time"]);
    reply.userImageID = ZBJsonNumber(json[@"tx_id"]);
    reply.uid = ZBJsonNumber(json[@"uid"]);
    reply.userName = ZBJsonObject(json[@"user_name"]);
    
    reply.isPraised = ZBJsonNumber(json[@"isPraise"]);
    reply.praiseNumber = ZBJsonNumber(json[@"praise_num"]);
    reply.layerNumber = ZBJsonNumber(json[@"layer"]);
    reply.imageWHs = ZBJsonObject(json[@"img_wh"]);
    reply.subReplys = ZBJsonObject(json[@"sub_list"]);
    
    /**
     *  子评论转换
     */
    if (reply.subReplys) {
        NSMutableArray *mArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in reply.subReplys) {
            if ([dic isKindOfClass:[NSDictionary class]]) {
                ZBSubReply *subReply = [ZBSubReply subReplyFromJson:dic];
                [mArr addObject:subReply];
            }
        }
        reply.subReplys = mArr.count>0?mArr:reply.subReplys;
    }

    
    return reply;
}

@end
