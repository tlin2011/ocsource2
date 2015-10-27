//
//  ZBReply.h
//  DaGangCheng
//
//  Created by huaxo on 15-6-30.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBSubReply.h"
#import "ZBPost.h"

@interface ZBReply : ZBPost

@property (assign, nonatomic) int64_t ID;
@property (copy,   nonatomic) NSString *content;
@property (assign, nonatomic) long createTime;
@property (assign, nonatomic) int64_t userImageID;
@property (assign, nonatomic) long uid;
@property (copy,   nonatomic) NSString *userName;


@property (assign, nonatomic) BOOL isPraised;
@property (assign, nonatomic) long praiseNumber;
@property (assign, nonatomic) long layerNumber;
@property (copy,   nonatomic) NSDictionary *imageWHs;
@property (strong, nonatomic) NSArray *subReplys;

@property (assign, nonatomic) NSRange range; //记录在数组中的位置

//缓存高度
@property (strong, nonatomic) NSArray *regularMatchArray;
@property (assign, nonatomic) CGRect rect;

/**
 *  json转换
 */
+ (ZBReply *)replyFromJson:(NSDictionary *)json;
@end
