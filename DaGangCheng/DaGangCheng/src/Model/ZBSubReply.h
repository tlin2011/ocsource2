//
//  ZBSubReply.h
//  DaGangCheng
//
//  Created by huaxo on 15-6-30.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBPost.h"
#import "TimeUtil.h"

@interface ZBSubReply : ZBPost

@property (assign, nonatomic) long ID;
@property (copy,   nonatomic) NSString *content;
@property (assign, nonatomic) long createTime;
@property (assign, nonatomic) long userImageID;
@property (assign, nonatomic) long uid;
@property (copy,   nonatomic) NSString *userName;
@property (copy,   nonatomic) NSString *combinationContent;
@property (copy,   nonatomic) NSString *combinationCreateTime;

@property (assign, nonatomic) NSRange range; //记录在数组中的位置
//缓存高度
@property (assign, nonatomic) CGRect rect;

+ (ZBSubReply *)subReplyFromJson:(NSDictionary *)json;

@end
